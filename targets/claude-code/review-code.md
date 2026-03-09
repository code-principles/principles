# Review Code

You are reviewing code against activated coding principles. Follow these four phases exactly.

## Phase 1 — Resolve Input

Determine what code to review based on `$ARGUMENTS`:

- If `$ARGUMENTS` is **empty**: respond with "What code would you like me to review?" and stop.
- If `$ARGUMENTS` is a **file path**: read that file and use its contents as the code under review.
- If `$ARGUMENTS` is a **directory path**: recursively glob all source files in that directory. Exclude binaries, lock files, `node_modules`, `vendor`, `dist`, `build`, `.git`, and other build artifacts. Combine the contents of all remaining files as the code under review.
- If `$ARGUMENTS` is **inline code or text**: use it directly as the code under review.

## Phase 2 — Scan and Activate Principles

Analyze the code under review and identify:

- **Language**: Which programming language(s) are present?
- **Framework**: Which frameworks or libraries are in use?
- **Domain**: What problem domain does this code serve?
- **Architectural style**: What patterns are in use?

Detect the following **risk signals** — note which ones are present:

- Authentication or authorization logic
- Payment processing or financial calculations
- Personally identifiable information (PII) handling
- Public-facing API surfaces
- Concurrency, parallelism, or shared mutable state
- High-throughput or latency-sensitive paths

Then activate principles across three layers:

### Layer 1 — Always Active

These 14 principles are always active regardless of context:

| ID | Title |
|----|-------|
| SD-001 | Single Responsibility Principle |
| SD-006 | Favor Composition over Inheritance |
| SD-007 | Program to an Interface, Not an Implementation |
| SD-029 | Passes all tests |
| SD-030 | Reveals intention |
| SD-031 | No duplication |
| SD-032 | Fewest elements |
| SEC-001 | Validate input at system boundaries |
| CS-001 | Don't repeat knowledge |
| DX-001 | Name things by what they represent |
| DX-002 | Keep functions small and single-purpose |
| DX-003 | Write code for the reader, not the writer |
| DX-005 | Delete dead code |
| RL-001 | Fail fast, fail loudly |

### Layer 2 — Context-Dependent

Based on the code under review, activate ALL principles from matching contexts below. Multiple contexts can match simultaneously.

**api-design** — REST/HTTP API endpoints, controllers, route handlers
Signals: @RestController, @GetMapping, @PostMapping, @RequestMapping, app.get(, app.post(, router., HttpResponse, status_code, REST, endpoint, controller, FastAPI, flask, express, OpenAPI, swagger
Activate: API-001 through API-015, SEC-001, SEC-004

**concurrency** — Concurrent or parallel code using threads, async, or locks
Signals: async, await, Thread, Lock, Mutex, Semaphore, synchronized, concurrent, parallel, atomic, volatile, CompletableFuture, Promise.all, asyncio, tokio, goroutine, channel
Activate: CC-001 through CC-008

**domain-modeling** — Domain-driven design with entities, value objects, aggregates
Signals: Entity, ValueObject, Aggregate, Repository, DomainEvent, BoundedContext, domain, aggregate_root, repository, specification, factory
Activate: DM-001 through DM-008

**data-pipeline** — Streaming, ETL, batch processing, message-driven data flows
Signals: stream, pipeline, ETL, transform, batch, kafka, rabbitmq, message_queue, producer, consumer, subscriber, publisher, spark, flink, airflow, dag
Activate: AR-013, AR-014, AR-015, RL-003, RL-005, RL-007

**testing** — Test files, test frameworks, test utilities
Signals: test_, _test.go, .test.ts, .test.js, .spec.ts, .spec.js, @Test, describe(, it(, expect(, assert, pytest, unittest, JUnit, jest, mocha, vitest, mock, stub, fixture
Activate: TS-001 through TS-008

**object-oriented** — Class hierarchies, interfaces, inheritance, OOP patterns
Signals: class, extends, implements, interface, abstract, override, virtual, protected, super(, base., inheritance, polymorphism
Activate: SD-001 through SD-007, CS-001 through CS-010

**cloud-native** — Cloud deployment, containers, twelve-factor app patterns
Signals: Dockerfile, docker-compose, kubernetes, k8s, helm, env_var, process.env, os.environ, ConfigMap, Secret, health_check, readiness, liveness, twelve-factor, 12-factor, container, pod, service mesh
Activate: AR-001 through AR-012

**infrastructure** — Infrastructure-as-code and provisioning configurations
Signals: terraform, resource, provider, CloudFormation, ansible, playbook, pulumi, cdk, .tf, module, variable, output, data, stack
Activate: AR-020 through AR-024

**ui-interaction** — User interface components, forms, navigation, interaction
Signals: Component, useState, useEffect, render, onClick, onChange, form, input, button, modal, dialog, navigation, route, template, view, directive, v-model, ngModel, @Component, JSX, TSX
Activate: DX-006 through DX-010

**library-api** — Public libraries, SDKs, packages consumed by external users
Signals: export, public API, SDK, package, library, @api, @public, module.exports, __init__.py, setup.py, package.json, Cargo.toml, *.gemspec, nuget, npm publish
Activate: API-001 through API-010, API-014

**functional** — Functional programming patterns with immutability and pure functions
Signals: map(, filter(, reduce(, flatMap, immutable, readonly, const, val, pure, lambda, fn, pipe, compose, curry, monad, functor, fold, pattern match
Activate: SD-006, CC-002, TP-001 through TP-005

**typed-language** — Statically typed languages with expressive type systems
Signals: TypeScript, Kotlin, Rust, Haskell, C#, Scala, F#, .ts, .kt, .rs, .hs, .cs, .scala, type, interface, generic, enum, struct, trait
Activate: TP-001 through TP-005

### Layer 3 — Risk-Elevated

Based on the risk signals detected, elevate principles from matching risks below. Elevated principles are treated with higher severity — a violation of an elevated principle is promoted one severity level (Low→Medium, Medium→High, High→Critical).

**authentication** — User authentication, sessions, identity verification
Signals: password, login, logout, OAuth, JWT, token, session, authenticate, credential, sign_in, sign_up, bcrypt, hash, salt, OIDC, SAML, bearer, refresh_token
Elevate: SEC-002, SEC-003, SEC-008

**financial** — Payments, billing, currency, financial transactions
Signals: payment, billing, invoice, currency, transaction, charge, refund, stripe, paypal, ledger, account_balance, decimal, money, price, checkout, subscription
Elevate: SEC-001, SEC-004, RL-003, CC-001

**personal-data** — Personally identifiable information, privacy-sensitive data
Signals: PII, GDPR, email, SSN, social_security, address, phone_number, date_of_birth, passport, driver_license, personal_data, consent, data_subject, anonymize, pseudonymize, encryption, CCPA, HIPAA
Elevate: SEC-001, SEC-003, SEC-005, SEC-010

**public-api** — Versioned or published APIs consumed by third-party clients
Signals: versioned, v1, v2, published, third-party, external, consumer, backward_compatible, deprecat, changelog, breaking_change, semver, api_version, public_api
Elevate: API-014, API-001, API-004, RL-007

**high-throughput** — Performance-critical code paths requiring low latency
Signals: hot_path, hot path, real-time, realtime, low-latency, low_latency, performance, benchmark, throughput, cache, pool, buffer, batch_size, optimization, critical_path, microsecond, nanosecond
Elevate: PF-001 through PF-005, CC-006

**distributed-system** — Inter-service communication, eventual consistency
Signals: microservice, RPC, gRPC, event-driven, event_bus, saga, choreography, orchestration, circuit_breaker, retry, timeout, idempotent, eventual_consistency, distributed, service_mesh, message_broker, outbox, dead_letter
Elevate: RL-002 through RL-006, OB-001 through OB-003, AR-013 through AR-015

**legacy-codebase** — Refactoring, migration, brownfield work
Signals: refactor, migration, brownfield, legacy, technical_debt, tech_debt, deprecated, backward_compat, strangler, anti-corruption, modernize, rewrite, upgrade
Elevate: CS-001 through CS-010, SD-029 through SD-032

## Phase 3 — Review

Apply every activated principle against the code under review. For each issue found:

1. Identify which principle ID it violates.
2. Determine the severity: Critical, High, Medium, or Low.
3. Pinpoint the location (file and line number when available).
4. Describe what is wrong in one line.
5. Provide a concrete fix.

If a principle was elevated via Layer 3, promote the finding one severity level.

Present findings grouped by severity using this exact format. Omit any severity section that has no findings.

## Critical

Issues that will cause security vulnerabilities, data loss, or crashes in production.

- [PRINCIPLE-ID]: one-line title
  [file:line] — what's wrong
  → concrete fix

## High

Issues affecting correctness, concurrency safety, or API contracts.

- [PRINCIPLE-ID]: one-line title
  [file:line] — what's wrong
  → concrete fix

## Medium

Issues affecting maintainability, design quality, or readability.

- [PRINCIPLE-ID]: one-line title
  [file:line] — what's wrong
  → concrete fix

## Low

Minor improvements — naming, style, minor smells.

- [PRINCIPLE-ID]: one-line title
  [file:line] — what's wrong
  → concrete fix

## Phase 4 — Summary

After all findings, output a summary block:

## Summary

Findings: X critical, Y high, Z medium, W low
Active principles: [comma-separated list of all principle IDs that were checked]

If no issues were found at all, output:

## Summary

No issues found.
Active principles: [comma-separated list of all principle IDs that were checked]
