# Architecture and Technical Decisions

This file is the canonical decision log. Keep decisions short, dated when known, and explicit about status. Do not treat a proposal or an experiment as an accepted decision.

## D-001 — Unity as the primary application platform

- **Status:** Accepted
- **Decision:** Continue the existing Unity/C# project. Use Android Studio and Android Emulator as supporting tools for Android builds and diagnostics.
- **Rationale:** A Unity prototype already exists and has been built and launched in the emulator. Rewriting the app in another platform would discard working project state without a demonstrated need.
- **Revisit only if:** a concrete technical requirement cannot reasonably be met in Unity and the user approves an architecture review.

## D-002 — Ollama model for current prototype tests

- **Status:** Accepted for development testing
- **Decision:** Use the installed `llama3.1:8b` model while diagnosing integration. Defer larger models until the current path is verified.
- **Rationale:** A Windows-local API generation request returned `OLLAMA_OK`.
- **Boundary:** This does not make Ollama a required dependency of the eventual Android app.

## D-003 — Android Emulator host endpoint

- **Status:** Configured in source; end-to-end connectivity unverified
- **Decision:** The current Unity Android prototype targets `http://10.0.2.2:11434/api/generate`.
- **Rationale:** `10.0.2.2` is the host alias in the standard Android Emulator.
- **Caveat:** Correct endpoint selection does not prove reachability. Listener binding, firewall, Android permission and Unity cleartext-HTTP policy may affect the request.

## D-004 — Do not expose Ollama publicly

- **Status:** Accepted
- **Decision:** Do not expose the development Ollama API to the public internet as a connectivity workaround.
- **Rationale:** The local development API should be limited to the intended environment.

## D-005 — Preserve the known-good prototype while diagnosing

- **Status:** Accepted
- **Decision:** Do not rebuild, change graphics settings or refactor unrelated code unless diagnostics identify a concrete reason.
- **Rationale:** The APK launched and displayed its UI; isolate the unresolved request path one variable at a time.

## D-006 — Evidence before declaring success

- **Status:** Accepted
- **Decision:** Distinguish implementation, successful build, successful test and verified target-platform behavior. A model response or code listing alone is not proof that an action occurred.
- **Rationale:** Project progress must be reproducible across chats and development environments.

## Deferred / not yet decided

- On-device inference versus remote/local development inference for future releases.
- Final persistent-memory implementation and storage technology.
- Final agent orchestration and tool-execution design.
- Production transport/security model.
- Any migration away from Unity.

Do not silently promote a deferred item to an accepted decision. Propose options and request approval when a decision becomes necessary.
