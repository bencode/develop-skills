---
name: frontend-api-docs
description: Write concise, repository-aware API integration documents for frontend development agents. Use when documenting a backend call chain, state-dependent next steps, idempotency behavior, or the code locations that define an API contract; not for UI specifications, backend architecture, or end-user documentation.
---

# Frontend API Docs

Write the smallest document that lets a frontend agent call the API correctly. Assume the agent can
inspect the repository: describe the integration path and point to authoritative code instead of
copying complete schemas or explaining backend internals.

## Establish the contract

Treat code as the source of truth and existing documentation as context. Inspect the affected path
in this order:

```text
route registration
-> request schema and controller
-> service result and error mapping
-> integration tests
-> existing issues or documentation
```

Record the backend branch used for the inspection. Resolve contradictions from code and tests before
writing; do not preserve stale documentation for compatibility.

## Write what changes the next call

Lead with the goal and exact HTTP call sequence. For each step, include only:

- method and path;
- required authentication, scope, or capability when it can block the call;
- the smallest callable request example;
- response fields and status codes that determine the next step;
- retry, cancellation, recovery, or completion behavior the caller must implement;
- externally observable constraints, such as amount equality or assignable resource state.

Use code, HTTP examples, state transitions, or tables where they are more precise than prose. Do not
repeat a request or response schema field by field when a semantic source locator lets the agent read
it directly.

## Show lifecycle-sensitive values at the call site

When a value such as `requestId`, `Idempotency-Key`, `version`, or a continuation token affects
correctness, show where it lives across real calls. State its lifecycle and whether retries must keep
the same payload.

```text
begin(operation)  -> generate once and store with the operation input
retry(operation)  -> reuse the same identifier and the same input
finish(operation) -> clear the stored operation state
new operation     -> generate a new identifier
```

For example, demonstrate retrying a stored command rather than generating an identifier inside each
submission attempt:

```ts
type PendingCommand<T> = {
  idempotencyKey: string
  input: T
}

const submit = <T>(command: PendingCommand<T>) =>
  api.post(path, command.input, {
    headers: { 'Idempotency-Key': command.idempotencyKey },
  })
```

Match the real API placement: if the identifier is a body field, keep it in the stored body; if it
is a header, keep it with the stored command. Distinguish identifiers belonging to consecutive
business operations. Never suggest generating a fresh random identifier in a click or retry handler.

## Use semantic source locators

Locate code by meaning, not by an immutable snapshot:

```ts
type SourceLocator = {
  branch: string
  path: string
  symbols: string[]
  tests?: string[]
}
```

Use repository-relative paths plus controller, schema, service, function, or test names. A link may
target the named branch and file, but must not pin a commit, line number, or line-range permalink.
This gives the agent enough semantic information to find renamed or moved code without making the
document expire on ordinary edits.

## Keep the boundary narrow

Exclude UI interactions, component design, UML, database models, transaction mechanics, architecture
tutorials, and exhaustive error catalogs unless one of them changes how the frontend must call the
API. Do not turn the document into a technical article. Link broader background material instead of
repeating it.

Before publishing, verify that the document contains a complete call path, explicit state branches,
correct identifier lifecycles, minimal integration checks, and semantic source locators. Remove any
paragraph that does not help the frontend agent choose or execute its next API call.
