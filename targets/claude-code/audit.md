# Audit

Review code against activated coding principles in six phases.

## Phase 1 — Resolve Input

Determine what to review from `$ARGUMENTS`:

- Empty → respond "What code would you like me to review?" and stop.
- File path → read that file.
- Directory path → recursively glob all source files; exclude binaries, lock files, `node_modules`, `vendor`, `dist`, `build`, `.git`, and build artifacts.
- Inline code → use it directly.

## Phase 2 — Resolve .principles Hierarchy

Walk up from the target path to the git repo root (`.git/`) or max 10 levels, collecting every `.principles` file. Order: root → target.

**If no `.principles` files found: skip to Phase 3.**

### Layer 1 — Always Seeded

| ID | Title |
|----|-------|
| CODE-SD-001 | Single Responsibility Principle |
| CODE-SD-006 | Favor Composition over Inheritance |
| CODE-SD-007 | Program to an Interface, Not an Implementation |
| CODE-SD-029 | Passes all tests |
| CODE-SD-030 | Reveals intention |
| CODE-SD-031 | No duplication |
| CODE-SD-032 | Fewest elements |
| CODE-SEC-VALIDATE-INPUT | Validate input at system boundaries |
| CODE-CS-DRY | DRY: Don't Repeat Yourself |
| CODE-CS-WET | WET: Write Every Time |
| CODE-CS-YAGNI | YAGNI: You Aren't Gonna Need It |
| CODE-CS-KISS | KISS: Keep It Simple |
| CODE-CS-NIH | NIH: Not Invented Here |
| CODE-CS-NO-SILVER-BULLET | No Silver Bullet |
| CODE-CS-CQS | CQS: Command-Query Separation |
| CODE-CS-BOY-SCOUT | The Boy Scout Rule |
| CODE-CS-BROKEN-WINDOWS | Broken Windows |
| CODE-CS-POSTELS-LAW | Postel's Law |
| CODE-CS-HYRUMS-LAW | Hyrum's Law |
| ARCH-CONWAYS-LAW | Conway's Law |
| CODE-DX-NAMING | Name things by what they represent |
| CODE-DX-SMALL-FUNCTIONS | Keep functions small and single-purpose |
| CODE-DX-CODE-FOR-READERS | Write code for the reader, not the writer |
| CODE-DX-DELETE-DEAD-CODE | Delete dead code |
| CODE-CS-FAIL-FAST | Fail fast, fail loudly |

### Process Each .principles File (root → target)

1. Skip blank lines and `#` comments.
2. `@group` → read `{{CODE_PRINCIPLES_REPO}}/groups/<group>.yaml`, expand `principles` into the active set; recursively process `includes` (abort on cycles).
3. Bare `ID` → add to active set (case-insensitive).
4. `!ID` → add to exclusion set.

`final_active = active_set MINUS exclusion_set` · Source: `.principles hierarchy (N files)`

## Phase 3 — Dynamic Detection (fallback)

**Only if Phase 2 found no `.principles` files.**

Detect language, framework, domain, and risk signals (auth, payments, PII, public APIs, concurrency, high-throughput). Seed with Layer 1, then apply:

### Layer 2 — Context-Dependent

Activate ALL matching contexts:

**api-design** — REST/HTTP endpoints, controllers
Signals: `@RestController`, `@GetMapping`, `app.get(`, `router.`, `HttpResponse`, `FastAPI`, `flask`, `express`, `swagger`
Activate: CODE-API-STANDARD-HTTP-METHODS, CODE-API-HATEOAS, CODE-API-RESOURCE-NOUNS, CODE-API-BACKWARD-COMPATIBILITY, CODE-API-HTTP-STATUS-CODES, CODE-SEC-VALIDATE-INPUT, CODE-SEC-004

**concurrency** — Threads, async, locks
Signals: `async`, `await`, `Thread`, `Lock`, `Mutex`, `Semaphore`, `synchronized`, `asyncio`, `goroutine`, `channel`
Activate: CODE-CC-SYNC-SHARED-STATE through CODE-CC-STRUCTURED-CONCURRENCY

**domain-modeling** — DDD entities, value objects, aggregates
Signals: `Entity`, `ValueObject`, `Aggregate`, `Repository`, `DomainEvent`, `BoundedContext`
Activate: CODE-DM-001 through CODE-DM-008

**data-pipeline** — Streaming, ETL, batch, message queues
Signals: `stream`, `pipeline`, `ETL`, `kafka`, `rabbitmq`, `producer`, `consumer`, `airflow`, `dag`
Activate: CODE-AR-ASYNC-MESSAGING, CODE-AR-PIPES-AND-FILTERS, CODE-AR-MESSAGE-BROKER, CODE-RL-IDEMPOTENCY, CODE-RL-BACKPRESSURE, CODE-RL-SCHEMA-EVOLUTION

**testing** — Test files and frameworks
Signals: `test_`, `_test.go`, `.test.ts`, `.spec.ts`, `@Test`, `describe(`, `pytest`, `jest`, `mock`, `fixture`
Activate: CODE-TS-TEST-FIRST through CODE-TS-TEST-NAMING

**object-oriented** — Classes, interfaces, inheritance
Signals: `class`, `extends`, `implements`, `interface`, `abstract`, `override`
Activate: CODE-SD-001 through CODE-SD-007, CODE-CS-DRY, CODE-CS-YAGNI

**cloud-native** — Containers, Kubernetes, twelve-factor
Signals: `Dockerfile`, `kubernetes`, `helm`, `process.env`, `os.environ`, `ConfigMap`, `health_check`
Activate: CODE-AR-001 through CODE-AR-012

**infrastructure** — IaC and provisioning
Signals: `terraform`, `CloudFormation`, `ansible`, `pulumi`, `.tf`, `module`, `variable`
Activate: CODE-AR-INFRASTRUCTURE-AS-CODE through CODE-AR-COMPOSABLE-MODULES

**ui-interaction** — UI components, forms, navigation
Signals: `useState`, `useEffect`, `onClick`, `onChange`, `form`, `template`, `v-model`, JSX, TSX
Activate: CODE-DX-SYSTEM-STATUS-VISIBILITY through CODE-DX-DATA-INK-RATIO

**library-api** — Public libraries, SDKs
Signals: `export`, `__init__.py`, `setup.py`, `package.json`, `Cargo.toml`, `npm publish`
Activate: CODE-API-001 through CODE-API-010, CODE-API-BACKWARD-COMPATIBILITY

**functional** — Immutability, pure functions
Signals: `map(`, `filter(`, `reduce(`, `immutable`, `readonly`, `lambda`, `pipe`, `compose`
Activate: CODE-SD-006, CODE-CC-PREFER-IMMUTABLE, CODE-TP-MAKE-ILLEGAL-STATES-UNREPRESENTABLE through CODE-TP-BRANDED-TYPES

**typed-language** — Static type systems
Signals: TypeScript, Kotlin, Rust, Haskell, C#, Scala, `.ts`, `.kt`, `.rs`, `.cs`
Activate: CODE-TP-MAKE-ILLEGAL-STATES-UNREPRESENTABLE through CODE-TP-BRANDED-TYPES

### Layer 3 — Risk-Elevated

Violations of elevated principles are promoted one severity level (Low→Medium, Medium→High, High→Critical).

**authentication** — Signals: `password`, `login`, `OAuth`, `JWT`, `token`, `session`, `bcrypt`, `hash`
Elevate: CODE-SEC-002, CODE-SEC-STRONG-CRYPTOGRAPHY, CODE-SEC-008

**financial** — Signals: `payment`, `billing`, `invoice`, `currency`, `transaction`, `stripe`, `paypal`
Elevate: CODE-SEC-VALIDATE-INPUT, CODE-SEC-004, CODE-RL-IDEMPOTENCY, CODE-CC-SYNC-SHARED-STATE

**personal-data** — Signals: `PII`, `GDPR`, `email`, `SSN`, `personal_data`, `HIPAA`, `CCPA`
Elevate: CODE-SEC-VALIDATE-INPUT, CODE-SEC-STRONG-CRYPTOGRAPHY, CODE-SEC-SECURITY-BY-DESIGN, CODE-SEC-SECURITY-LOGGING

**public-api** — Signals: `versioned`, `v1`, `v2`, `third-party`, `backward_compatible`, `deprecat`, `semver`
Elevate: CODE-API-BACKWARD-COMPATIBILITY, CODE-API-001, CODE-API-004, CODE-RL-SCHEMA-EVOLUTION

**high-throughput** — Signals: `hot_path`, `realtime`, `low-latency`, `benchmark`, `throughput`, `cache`, `pool`
Elevate: CODE-PF-PROFILE-FIRST through CODE-PF-PREDICTABLE-LATENCY, CODE-CC-AVOID-LOCKS-IN-HOT-PATHS

**distributed-system** — Signals: `microservice`, `gRPC`, `circuit_breaker`, `retry`, `idempotent`, `saga`, `outbox`
Elevate: CODE-RL-FAULT-TOLERANCE through CODE-RL-CONSISTENCY-MODELS, CODE-OB-STRUCTURED-TELEMETRY through CODE-OB-DISTRIBUTED-TRACING, CODE-AR-ASYNC-MESSAGING through CODE-AR-MESSAGE-BROKER

**legacy-codebase** — Signals: `refactor`, `migration`, `legacy`, `tech_debt`, `deprecated`, `strangler`
Elevate: CODE-CS-DRY, CODE-CS-YAGNI, CODE-SD-029 through CODE-SD-032

## Phase 4 — Load Principle Content

For each namespace in the active ID set, read one file:

```
{{CODE_PRINCIPLES_REPO}}/principles/<namespace>/.context-audit.md
```

Filter to entries whose `### ID` is in the final active set. Use the **Principle** and **Violations to detect** content in Phase 5.

## Phase 5 — Review

**Output nothing during this phase.**

**Read every source file** collected in Phase 1. Do not substitute grep, search, or pattern-matching tools for reading — you must read and understand each file's logic, structure, and intent.

For each file, apply every active principle from Phase 2/3. Evaluate design, naming, structure, input handling, duplication, and intent — not just surface patterns like `TODO` or `eval`.

For each violation found, record: principle ID, severity (Critical/High/Medium/Low, elevated → promote one level), absolute file path with forward slashes, line number, one sentence describing what is wrong, and a concrete fix grounded in the principle.

## Phase 6 — Output

**Step 1.** Write `audit-output.json` to the **repository root** (where `.git/` is) with this structure:

```json
{
  "findings": [
    {
      "severity":     "HIGH",
      "principle_id": "CODE-SD-001",
      "title":        "one-line description",
      "file":         "C:/absolute/path/to/file.py",
      "line":         42,
      "description":  "what is wrong",
      "fix":          "concrete fix"
    }
  ],
  "summary": {
    "critical": 0,
    "high": 1,
    "medium": 0,
    "low": 0,
    "active_principles": ["CODE-SD-001", "CODE-CS-DRY"],
    "principle_source": ".principles hierarchy (2 files)"
  }
}
```

- `severity`: `CRITICAL`, `HIGH`, `MEDIUM`, or `LOW`
- `file`: absolute path, forward slashes; `""` if unavailable
- `line`: integer; `0` if unavailable
- `findings`: `[]` if no issues found

**Step 2.** Output a compact text report grouped by severity. Use this exact template:

```
Audit complete — {N} findings.

Critical:

- `{absolute/file.py}:{line}` [{PRINCIPLE-ID}] — {description}. → {fix}.

High:

- `{absolute/file.py}:{line}` [{PRINCIPLE-ID}] — {description}. → {fix}.

Medium:

- `{absolute/file.py}:{line}` [{PRINCIPLE-ID}] — {description}. → {fix}.

Low:

- `{absolute/file.py}:{line}` [{PRINCIPLE-ID}] — {description}. → {fix}.

Summary: {critical} critical, {high} high, {medium} medium, {low} low
Principle source: {source}

Generated: {absolute path}/audit-output.json
```

- Group findings by severity (Critical / High / Medium / Low). Omit empty severity groups.
- Use absolute file paths with forward slashes, wrapped in backticks to prevent markdown mangling (e.g. `__init__.py`).
- Principle ID in brackets: `[CODE-SD-001]`.
- One line per finding.
- If no findings: output `Audit complete — 0 findings.` followed by the Summary and Generated lines.
