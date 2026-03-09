# Plan: `code-principles`

## Context

A **principle-based system** for AI-assisted coding that:

1. Names principles by what they DO, not who said them
2. Credits originators properly with full citations (ISBN, DOI, URL)
3. Works for both code generation AND review
4. Uses a layered activation model (universal → contextual → risk-elevated)
5. Produces severity-categorized output with referenceable IDs

**License:** CC BY-SA 4.0 for principle texts; MIT for scripts

---

## Progress Tracker

### Phase 1 — Repository Setup
- [x] Create repo `code-principles` with `git init`
- [x] Add README.md with project overview
- [x] Add LICENSE (CC BY-SA 4.0 for texts, MIT for scripts)
- [x] Create directory structure (`principles/`, `layers/`, `targets/claude-code/`)
- [x] Save this plan as `PLAN.md` in repo root

### Phase 2 — Principle Format & Examples
- [x] Create principle template file (`principles/TEMPLATE.md`)
- [x] Write 5 example principles (SD-001, SEC-001, CS-001, DX-001, RL-001)
- [x] Create `principles/catalog.yaml` master index with initial entries

### Phase 3 — Batch 1: Universal Classics (77 principles)
- [x] SOLID principles → SD-001 through SD-005
- [x] GoF 23 design patterns → SD-006 through SD-028
- [x] GoF meta-principles → SD-006 (composition), SD-007 (program to interface)
- [x] Kent Beck's 4 Rules of Simple Design → SD-029 through SD-032
- [x] OWASP Top 10 → SEC-001 through SEC-011
- [x] 12-Factor App → AR-001 through AR-012
- [x] Fowler's top code smells → CS-001 through CS-010
- [x] Bloch's Effective Java (most cited items) → API-001 through API-010
- [x] Update `catalog.yaml` with all Batch 1 entries

### Phase 4 — Batch 2: Domain-Specific (71 principles)
- [x] Concurrency patterns (Goetz) → CC-001 through CC-008
- [x] DDD tactical patterns (Evans) → DM-001 through DM-008
- [x] Enterprise Integration Patterns (Hohpe & Woolf) → AR-013 through AR-015
- [x] Clean Architecture principles (Martin) → AR-016 through AR-019
- [x] REST constraints (Fielding) → API-011 through API-015
- [x] Testing patterns (Beck) → TS-001 through TS-008
- [x] Reliability patterns (Kleppmann, Nygard) → RL-002 through RL-007
- [x] Performance patterns (Thompson, Knuth) → PF-001 through PF-005
- [x] Observability principles (Majors) → OB-001 through OB-005
- [x] Infrastructure as Code (Morris) → AR-020 through AR-024
- [x] UX heuristics (Nielsen, Norman, Tufte) → DX-006 through DX-010
- [x] Type & Pattern Safety (Wlaschin, Minsky) → TP-001 through TP-005
- [x] Developer Experience additions → DX-002 through DX-005
- [x] Update `catalog.yaml` with all Batch 2 entries

### Phase 5 — Layer Definitions
- [x] Write `layers/layer-1-universal.md` (14 always-on principles)
- [x] Write `layers/layer-2-contexts.yaml` (12 context groups → principle mapping)
- [x] Write `layers/layer-3-risk-signals.yaml` (7 risk signals → elevated principles)

### Phase 6 — Slash Commands
- [x] Build `targets/claude-code/prepare-coding.md` (scan context + activate principles)
- [x] Build `targets/claude-code/review-code.md` (scan + activate + review with severity)

### Phase 7 — Deployment & Verification
- [x] Build `install.sh` (deploy commands to `~/.claude/commands/`)
- [ ] Create sample codebase with known issues for testing
- [ ] Test `/review-code` — verify severity categorization and principle IDs
- [ ] Test `/prepare-coding` — verify correct principle activation
- [ ] End-to-end: generate code with `/prepare-coding`, then `/review-code` it

### Phase 8 — Wrap Up
- [ ] Archive `ai-review-personas` repo
- [ ] Add PR template for community contributions (principle + source required)
- [ ] Add CONTRIBUTING.md with moderation guidelines

---

## Key Design Decisions

### Repository Structure

```
code-principles/
├── README.md
├── LICENSE
├── PLAN.md                            → This file (progress tracking)
├── CONTRIBUTING.md                    → How to submit new principles
├── install.sh                         → Deploy to ~/.claude/commands/
│
├── principles/                        → THE CATALOG (source of truth)
│   ├── TEMPLATE.md                    → Template for new principles
│   ├── catalog.yaml                   → Master index of all principles
│   ├── SEC/                           → Security
│   ├── CS/                            → Code Smells & Refactoring
│   ├── API/                           → API Design
│   ├── CC/                            → Concurrency
│   ├── DM/                            → Domain Modeling
│   ├── SD/                            → Software Design (SOLID, GoF, composition)
│   ├── TP/                            → Type & Pattern Safety
│   ├── RL/                            → Reliability & Error Handling
│   ├── PF/                            → Performance
│   ├── TS/                            → Testing Strategy
│   ├── OB/                            → Observability & Operations
│   ├── DX/                            → Developer Experience (naming, readability)
│   └── AR/                            → Architecture
│
├── layers/
│   ├── layer-1-universal.md           → ~10 principles that always apply
│   ├── layer-2-contexts.yaml          → Context → principle mapping
│   └── layer-3-risk-signals.yaml      → Risk signal → elevated principles
│
└── targets/
    └── claude-code/
        ├── prepare-coding.md          → Scan context, activate principles for generation
        └── review-code.md             → Scan, activate, review with severity output
```

### Individual Principle File Format

```markdown
# SEC-001 — Validate input at system boundaries

**Layer:** 1 (universal)
**Categories:** security, reliability, api-design
**Languages:** all

## Principle

[2-4 sentence description of the principle]

## Why it matters

[Why violating this causes real problems]

## Violations to detect

- [Specific anti-pattern 1]
- [Specific anti-pattern 2]
- ...

## Good practice

- [Concrete recommendation 1]
- [Concrete recommendation 2]
- ...

## Sources

- Author. *Title*, edition. Publisher, year. ISBN. Chapter/Item.
- Author/Org. "Title." URL
```

### Source Citation Format

Every principle MUST have at least one source:

| Type | Format |
|---|---|
| Book | Author. *Title*, edition. Publisher, year. ISBN. Chapter/Item. |
| Paper | Author. "Title." *Journal/Conf*, year. DOI. |
| Web | Author/Org. "Title." URL (accessed YYYY-MM-DD). |
| Standard | Org. "Standard Name", version. Identifier. |

### Layer System

**Layer 1 — Universal** (~10 principles, always loaded):
Cross-cutting, language-agnostic, non-negotiable.

**Layer 2 — Context-activated** (selected based on what you're building):
Triggered by language, framework, and domain signals detected in the code.

**Layer 3 — Risk-elevated** (escalated based on risk signals):
Triggered by sensitive contexts like authentication, financial transactions, PII handling.

### Slash Commands

**`/prepare-coding`** — activate before writing code:
1. Scan context (language, framework, domain, risk signals)
2. Activate Layer 1 + relevant Layer 2 + elevated Layer 3
3. Output active principle table
4. AI writes code with these principles as active frame

**`/review-code`** — review after writing code:
1. Resolve input (file, directory, inline code)
2. Scan & activate (same as prepare-coding)
3. Review and group findings by severity:
   - **Critical** — must fix (security holes, data loss, crashes)
   - **High** — important (correctness, concurrency, API contract)
   - **Medium** — should address (design, maintainability)
   - **Low** — nice to have (naming, style, minor smells)
4. Summary: X critical, Y high, Z medium, W low + list of active principle IDs

### What This Repo Does NOT Do

- No MCP servers, no external dependencies
- No runtime code — pure markdown and YAML
- No opinions on IDE or AI tool — portable to Claude Code, Copilot, Cursor, etc.
- No enforcement — these are principles, not linter rules
- No personal/original principles in v1 — third-party verifiable sources only
