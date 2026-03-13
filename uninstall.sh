#!/usr/bin/env bash
set -euo pipefail

# uninstall.sh — Remove code-principles assets from supported AI coding tools
#
# Usage:
#   ./uninstall.sh [project]   # Remove Claude Code commands and project files
#   ./uninstall.sh --help      # Show this help

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_COMMANDS_DIR="$HOME/.claude/commands"
CLAUDE_TARGETS_DIR="$SCRIPT_DIR/targets/claude-code"
PROJECT_DIR="${1:-.}"

# Colors (if terminal supports them)
if [ -t 1 ]; then
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    BOLD='\033[1m'
    NC='\033[0m'
else
    GREEN='' RED='' BOLD='' NC=''
fi

NEUTRAL='-'

cleanup_dir_if_empty() {
    local dir="$1"

    if [ -d "$dir" ] && [ -z "$(find "$dir" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]; then
        rmdir "$dir"
    fi
}

require_project_dir() {
    if [ ! -d "$PROJECT_DIR" ]; then
        echo -e "${RED}Error: Directory '$PROJECT_DIR' does not exist.${NC}"
        exit 1
    fi
}

print_header() {
    echo ""
    echo -e "${BOLD}code-principles uninstaller${NC}"
    echo "───────────────────────────"
}

show_usage() {
    print_header
    echo ""
    echo "Usage: $0 [project]"
    echo ""
    echo "Removes current code-principles assets for Claude Code, GitHub Copilot, and Cursor."
    echo "Project files are removed from [project] or the current directory when omitted."
    echo ""
    echo "Options:"
    echo "  --help              Show this help"
}

uninstall_claude() {
    echo -e "${BOLD}Removing Claude Code slash commands...${NC}"

    local count=0
    local found_target=false
    local file

    for file in "$CLAUDE_TARGETS_DIR/"*.md; do
        if [ -f "$file" ]; then
            found_target=true
            local installed_file="$CLAUDE_COMMANDS_DIR/$(basename "$file")"
            if [ -f "$installed_file" ]; then
                rm "$installed_file"
                count=$((count + 1))
                echo -e "  ${GREEN}✓${NC} /$(basename "$file" .md)"
            fi
        fi
    done

    if [ "$found_target" = false ]; then
        echo -e "${RED}Error: No Claude Code command templates found in $CLAUDE_TARGETS_DIR.${NC}"
        exit 1
    fi

    if [ $count -eq 0 ]; then
        echo "  ${NEUTRAL} No current commands found to remove."
    else
        echo ""
        echo -e "Removed ${GREEN}$count${NC} commands."
    fi
}

uninstall_copilot() {
    local project_dir="$1"
    local target_file="$project_dir/.github/copilot-instructions.md"
    local prompts_dir="$project_dir/.github/prompts"

    echo -e "${BOLD}Removing GitHub Copilot instructions...${NC}"

    if [ ! -f "$target_file" ]; then
        echo "  ${NEUTRAL} No Copilot instructions found to remove."
        return
    fi

    local temp_file
    temp_file="$(mktemp)"

    awk '
        BEGIN { in_block=0; removed=0 }
        /^<!-- code-principles: begin -->$/ { in_block=1; removed=1; next }
        /^<!-- code-principles: end -->$/   { if (in_block) { in_block=0; next } }
        !in_block { print }
        END { exit removed ? 0 : 1 }
    ' "$target_file" > "$temp_file" || {
        rm -f "$temp_file"
        echo "  ${NEUTRAL} No code-principles Copilot instructions found to remove."
        return
    }

    if grep -q '[^[:space:]]' "$temp_file"; then
        mv "$temp_file" "$target_file"
        echo -e "  ${GREEN}✓${NC} .github/copilot-instructions.md (removed code-principles block)"
    else
        rm -f "$temp_file" "$target_file"
        echo -e "  ${GREEN}✓${NC} .github/copilot-instructions.md"
    fi

    echo ""
    echo -e "${BOLD}Removing GitHub Copilot prompt commands...${NC}"

    local prompt_count=0
    local file
    for file in "$CLAUDE_TARGETS_DIR/"*.md; do
        if [ -f "$file" ]; then
            local prompt_file="$prompts_dir/$(basename "$file" .md).prompt.md"
            if [ -f "$prompt_file" ]; then
                rm "$prompt_file"
                prompt_count=$((prompt_count + 1))
                echo -e "  ${GREEN}✓${NC} .github/prompts/$(basename "$prompt_file")"
            fi
        fi
    done

    if [ $prompt_count -eq 0 ]; then
        echo "  ${NEUTRAL} No Copilot prompt commands found to remove."
    fi

    cleanup_dir_if_empty "$prompts_dir"
    cleanup_dir_if_empty "$project_dir/.github"
}

uninstall_cursor() {
    local project_dir="$1"
    local target_file="$project_dir/.cursor/rules/code-principles.mdc"

    echo -e "${BOLD}Removing Cursor rules...${NC}"

    if [ ! -f "$target_file" ]; then
        echo "  ${NEUTRAL} No Cursor rule found to remove."
        return
    fi

    rm "$target_file"
    echo -e "  ${GREEN}✓${NC} .cursor/rules/code-principles.mdc"

    cleanup_dir_if_empty "$project_dir/.cursor/rules"
    cleanup_dir_if_empty "$project_dir/.cursor"
}

run_uninstall() {
    require_project_dir

    print_header
    echo ""
    uninstall_claude
    echo ""
    uninstall_copilot "$PROJECT_DIR"
    echo ""
    uninstall_cursor "$PROJECT_DIR"
    echo ""
    echo "Done."
}

case "${1:-}" in
    --help|-h)
        show_usage
        ;;
    "")
        run_uninstall
        ;;
    *)
        if [[ "$1" == -* ]]; then
            echo -e "${RED}Unknown option: $1${NC}"
            show_usage
            exit 1
        fi

        run_uninstall
        ;;
esac

