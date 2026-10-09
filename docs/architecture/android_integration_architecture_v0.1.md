# Android Integration Architecture v0.1

- **Status:** Prototype implemented; Android-to-host connectivity under investigation
- **Version:** 0.1
- **Updated:** 2026-10-10
- **Scope:** First practical path from the Unity prototype to an Ollama model hosted on the development PC.

## 1. Purpose

Prove a narrow text request/response path from the Unity Android app to a model hosted by Ollama on the development PC. Autonomous planning, device control, and broad permissions are out of scope for this milestone.

## 2. Current implementation and observed state

- Unity project: `C:\Users\max\Documents\Projects\IndependentAgentUnitySpike\IndependentAgentUnitySpike`
- UI/model-client prototype script: `Assets/Scripts/AgentPrototypeUI.cs`
- Model: `llama3.1:8b`
- Android API endpoint configured in the script:
  ```csharp
  private const string OllamaUrl = "http://10.0.2.2:11434/api/generate";
  ```
- The Android APK was built and launched in Android Emulator; the UI is visible. Vulkan was removed from the graphics API list and OpenGLES3 retained after Vulkan caused a black screen.
- The user reports configuring Ollama to listen on all/network interfaces.
- Windows-local Ollama API is verified: `localhost:11434/api/tags` and `127.0.0.1:11434/api/tags` return model data, and a non-streaming generation request to `llama3.1:8b` returned `OLLAMA_OK`.
- **Not yet working:** the Android app does not receive a response from Ollama. The emulator-to-host network path remains unverified.

## 3. Request path

```text
Unity UI in Android Emulator
  |
  | HTTP POST /api/generate
  | http://10.0.2.2:11434/api/generate
  v
Android Emulator host alias (10.0.2.2)
  |
  v
Windows host networking / firewall
  |
  v
Ollama API on port 11434
  |
  v
llama3.1:8b
```

For the standard Android Emulator, `10.0.2.2` is the host machine alias. On Windows itself, `localhost` and `127.0.0.1` address the Windows host loopback interface. A successful Windows-local request does not prove that an emulator request can reach the API.

## 4. Diagnostic sequence for the current blocker

1. Find the Android SDK location in Android Studio. If `adb` is not on PowerShell's PATH, invoke `<SDK>\platform-tools\adb.exe` by its full path.
2. Capture the exact app error and Android logs (logcat).
3. Verify the actual Ollama listener address and port 11434.
4. Verify Windows Firewall allows the intended emulator/host traffic.
5. Test the path from the emulator to `10.0.2.2:11434`.
6. Inspect Android Internet permission and cleartext HTTP policy if evidence points to an app manifest/network policy issue.
7. Change one variable at a time and record each outcome in `DEVELOPMENT_LOG.md` and `PROJECT_STATUS.md`.

Do not rebuild the APK or change Unity graphics settings again unless diagnostics show a concrete reason.

## 5. Responsibilities

- **Unity UI:** collect a prompt, show progress and result, allow user-requested cancellation.
- **Model client:** own endpoint configuration, request serialization, HTTP transport, timeouts, response parsing, and error reporting.
- **Ollama:** host the selected model and return generated text.
- **Future agent coordinator:** interpret model output and request narrowly defined tools only through explicit, validated interfaces.
- **Future Android capability layer:** expose only approved capabilities, with permissions and user confirmation where appropriate.

## 6. Safety and trust boundaries

- Model output is untrusted text, not executable authority.
- Do not execute shell commands, arbitrary code, or Android actions directly from generated text.
- Future tools must use a small allowlist, typed parameters, validation, and clear success/failure results.
- Ask for user confirmation before consequential or destructive actions.
- Keep credentials and private data out of logs.
- Do not expose the Ollama endpoint to the public internet as a shortcut for connectivity.
- Distinguish “model generated a suggestion” from “the system performed an action.”

## 7. Acceptance criteria for the current Android connectivity milestone

- [x] Android APK builds and launches in Android Emulator.
- [x] Unity UI is visible in the emulator.
- [x] Unity source is configured to call `http://10.0.2.2:11434/api/generate`.
- [x] Windows-local Ollama API responds.
- [ ] The emulator can reach Ollama on the host at port 11434.
- [ ] The Android app receives and displays a real model response.
- [ ] The connection setup is restricted to the intended development environment.

## 8. Out of scope

- Fully autonomous operation.
- Arbitrary device control.
- General-purpose tool execution.
- On-device inference selection or optimization.
- Production security model and app distribution.
- Claims of persistent memory or multi-step task completion without an implementation and tests.
