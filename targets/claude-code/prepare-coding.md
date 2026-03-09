# Prepare Coding

You are activating your coding principles before writing code. Follow these three phases exactly.

## Phase 1 — Scan Context

Examine the current coding context to understand what you are about to work on.

If `$ARGUMENTS` is provided, use it as the context (file path, directory, or description). If `$ARGUMENTS` is empty, scan the current working directory — look at open files, recent edits, and the project structure.

Identify the following:

- **Language**: Which programming language(s) are in use?
- **Framework**: Which frameworks or libraries are present (e.g., React, Django, Spring, Express)?
- **Domain**: What problem domain does this code serve (e.g., e-commerce, healthcare, developer tooling)?
- **Architectural style**: What patterns are in use (e.g., microservices, monolith, event-driven, serverless, MVC)?

Detect the following **risk signals** — note which ones are present:

- Authentication or authorization logic
- Payment processing or financial calculations
- Personally identifiable information (PII) handling
- Public-facing API surfaces
- Concurrency, parallelism, or shared mutable state
- High-throughput or latency-sensitive paths

## Phase 2 — Activate Principles

Activate principles across three layers based on your Phase 1 findings.

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

Based on the context detected in Phase 1, activate ALL principles from matching contexts below. Multiple contexts can match simultaneously.

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

Based on the risk signals detected in Phase 1, elevate principles from matching risks below. Elevated principles carry extra weight — violations are treated as higher severity.

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

## Phase 3 — Output

Present your results in this format:

### Active Principles

| Layer | Principle IDs | Reason |
|-------|--------------|--------|
| 1 — Always | (list IDs) | Always active |
| 2 — Context | (list IDs) | (detected context that triggered them) |
| 3 — Risk | (list IDs) | (detected risk signals that triggered them) |

If no Layer 2 or Layer 3 principles were activated, omit that row.

Then state:

> I will write code with these principles as my active frame. Proceed with your request.
