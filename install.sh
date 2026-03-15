#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Flemming N. Larsen — https://github.com/code-principles/.principles
set -euo pipefail

# install.sh — Deploy code-principles to AI coding tools
#
# Usage:
#   ./install.sh claude              # Install Claude Code slash commands (~/.claude/commands/)
#   ./install.sh copilot [project]   # Generate Copilot assets:
#                                    #   .github/copilot-instructions.md  (all Copilot clients)
#                                    #   .github/skills/<name>/SKILL.md   (Copilot CLI slash commands)
#                                    #   .github/prompts/<name>.prompt.md (VS Code / JetBrains / Visual Studio)
#   ./install.sh cursor [project]    # Generate Cursor rules (.cursor/rules/code-principles.mdc)
#   ./install.sh all [project]       # Install all targets
#   ./install.sh --list              # Show what's installed
#   ./uninstall.sh [project]         # Remove Claude, Copilot, and Cursor assets

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_COMMANDS_DIR="$HOME/.claude/commands"
CLAUDE_TARGETS_DIR="$SCRIPT_DIR/targets/claude-code"

# Colors (if terminal supports them)
if [ -t 1 ]; then
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    RED='\033[0;31m'
    BOLD='\033[1m'
    NC='\033[0m'
else
    GREEN='' YELLOW='' RED='' BOLD='' NC=''
fi

print_header() {
    echo ""
    echo -e "${BOLD}code-principles installer${NC}"
    echo "─────────────────────────"
}

copilot_prompt_description() {
    case "$1" in
        scout)
            echo "Detect project profile and create or update .principles files (Experimental)"
            ;;
        prime)
            echo "Activate code principles before writing code (Experimental)"
            ;;
        audit)
            echo "Review code against the active principles and group findings by severity (Experimental)"
            ;;
        *)
            echo "Run the $1 code-principles workflow (Experimental)"
            ;;
    esac
}

copilot_skill_description() {
    case "$1" in
        scout)
            echo "Analyse the project, detect language/framework/domain, and create or update .principles files. Use this skill when asked to scout, detect project profile, or set up principles."
            ;;
        prime)
            echo "Resolve the .principles hierarchy, load full principle guidance, and prepare a coding frame. Use this skill when asked to prime, activate principles, or before writing code."
            ;;
        audit)
            echo "Resolve the .principles hierarchy, load principle content, review code, and group findings by severity (Critical/High/Medium/Low). Use this skill when asked to audit or review code against principles."
            ;;
        *)
            echo "Run the $1 code-principles workflow."
            ;;
    esac
}

write_principles_body() {
    local target_file="$1"
    cat >> "$target_file" << 'PRINCIPLES_EOF'
# Code Principles — AI Coding Guidelines

When writing or reviewing code, follow the layered principle system below.

## Layer 1 — Always Active

Non-negotiable fundamentals that apply to every line of code: single responsibility, no duplication, reveal intention, fail fast, validate input, delete dead code.

## Layer 2 — Context-Dependent

Additional principles activated by what you're building. Covers API design, concurrency, domain modeling, testing, cloud-native, and infrastructure patterns.

## Layer 3 — Risk-Elevated

Extra scrutiny for high-risk areas where mistakes are costly or hard to reverse: authentication, financial transactions, personal data (PII), public APIs, performance-critical paths, and distributed systems.
PRINCIPLES_EOF
}


write_copilot_skill() {
    local source_file="$1"
    local skill_dir="$2"
    local command_name="$3"

    mkdir -p "$skill_dir"
    local skill_file="$skill_dir/SKILL.md"

    cat > "$skill_file" <<EOF
---
name: $command_name
description: $(copilot_skill_description "$command_name")
license: MIT
---

EOF

    cat "$source_file" >> "$skill_file"
}


write_copilot_prompt() {
    local source_file="$1"
    local prompt_file="$2"
    local command_name="$3"

    cat > "$prompt_file" <<EOF
---
description: $(copilot_prompt_description "$command_name")
---

EOF

    cat "$source_file" >> "$prompt_file"
}

install_claude() {
    echo -e "${BOLD}Installing Claude Code slash commands...${NC}"

    mkdir -p "$CLAUDE_COMMANDS_DIR"

    local count=0
    for file in "$CLAUDE_TARGETS_DIR/"*.md; do
        if [ -f "$file" ]; then
            cp "$file" "$CLAUDE_COMMANDS_DIR/"
            count=$((count + 1))
            echo -e "  ${GREEN}✓${NC} /$(basename "$file" .md)"
        fi
    done

    echo ""
    echo -e "Installed ${BOLD}$count${NC} commands to $CLAUDE_COMMANDS_DIR"
    echo ""
    echo "Available commands:"
    echo "  /scout  — Detect project profile and generate .principles placements"
    echo "  /prime  — Activate principles before writing code"
    echo "  /audit  — Review code with severity-categorized findings"
}

install_copilot() {
    local project_dir="${1:-.}"

    if [ ! -d "$project_dir" ]; then
        echo -e "${RED}Error: Directory '$project_dir' does not exist.${NC}"
        exit 1
    fi

    echo -e "${BOLD}Generating Copilot instructions for: $project_dir${NC}"

    local target_dir="$project_dir/.github"
    local target_file="$target_dir/copilot-instructions.md"
    local prompts_dir="$target_dir/prompts"

    mkdir -p "$target_dir"
    mkdir -p "$prompts_dir"

    # Build the new block in a temp file
    local block_file
    block_file="$(mktemp)"
    echo "<!-- code-principles: begin -->" > "$block_file"
    write_principles_body "$block_file"
    echo "<!-- code-principles: end -->" >> "$block_file"

    if [ ! -f "$target_file" ] || [ ! -s "$target_file" ]; then
        # New or empty file: create with just the block
        cp "$block_file" "$target_file"
    elif grep -q "^<!-- code-principles: begin -->$" "$target_file"; then
        # Existing block found: replace it in-place
        local result_file
        result_file="$(mktemp)"
        awk '
            BEGIN { in_block=0 }
            /^<!-- code-principles: begin -->$/ { in_block=1; next }
            /^<!-- code-principles: end -->$/ { if (in_block) { in_block=0; next } }
            !in_block { print }
        ' "$target_file" > "$result_file"
        # Trim trailing blank lines, then append the new block
        awk '{lines[NR]=$0; if(/[^[:space:]]/) last=NR} END{for(i=1;i<=last;i++) print lines[i]}' \
            "$result_file" > "${result_file}.t" && mv "${result_file}.t" "$result_file"
        [ -s "$result_file" ] && echo "" >> "$result_file"
        cat "$block_file" >> "$result_file"
        mv "$result_file" "$target_file"
    else
        # Existing file without our block: append
        echo "" >> "$target_file"
        cat "$block_file" >> "$target_file"
    fi

    rm -f "$block_file"

    echo -e "${BOLD}Installing Copilot skills and prompt commands...${NC}"

    local prompt_count=0
    local file
    local skills_dir="$target_dir/skills"
    for file in "$CLAUDE_TARGETS_DIR/"*.md; do
        if [ -f "$file" ]; then
            local command_name
            local prompt_file
            command_name="$(basename "$file" .md)"
            prompt_file="$prompts_dir/$command_name.prompt.md"
            # For audit: rewrite ~/.claude/ paths to project-relative paths
            local patched_file
            patched_file="$(mktemp)"
            sed \
                -e 's|~/.claude/audit-output\.json|.github/scripts/audit-output.json|g' \
                "$file" > "$patched_file"
            write_copilot_prompt "$patched_file" "$prompt_file" "$command_name"
            write_copilot_skill "$patched_file" "$skills_dir/$command_name" "$command_name"
            rm -f "$patched_file"
            prompt_count=$((prompt_count + 1))
            echo -e "  ${GREEN}✓${NC} /$command_name"
        fi
    done

    echo -e "  ${GREEN}✓${NC} $target_file"
    echo ""
    echo "Copilot assets written:"
    echo "  - .github/copilot-instructions.md"
    echo "  - .github/skills/<name>/SKILL.md  (${prompt_count} skills  — Copilot CLI slash commands)"
    echo "  - .github/prompts/*.prompt.md      (${prompt_count} prompts — VS Code prompt files)"
    echo ""
    echo "In Copilot CLI: use /audit, /prime, /scout  (or run '/skills reload' if already in a session)"
    echo "In VS Code:     type /audit, /prime, /scout  in Copilot Chat"
}

install_cursor() {
    local project_dir="${1:-.}"

    if [ ! -d "$project_dir" ]; then
        echo -e "${RED}Error: Directory '$project_dir' does not exist.${NC}"
        exit 1
    fi

    echo -e "${BOLD}Generating Cursor rules for: $project_dir${NC}"

    local target_dir="$project_dir/.cursor/rules"
    mkdir -p "$target_dir"

    local target_file="$target_dir/code-principles.mdc"

    cat > "$target_file" << 'CURSOR_FRONTMATTER'
---
description: Code principles for writing and reviewing software
globs:
alwaysApply: true
---
CURSOR_FRONTMATTER

    write_principles_body "$target_file"

    echo -e "  ${GREEN}✓${NC} $target_file"
    echo ""
    echo "Cursor rules written. The rule will apply to all files in the project."
}

list_installed() {
    echo -e "${BOLD}Installed code-principles:${NC}"
    echo ""

    echo "Claude Code commands:"
    local found=false
    for file in "$CLAUDE_TARGETS_DIR/"*.md; do
        if [ -f "$file" ] && [ -f "$CLAUDE_COMMANDS_DIR/$(basename "$file")" ]; then
            echo -e "  ${GREEN}✓${NC} /$(basename "$file" .md)"
            found=true
        fi
    done
    if [ "$found" = false ]; then
        echo "  (none)"
    fi
}

show_usage() {
    print_header
    echo ""
    echo "Usage: $0 <target> [options]"
    echo ""
    echo "Targets:"
    echo "  claude              Install slash commands to ~/.claude/commands/"
    echo "  copilot [dir]       Generate .github/copilot-instructions.md + valid .github/prompts/*.prompt.md files"
    echo "  cursor [dir]        Generate .cursor/rules/code-principles.mdc (default: current dir)"
    echo "  all [dir]           Install all targets"
    echo ""
    echo "Management:"
    echo "  --list              Show what's installed"
    echo "  --help              Show this help"
    echo "  ./uninstall.sh [dir] Remove Claude, Copilot, and Cursor assets"
    echo ""
    echo "Examples:"
    echo "  ./install.sh claude"
    echo "  ./install.sh copilot ~/projects/my-app"
    echo "  ./install.sh all ~/projects/my-app"
}

# Main
print_header

case "${1:-}" in
    claude)
        install_claude
        ;;
    copilot)
        install_copilot "${2:-.}"
        ;;
    cursor)
        install_cursor "${2:-.}"
        ;;
    all)
        install_claude
        echo ""
        install_copilot "${2:-.}"
        echo ""
        install_cursor "${2:-.}"
        ;;
    --list|-l)
        list_installed
        ;;
    --help|-h)
        show_usage
        ;;
    "")
        show_usage
        ;;
    *)
        echo -e "${RED}Unknown target: $1${NC}"
        show_usage
        exit 1
        ;;
esac

echo ""
echo "Done."
