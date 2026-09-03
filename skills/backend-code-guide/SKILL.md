---
name: backend-code-guide
description: Implement and review backend APIs, services, and Prisma Client access in projects that explicitly install this skill. Use when changing backend read/write contracts, use-case boundaries, transaction ownership, or database queries; not for Prisma Schema and migration design alone.
---

# Backend Code Guide

Use this skill only in projects that explicitly install it. Follow the project's `AGENTS.md` for
general TypeScript, testing, and migration rules; this skill contains backend API, service, and
Prisma Client access decisions.

## API contracts

Design an endpoint from its consumer's use case, not from the relations available in Prisma.

- Read endpoints return `{ success: true, data: ... }` and expose only the requested resource or
  read model.
- Successful write endpoints return `{ success: true }`. Do not return `204`, an entity, an ID, or
  a detail read model unless the current requirement explicitly defines a different contract.
- Failed requests keep the standard `{ success: false, code, message }` shape.
- Keep general resource endpoints narrow. Do not embed payment, refund, order, or other aggregate
  details merely because they are related in the database. The client should call the relevant read
  endpoint when it needs that information.
- Add a composite response only when the concrete screen or workflow requires one atomic read; make
  it an operation-specific read model rather than expanding a shared default response.

A command may create or update several models in one transaction. That does not require exposing
those internal models as separate frontend operations. For example, order payment and order refund
flows should call their use-case commands; the backend owns the associated payment writes and their
transaction boundary.

### Route names for new APIs

- Give every path segment one explicit role: domain scope, resource collection, resource identity,
  subresource collection, or operation variant. Do not infer a route hierarchy from Prisma
  relations.
- Use a plural noun for a REST resource collection and append its identity for one resource, for
  example `/customers` and `/customers/:id`.
- Put a resource collection under a concrete parent identity only when it is genuinely owned or
  scoped by that parent, for example `/orders/:id/payments`.
- Use a singular noun for a domain scope that groups use cases or resources, for example
  `/member-card/orders`. A plural resource collection must not be reinterpreted as a domain scope:
  `/member-cards/orders` is invalid when `member-card` is the intended scope.
- A POST route may append an operation variant after a subresource collection already scoped by a
  concrete parent identity. For example, `/orders/:id/payments/payment-code` creates a payment for
  the order by payment code. The variant is not a nested resource and must not be used to hide
  unrelated resource ownership.
- Do not occupy a resource list path with an option-specific response contract. Keep the controller
  under the matching domain directory.
- Apply this convention to new APIs; do not rename existing routes without an explicit migration
  requirement.

Before accepting a route, label its segments. These are valid shapes:

```text
/resources
/resources/:id
/resources/:id/subresources
/scope/resources
/resources/:id/subresources/operation-variant
```

If a plural segment is being described as a scope, or a child resource has neither a domain scope
nor a concrete parent identity, rename the route before implementation.

## Service boundaries

- Put orchestration in the service that owns the use case. Controllers validate transport input,
  invoke the use case, and translate its result to the API contract.
- Treat persistence relations as implementation details. A relation does not by itself authorize a
  broader API response or a cross-domain write.
- Keep read mapping separate from writes. After a successful command, callers obtain current state
  through the appropriate read endpoint.

## Prisma Client access

Apply these rules after the API contract, Prisma Schema, domain ownership, and service boundaries
have been decided. Do not use query structure to invent those decisions.

### Query entry point

- Enter through the model that owns the operation and naturally carries tenant, permission, and
  state constraints.
- When `Payment` owns `PaymentItem`, code outside the payment service normally queries `Payment` and
  selects the required items. Do not start from `PaymentItem` and reconstruct its payment, store,
  source document, and state constraints.
- Direct child-model access is valid inside its owning service when it is the clearest implementation
  and the service already enforces the aggregate invariants. Do not mechanically ban it.
- For cross-domain reads, use the other domain's established root and public service contract when
  one exists instead of reaching into its internal tables.

### Query shape

- Prefer `select` for the smallest shape consumed by the operation.
- Add nested relations only when the current operation reads them. Do not mirror the complete Prisma
  relation graph in a query or public response.
- If one operation genuinely needs a deep query, give it an operation-specific query shape; do not
  expand a shared default selector.
- Keep Prisma result types private to persistence and service code. A query result is not an API
  response contract.
- Include all store or tenant ownership and required business-state constraints in the root access
  path. Do not recover them later from incidental nested data.

## Review questions

Before accepting backend code, verify:

1. Is the endpoint shaped around the actual frontend workflow?
2. Does a write return only `{ success: true }`, with subsequent state read separately?
3. Are unrelated aggregates absent from default detail responses?
4. Does the service own the complete use case and transaction boundary?
5. Does each Prisma query start from the correct owning model?
6. Are selected fields and relations actually consumed?
7. Is a child table being used to reconstruct parent ownership or business state?

When a Prisma access problem is found, change only the access implementation unless the user also
authorizes API, Schema, or domain redesign.
