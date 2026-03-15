# Contributing

> **Scope:** Principles contributed here must be **established, widely recognized concepts** from the software engineering literature — named principles, published patterns, or documented practices backed by authoritative sources. They must not duplicate what is already in the catalog.
>
> If your principle is original, company-specific, domain-niche, or doesn't have an authoritative published source, **fork this repo** and add it in your own namespace (e.g., `principles/corp/`) rather than submitting a PR.

## Requirements

Every new principle must have:

- A clear principle description in your own words
- At least one verifiable published source (book with ISBN, paper with DOI, or authoritative URL)
- Correct layer assignment (1 = universal, 2 = contextual, 3 = risk-elevated)
- At least one "Violations to detect" entry
- No significant overlap with an existing principle in the catalog

## Process

1. Copy `principles/code/TEMPLATE.md` to the appropriate category directory
2. Fill in all sections — see [DESIGN.md Section 4](DESIGN.md#-4-principle-file-schema) for the full schema
3. Derive the ID from the file path — see [DESIGN.md Section 3](DESIGN.md#-3-id-derivation)
4. Add the principle to relevant groups in `groups/`
5. If the principle has grep-able violations, add an `## Inspection` section and update the namespace's `.context-inspect.md` — see [DESIGN.md "Inspection — When to Add"](DESIGN.md#-inspection--when-to-add) for guidance
6. Submit a pull request with:
   - The principle file
   - Group file updates (if any)
   - `.context-inspect.md` updates (if applicable)
   - A brief rationale for the source choice

## Source Requirements

Acceptable:

- Books: full citation with ISBN (e.g., *Effective Java* by Bloch, 3rd ed., ISBN 978-0134685991)
- Papers: DOI or stable URL
- Authoritative specifications: RFC, OWASP, IEEE standard with URL

Not acceptable:

- Blog posts without named authors
- Stack Overflow answers
- Undated sources
