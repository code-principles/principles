# Layer 1 — Universal Principles

These principles are **always active** regardless of language, framework, or project context. They represent the foundational rules of good software that apply to every code review. No configuration or context detection is needed — if code is being reviewed, these principles apply.

Layer 1 draws from Kent Beck's four rules of simple design, core SOLID principles, essential security hygiene, and fundamental readability standards.

| ID | Title | Summary |
|----|-------|---------|
| SD-001 | Single Responsibility Principle | A module, class, or function should have one, and only one, reason to change. |
| SD-006 | Favor Composition over Inheritance | Prefer assembling behavior from small, focused components rather than extending base classes. |
| SD-007 | Program to an Interface, Not an Implementation | Depend on abstractions rather than concrete classes to reduce coupling. |
| SD-029 | Passes all tests | Code must pass all its tests; correctness is the first rule of simple design. |
| SD-030 | Reveals intention | Every name, structure, and abstraction should clearly communicate its purpose. |
| SD-031 | No duplication | Every piece of knowledge should have a single, unambiguous representation in the system. |
| SD-032 | Fewest elements | After passing tests, revealing intention, and removing duplication, remove anything that remains unnecessary. |
| SEC-001 | Validate input at system boundaries | Never trust data crossing a trust boundary; validate type, format, range, and length at every entry point. |
| CS-001 | Don't repeat knowledge | Every piece of knowledge must have a single, authoritative representation within the system. |
| DX-001 | Name things by what they represent | Names should reveal intent — what something represents or what it does, not how it works. |
| DX-002 | Keep functions small and single-purpose | Functions should do one thing, do it well, and be small enough to understand at a glance. |
| DX-003 | Write code for the reader, not the writer | Prioritize clarity over cleverness; code is read far more often than it is written. |
| DX-005 | Delete dead code | Remove code that is no longer executed or referenced; it adds noise and misleads readers. |
| RL-001 | Fail fast, fail loudly | Detect errors as early as possible and report them clearly; never silently swallow failures. |
