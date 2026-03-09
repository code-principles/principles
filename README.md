# Code Principles

**Expert knowledge as code — portable AI lenses for writing and reviewing software.**

A curated catalog of software engineering principles with proper academic citations, designed to be loaded by AI coding agents (Claude Code, GitHub Copilot, Cursor, etc.) to improve code generation and review.

## What is this?

A collection of **150+ numbered, citable software engineering principles** organized by category, with a layered activation system that selects the right principles based on what you're building.

Each principle has:
- A unique ID (e.g., `SD-001`, `SEC-003`, `CS-007`)
- A clear description of the principle
- What violations look like
- Good practices to follow
- Full source citations (ISBN, DOI, URL)

## How it works

### The Layer Model

| Layer | When | What |
|-------|------|------|
| **Layer 1 — Universal** | Always active | ~10 non-negotiable principles (validate input, single responsibility, fail fast, etc.) |
| **Layer 2 — Contextual** | Based on what you're building | API design, concurrency, data modeling, etc. — activated by detecting language, framework, and domain signals |
| **Layer 3 — Risk-elevated** | Based on risk signals | Security, performance, backward compatibility — escalated when auth, payments, PII, or hot paths are detected |

### Two modes

- **`/prepare-coding`** — Scans your context, activates the right principles, then generates code with those principles as the active frame.
- **`/review-code`** — Scans your code, activates relevant principles, reviews against them, and groups findings by severity (Critical / High / Medium / Low) with principle IDs.

## Quick start

```bash
# Clone the repo
git clone https://github.com/flemming-n-larsen/code-principles.git

# Install Claude Code slash commands
./install.sh claude

# Use it
# In Claude Code:
#   /prepare-coding    → before writing code
#   /review-code       → after writing code
```

## Principle categories

| ID Prefix | Category | Examples |
|-----------|----------|----------|
| `SD-` | Software Design | SOLID, GoF patterns, composition, simplicity |
| `SEC-` | Security | OWASP Top 10, input validation, secrets management |
| `CS-` | Code Smells & Refactoring | Feature envy, long method, primitive obsession |
| `API-` | API Design | Backward compatibility, idempotency, REST constraints |
| `CC-` | Concurrency | Thread safety, structured concurrency, shared-nothing |
| `DM-` | Domain Modeling | Bounded contexts, aggregates, value objects |
| `AR-` | Architecture | 12-Factor, clean architecture, integration patterns |
| `RL-` | Reliability & Error Handling | Fail fast, circuit breakers, idempotent operations |
| `PF-` | Performance | Mechanical sympathy, data locality, backpressure |
| `TS-` | Testing Strategy | TDD, test isolation, behavior-driven specs |
| `OB-` | Observability & Operations | Structured logging, distributed tracing, SLOs |
| `DX-` | Developer Experience | Naming, readability, cognitive load, UX heuristics |
| `TP-` | Type & Pattern Safety | Type-driven design, exhaustive matching, nullability |

## Example review output

```
## Critical
- SEC-002: SQL query built with string concatenation
  UserRepository.java:47 — user input interpolated directly into query string.
  → Use parameterized queries (PreparedStatement).

## High
- CC-003: Shared mutable state without synchronization
  OrderService.java:23 — counter field modified across request threads.
  → Use AtomicInteger or move state into request scope.

## Medium
- CS-004: Feature envy
  OrderService.java:61 — accesses 4 fields from Customer but lives in OrderService.
  → Move method to Customer or extract a domain method.

## Low
- DX-002: Boolean parameter obscures intent
  OrderService.java:89 — processOrder(true) is unclear at call site.
  → Replace with enum or separate methods.

## Summary
Findings: 1 critical, 1 high, 1 medium, 1 low
Active principles: SEC-001..010, CC-001..005, CS-001..010, SD-001..005, DX-001..003
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to submit new principles. Every contribution requires:
- A clear principle description in your own words
- At least one verifiable published source (book with ISBN, paper with DOI, or authoritative URL)
- Categorization and layer assignment

## License

- **Principle texts:** [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) — use freely, credit required, share-alike
- **Scripts and tooling:** [MIT](https://opensource.org/licenses/MIT)
