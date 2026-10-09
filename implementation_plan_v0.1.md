# Independent Android AI Agent — Implementation Plan v0.1

**Status:** Proposed execution baseline; review before merge  
**Date:** 2026-10-09  
**Scope:** Turn the existing architecture documents into a bounded implementation sequence. This is a working plan, not a promise to implement every capability listed in the long-term vision.

## 1. Operating rules

1. Build vertical slices that run end-to-end. Do not build every logical component in isolation.
2. Keep logical boundaries in code, but do not create a Gradle module for every architecture box. Start with the smallest buildable Android project and split modules only when there is a concrete benefit.
3. Agent Core owns task lifecycle and coordination. The model may propose a Goal Model or plan; deterministic local code validates policy, authorizes actions, controls execution, handles STOP, and verifies outcomes.
4. A successful tool/API call is not proof of goal completion. Success requires evidence against explicit postconditions.
5. Unknown outcomes must not trigger blind retries, especially for non-idempotent actions.
6. STOP prevents new actions immediately and requests cancellation of active work where supported. It does not promise rollback of actions already completed.
7. Local safety rules cannot be weakened by cloud responses, server marks, model output, or offline state.
8. No paid service is a baseline dependency. Any proposed recurring cost must be justified and approved before adoption.
9. Every spike has a question, a time/effort boundary, acceptance criteria, and a stop condition. A failed spike produces a decision, not an indefinite optimization project.

## 2. Decisions to use as the working baseline

### D1 — Logical architecture, not premature module proliferation

Retain the logical responsibilities described in `777.txt`. For the first build, keep the Android shell and core in a small number of build units; use packages/interfaces to preserve boundaries. Split modules only when build isolation, reuse, ownership, or dependency enforcement makes the split worthwhile.

### D2 — Unity is a bounded candidate, not an approved foundation yet

The avatar notes recommend Unity and the current Android renderer documents assume native Android + Filament/SceneView. These are incompatible implementation assumptions. Do not implement both.

Run one bounded Unity Android proof-of-concept before selecting the UI foundation. It must test:
- the compact avatar state;
- the voice/listening/thinking/speaking state;
- a full work surface with a visible STOP control;
- event-driven state changes from a host-independent interface;
- Android build/run, lifecycle behavior, back navigation, and touch input;
- packaged size and observed performance on at least one available Android device or emulator.

**Boundary:** no production Agent Core, no paid asset/API, no second engine spike, and no attempt to perfect animation or lip-sync. If the Unity embedding/lifecycle or UI interaction fails a critical criterion, stop and document the evidence. If Unity is selected, keep agent logic and Android capability integrations independent of Unity. If not selected, revisit the existing native renderer documents before implementation.

### D3 — First end-to-end capability

Use an **app-owned local reminder** as the initial vertical slice, unless the existing capability contract reveals a blocker during implementation. This avoids making the first milestone depend on an external provider or cloud service.

Minimum path:
1. accept a text request;
2. construct a structured Goal Model with title, due time/time-zone interpretation, constraints, and success criteria;
3. ask for clarification if required fields are ambiguous;
4. create a proposed plan;
5. apply local safety/permission checks;
6. execute the reminder creation through a local capability;
7. persist the reminder and schedule its notification;
8. verify the persisted reminder and scheduled state as far as Android allows;
9. show a truthful result and any timing limitations;
10. allow STOP before execution and during cancellable work.

The initial version must not claim exact alarm delivery unless the implementation and Android permission state support that guarantee. Calendar, messaging, arbitrary-app control, and broad UI automation are later capabilities.

### D4 — Task lifecycle controller is original core logic

Implement a small deterministic controller around the existing task and execution contracts. It coordinates state transitions, authorization, active execution, cancellation, verification, and terminal results. Keep the state machine explicit and testable. Do not duplicate a workflow framework unless a concrete need emerges.

Minimum invariants:
- every task has a stable ID and explicit state;
- only an authorized plan can enter execution;
- STOP blocks subsequent actions;
- cancellation and rollback are different outcomes;
- unknown execution outcome is represented as unknown/recovery-required, not success or safe-to-retry;
- completion requires verification evidence;
- terminal states cannot silently return to execution.

## 3. Delivery sequence

### Stage 0 — Baseline and conflict cleanup
- Treat this plan as the single implementation sequence after approval.
- Preserve the architecture decisions archive as historical rationale, but mark superseded choices clearly rather than silently leaving contradictory “approved” statements.
- Resolve the risk classification conflict for `message.send` before implementing messaging; do not implement messaging in the first slice.
- Fix the Android emulator host alias in the Network Bridge document (the emulator host alias is `10.0.2.2`, not `10.0.2`) and remove any implication that cleartext HTTP should be enabled globally in production.
- Ensure remote policy/knowledge data cannot override local safety policy.
- Defer deleting/merging overlapping contracts until a reference map is made; do not delete source documents blindly.

### Stage 1 — Unity UI spike
Deliver a reproducible Android proof-of-concept and a short result record against D2. Make the engine decision from evidence. No parallel Godot/Filament experiment.

### Stage 2 — Buildable Android skeleton
Create the smallest runnable Android application with:
- text input and task/result surface;
- explicit UI state model;
- STOP wired to task cancellation, not merely visual dismissal;
- a replaceable model adapter interface;
- local persistence;
- automated unit tests for task-state transitions.

The selected UI foundation determines only the presentation layer; Agent Core contracts remain independent of it.

### Stage 3 — Reminder vertical slice
Implement D3 end-to-end, including positive and negative tests, permission-denied behavior, ambiguous-time clarification, cancellation, duplicate prevention, and truthful verification.

### Stage 4 — Stabilize before expanding
Do not add a second capability until the first slice passes acceptance tests on a clean build and the execution/verification/STOP invariants are tested. Then add capabilities one at a time through the same contracts.

## 4. First implementation acceptance gate

The first vertical slice is accepted only when:
- the project builds from documented instructions;
- a clear reminder request reaches a persisted reminder through the complete task lifecycle;
- ambiguous date/time input asks a targeted clarification instead of guessing;
- a denied/missing permission or scheduling limitation is surfaced honestly;
- the result is verified from local state rather than inferred from the model's claim;
- STOP prevents not-yet-started actions and cancellation outcomes are represented accurately;
- duplicate submissions do not silently create duplicate reminders;
- tests cover state transitions, authorization failure, execution failure, unknown outcome, verification failure, and STOP;
- no cloud account or paid API is required for this slice.

## 5. Document hygiene

The repository currently contains several overlapping contracts and at least two conflicting avatar implementation assumptions. Do not treat every document as equally current.

Proposed source-of-truth order:
1. user-approved product constraints and `Системный промт.txt`;
2. this implementation plan for sequencing and bounded decisions;
3. focused contracts for the specific behavior being implemented;
4. architecture archive and preliminary project brief as rationale/background.

Before removing documents, create a concise index mapping each contract to its unique responsibility, duplicate, conflict, and proposed action (keep / merge / supersede / delete). Do not delete documents until the proposed mapping is reviewed.

## 6. Risks and open decisions

- Unity may simplify avatar animation but make ordinary Android UI, accessibility, lifecycle, and app size more expensive. The spike must measure the real trade-off rather than assume Unity can or cannot own the whole UI.
- Local reminder delivery depends on Android scheduling behavior and OS restrictions; the app must state the actual guarantee and test on target Android versions.
- The repository currently contains architecture documents but no Android build scaffold in the reviewed tree. Implementation must start from a reproducible, clean build rather than assume hidden source code exists.
- Messaging risk classification is inconsistent across safety documents and must be reconciled before messaging is implemented.
- A server's priority/severity field is advisory input only; it is not authority to override local hard safety constraints.

## 7. Immediate next actions

1. Review and approve/revise this plan.
2. Produce the bounded Unity spike task from D2.
3. Build the smallest runnable shell on the chosen foundation.
4. Implement the task lifecycle controller and first reminder capability as a vertical slice.
5. Consolidate documents only after the source-of-truth map is explicit.
