# AGENTS.md — Independent Android AI Agent

## Before every task

1. Read this file and the relevant sections of `docs/ARCHITECTURE.md`, `docs/DECISIONS.md`, and `docs/PROGRESS.md`.
2. Inspect the actual repository, relevant source/configuration files, and `git status`. Treat documentation as a handoff, not proof that the current working tree is unchanged.
3. Identify the exact goal, acceptance criteria, affected files, and verification command before editing.

## Stack and architecture constraints

- Unity and C# are the primary application platform and language. Android Studio/Android Emulator are supporting build and diagnostic tools; do not migrate the app to native Android without explicit approval.
- Ollama on the development PC is the current prototype backend, not an assumed end-user phone dependency.
- Preserve working behavior. Prefer the smallest change that solves the demonstrated problem.
- Do not make a major architecture, platform, data-format, or dependency change without presenting the evidence, alternatives, impact, and recommendation for approval.
- Do not expose the development Ollama endpoint to the public internet.
- Model output is untrusted data. Never execute arbitrary generated commands/code or invoke device capabilities without validation, allowlists, and appropriate user confirmation.

## Current technology only

- Inspect actual project/toolchain versions before proposing APIs or dependencies.
- Prefer official documentation, version-specific release notes, migration guides, and official examples.
- Verify API availability, support status, and compatibility with the project's installed versions. Do not rely on old tutorials or unverified generated examples.
- Do not add a dependency or upgrade versions unless it solves a defined need. Avoid bulk upgrades.
- If current documentation cannot be verified, state that uncertainty explicitly.

## Controlled implementation and debugging

1. Gather the exact error, logs, configuration, and relevant code.
2. State a testable hypothesis; change one relevant variable at a time.
3. Implement one primary approach, inspect the diff, and run applicable checks.
4. After two failed attempts using the same approach, stop repeating it; reassess the hypothesis and request missing evidence if necessary.
5. Never claim a build, test, network path, or device behavior succeeded unless the check was actually performed. Distinguish implemented, built, tested, and verified on target.
6. Do not delete user data, reset Git, remove files, publish, or perform destructive operations without explicit approval.

## Required handoff

At the end of every meaningful task:
- Update `docs/PROGRESS.md` with verified results, exact checks, remaining unknowns, and one next task.
- Update `docs/DECISIONS.md` only when a decision is actually accepted or its status changes.
- Update `docs/ARCHITECTURE.md` only when architecture changes.
- Preserve dated diagnostic history in `DEVELOPMENT_LOG.md` where useful.
- Report changed files, checks run and outcomes, unverified items, and the next step.

Do not create duplicate status/decision documents. Do not repeat completed work without evidence that the environment or implementation has changed.

## Source of truth

The current repository and actual test results determine implementation state. Architecture decisions are recorded in `docs/DECISIONS.md`; the current handoff is `docs/PROGRESS.md`; the architecture overview is `docs/ARCHITECTURE.md`. The versioned Android integration details remain in `docs/architecture/android_integration_architecture_v0.1.md`.
