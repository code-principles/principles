#!/usr/bin/env bash
set -euo pipefail

# install.sh — Deploy code-principles to AI coding tools
#
# Usage:
#   ./install.sh claude              # Install Claude Code slash commands
#   ./install.sh copilot [project]   # Generate Copilot instructions for a project
#   ./install.sh cursor [project]    # Generate Cursor rules for a project
#   ./install.sh all [project]       # Install all targets
#   ./install.sh --uninstall         # Remove Claude Code commands
#   ./install.sh --list              # Show what's installed

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_COMMANDS_DIR="$HOME/.claude/commands"

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

install_claude() {
    echo -e "${BOLD}Installing Claude Code slash commands...${NC}"

    mkdir -p "$CLAUDE_COMMANDS_DIR"

    local count=0
    for file in "$SCRIPT_DIR/targets/claude-code/"*.md; do
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
    echo "  /prepare-coding  — Scan context and activate principles before coding"
    echo "  /review-code     — Review code with severity-categorized findings"
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

    mkdir -p "$target_dir"

    # Check if file exists and has content
    if [ -f "$target_file" ] && [ -s "$target_file" ]; then
        echo -e "${YELLOW}Warning: $target_file already exists.${NC}"
        echo "  Appending code-principles section. Review the file afterward."
        echo "" >> "$target_file"
        echo "<!-- code-principles: begin -->" >> "$target_file"
    else
        echo "<!-- code-principles: begin -->" > "$target_file"
    fi

    # Generate Copilot instructions from the prepare-coding prompt
    cat >> "$target_file" << 'COPILOT_EOF'
# Code Principles — AI Coding Guidelines

When writing or reviewing code in this project, follow the layered principle system below.

## Layer 1 — Always Active (apply to all code)

- **SD-001**: Single Responsibility — one reason to change per module/class/function
- **SD-006**: Favor composition over inheritance
- **SD-007**: Program to an interface, not an implementation
- **SD-029**: Code must pass all tests
- **SD-030**: Code must reveal intention
- **SD-031**: No knowledge duplication
- **SD-032**: Fewest elements — remove anything unnecessary
- **SEC-001**: Validate input at system boundaries
- **CS-001**: Don't repeat knowledge — single authoritative representation
- **DX-001**: Name things by what they represent
- **DX-002**: Keep functions small and single-purpose
- **DX-003**: Write code for the reader, not the writer
- **DX-005**: Delete dead code
- **RL-001**: Fail fast, fail loudly — never silently swallow errors

## Layer 2 — Context-Dependent (activate based on what you're building)

Apply additional principles when working in these contexts:
- **API design**: Follow REST semantics, proper status codes, backward compatibility
- **Concurrency**: Guard shared state, prefer immutability, use structured concurrency
- **Domain modeling**: Use ubiquitous language, bounded contexts, aggregates
- **Testing**: One behavior per test, test behavior not implementation, fast tests
- **Cloud-native**: Follow 12-factor app principles
- **Infrastructure**: Define as code, pipeline-driven changes, immutable infrastructure

## Layer 3 — Risk-Elevated (apply extra scrutiny in high-risk areas)

Elevate severity when code handles:
- **Authentication/sessions**: Enforce access control, strong crypto, proper session management
- **Financial transactions**: Validate rigorously, ensure idempotency, guard shared state
- **Personal data (PII)**: Encrypt, log access, comply with GDPR/CCPA/HIPAA
- **Public APIs**: Never break existing clients, design method signatures carefully
- **Performance-critical paths**: Profile before optimizing, mind data locality and allocation
- **Distributed systems**: Design for fault tolerance, idempotency, circuit breakers
COPILOT_EOF

    echo "<!-- code-principles: end -->" >> "$target_file"

    echo -e "  ${GREEN}✓${NC} $target_file"
    echo ""
    echo "Copilot instructions written. Review and commit the file."
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

    cat > "$target_file" << 'CURSOR_EOF'
---
description: Code principles for writing and reviewing software
globs:
alwaysApply: true
---

# Code Principles — AI Coding Guidelines

When writing or reviewing code, follow the layered principle system below.

## Layer 1 — Always Active

- SD-001: Single Responsibility — one reason to change per module/class/function
- SD-006: Favor composition over inheritance
- SD-007: Program to an interface, not an implementation
- SD-029: Code must pass all tests
- SD-030: Code must reveal intention
- SD-031: No knowledge duplication
- SD-032: Fewest elements — remove anything unnecessary
- SEC-001: Validate input at system boundaries
- CS-001: Don't repeat knowledge
- DX-001: Name things by what they represent
- DX-002: Keep functions small and single-purpose
- DX-003: Write code for the reader, not the writer
- DX-005: Delete dead code
- RL-001: Fail fast, fail loudly

## Layer 2 — Context-Dependent

Apply additional principles when the context matches:
- API design: REST semantics, proper status codes, backward compatibility
- Concurrency: Guard shared state, prefer immutability, structured concurrency
- Domain modeling: Ubiquitous language, bounded contexts, aggregates
- Testing: One behavior per test, behavior over implementation, fast tests
- Cloud-native: 12-factor app principles
- Infrastructure: Define as code, pipeline-driven, immutable

## Layer 3 — Risk-Elevated

Elevate severity for code handling:
- Authentication/sessions: Access control, strong crypto, session management
- Financial transactions: Validation, idempotency, synchronized access
- Personal data (PII): Encryption, access logging, regulatory compliance
- Public APIs: Backward compatibility, careful method signatures
- Performance-critical: Profile first, data locality, allocation pressure
- Distributed systems: Fault tolerance, idempotency, circuit breakers
CURSOR_EOF

    echo -e "  ${GREEN}✓${NC} $target_file"
    echo ""
    echo "Cursor rules written. The rule will apply to all files in the project."
}

uninstall_claude() {
    echo -e "${BOLD}Removing Claude Code slash commands...${NC}"

    local count=0
    for file in prepare-coding.md review-code.md; do
        if [ -f "$CLAUDE_COMMANDS_DIR/$file" ]; then
            rm "$CLAUDE_COMMANDS_DIR/$file"
            count=$((count + 1))
            echo -e "  ${RED}✗${NC} /$(basename "$file" .md)"
        fi
    done

    if [ $count -eq 0 ]; then
        echo "  No commands found to remove."
    else
        echo ""
        echo "Removed $count commands."
    fi
}

list_installed() {
    echo -e "${BOLD}Installed code-principles:${NC}"
    echo ""

    echo "Claude Code commands:"
    local found=false
    for file in prepare-coding.md review-code.md; do
        if [ -f "$CLAUDE_COMMANDS_DIR/$file" ]; then
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
    echo "  copilot [dir]       Generate .github/copilot-instructions.md (default: current dir)"
    echo "  cursor [dir]        Generate .cursor/rules/code-principles.mdc (default: current dir)"
    echo "  all [dir]           Install all targets"
    echo ""
    echo "Management:"
    echo "  --uninstall         Remove Claude Code commands"
    echo "  --list              Show what's installed"
    echo "  --help              Show this help"
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
    --uninstall|-u)
        uninstall_claude
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
