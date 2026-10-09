# Decisions

## D-001 — Baseline model for the current prototype
- **Status:** Accepted
- **Decision:** Continue testing with the locally installed Ollama model `llama3.1:8b`; postpone troubleshooting larger models.
- **Rationale:** This model has already returned a successful response through the local API.

## D-002 — Android Emulator endpoint
- **Status:** In use; connectivity not yet verified
- **Decision:** The Unity Android build targets Ollama on the development PC through `http://10.0.2.2:11434/api/generate`.
- **Rationale:** In the standard Android Emulator, `10.0.2.2` is the special alias for the host machine.
- **Caveat:** Correct endpoint selection alone does not establish network reachability. Ollama listener binding, Windows Firewall, app network permission, and cleartext HTTP policy may still affect connectivity.

## D-003 — Keep Ollama network exposure restricted
- **Status:** Accepted
- **Decision:** Do not expose Ollama to the public internet as a connectivity workaround.
- **Rationale:** The development API should be reachable only from the intended development environment/network.

## D-004 — Preserve the known-good APK while diagnosing
- **Status:** Accepted
- **Decision:** Do not rebuild or change Unity settings until evidence indicates a source/build mismatch or a code/manifest issue.
- **Rationale:** The APK launches and displays its UI; isolate the remaining Android-to-Ollama connectivity problem before changing other variables.
