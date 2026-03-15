# Changelog

All notable changes to `.principles` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to [Semantic Versioning](https://semver.org/).

> **Note:** `.principles` is in its early days — this is an experimental release. The system is being actively used and iterated on, but expect rough edges, evolving formats, and breaking changes as things stabilize.

---

## [v0.1.0] — 2026-03-15

**Initial release.**

### Highlights

- **187 principle files** across **13 top-level namespaces** — `12factor`, `arch`, `clean-arch`, `code`, `code-smells`, `ddd`, `effective-java`, `gof`, `grasp`, `infra`, `owasp`, `simple-design`, `solid`
- **30 pre-defined groups** — `@spring-boot`, `@react`, `@angular`, `@django`, `@fastapi`, `@microservices`, `@security-focused`, `@clean-arch`, `@solid`, `@typescript`, and more
- **3 AI commands** — `/scout`, `/prime`, `/audit`
- **3-layer model** — Universal, Contextual, and Risk-Elevated principles
- **Hierarchical `.principles` file resolution** — project-level overrides with inheritance
- **Cross-platform installer** — Bash, PowerShell, and CMD wrapper scripts
- **3 target platforms** — Claude Code, GitHub Copilot, Cursor
- **Full documentation suite** — README, DESIGN.md, INSTALL.md, REQUIREMENTS.md, and more
- **Inspection sections** — `.context-inspect.md` files and inline `## Inspection` sections with `grep` patterns for automated principle verification across `code/` and `solid/` namespaces
- **Improved catalog** — restructured `principles/catalog.yaml` with expanded metadata
- **Enhanced audit command** — richer inspection-driven audit flow in `targets/claude-code/audit.md`
- **CONTRIBUTING.md** — contributor guidelines added
- **Layer refinements** — updated universal layer, context mappings, and risk signals

### What's Next

See [TODO.md](TODO.md) for the roadmap.

---

[v0.1.0]: https://github.com/code-principles/principles/releases/tag/v0.1.0
