# Project Status

**Status date:** 2026-10-10  
**Project:** Independent Android AI Agent  
**Status confidence:** Windows Ollama API is verified. Android logcat previously identified Unity's insecure-HTTP policy as the immediate blocker. After the attempted settings change, the request still hangs and a filtered log query returned no matching lines. Windows `netstat` shows port 11434 listening on `0.0.0.0` and `::` under PID 17632, plus `127.0.0.1` under PID 19544; process identity and the current Android error still need verification.

## Current summary

The Unity prototype was built as an Android APK and launched successfully in Android Emulator after changing the Graphics API configuration from Vulkan to OpenGLES3. The app UI is visible in the emulator.

The Unity script `Assets/Scripts/AgentPrototypeUI.cs` was changed to use the Android Emulator host alias:

```csharp
private const string OllamaUrl = "http://10.0.2.2:11434/api/generate";
```

Ollama was also configured to listen on network interfaces rather than only its loopback interface. The exact persistence mechanism for that setting has not yet been re-verified in this session.

On Windows, both `http://localhost:11434/api/tags` and `http://127.0.0.1:11434/api/tags` return the installed model list. A non-streaming `/api/generate` request to `llama3.1:8b` returned `"response":"OLLAMA_OK"` and `"done":true`.

**Current blocker:** Android request hangs with no response. A previous logcat capture showed Unity blocking HTTP (`Non-secure network connections disabled in Player Settings` / `InvalidOperationException: Insecure connection not allowed`), but a later filtered log query returned no lines, so the current failure is not yet confirmed. `netstat -ano | findstr :11434` shows listeners on `0.0.0.0:11434` (PID 17632), `[::]:11434` (PID 17632), and `127.0.0.1:11434` (PID 19544). This does not by itself establish which process serves Ollama or whether the emulator can connect.

## Verified observations

- Unity project path: `C:\Users\max\Documents\Projects\IndependentAgentUnitySpike\IndependentAgentUnitySpike`.
- Prototype script: `Assets/Scripts/AgentPrototypeUI.cs`.
- Documentation repository: `C:\Users\max\Documents\Projects\independent-android-ai-agent`.
- GitHub repository: `stove1man-wq/independent-android-ai-agent`.
- The Unity prototype previously demonstrated a real text request/response with Ollama on the development PC using `llama3.1:8b`.
- The Android APK was built and launched in Android Emulator; the UI is visible.
- Vulkan caused a black screen in the emulator; the user removed Vulkan and left OpenGLES3, then rebuilt `Builds\IndependentAndroidAgent_Test.apk` and successfully launched it.
- `AgentPrototypeUI.cs` was changed to use `http://10.0.2.2:11434/api/generate` for the Android Emulator.
- Ollama was configured to listen on all/network interfaces (reported by the user); the exact current listener binding still needs direct verification.
- On 2026-10-10, `curl.exe http://localhost:11434/api/tags` and `curl.exe http://127.0.0.1:11434/api/tags` both returned the installed models.
- On 2026-10-10, a JSON file was posted to `http://localhost:11434/api/generate`; `llama3.1:8b` returned `OLLAMA_OK` with `done:true`.
- User reports that the Android app still does not see/reach Ollama.

## Current blocker and unknowns

- The exact error shown by the Android app has not yet been captured in this conversation.
- Emulator-to-host TCP connectivity on port 11434 has not yet been tested. Android shell has no `curl` executable (`curl: inaccessible or not found`).
- ADB is not currently available as a bare command in PowerShell (`adb : The term 'adb' is not recognized`). This only indicates that adb is not on the current PATH; it does not mean the Android SDK or emulator is absent.
- Windows listener addresses are now observed via `netstat`, but the PIDs have not yet been identified as Ollama or another process; Windows Firewall behavior is still unverified.
- Android manifest Internet permission has not yet been inspected. The immediate observed rejection comes from Unity Player Settings' insecure-HTTP policy, before the request reaches Ollama.
- It is not yet known whether the currently running APK contains the latest `10.0.2.2` endpoint change; confirm before assuming the installed binary matches the source.
- Server-side cancellation, systematic timeout/HTTP/JSON failure tests, duplicate-request stress testing, agent tool execution, persistent memory, and autonomous multi-step behavior remain unverified.

## Current direction

1. Identify listener PIDs 17632 and 19544 with `Get-Process -Id 17632,19544` in PowerShell before changing services or firewall.
2. Capture fresh Unity logs after reproducing a single request, without relying only on narrow text filters.
3. Confirm Unity's **Allow downloads over HTTP** setting is applied to the Android build; rebuild only if the installed APK predates that setting.
4. Test emulator-to-host connectivity using a suitable Android-side tool or app because `curl` is absent from the emulator shell.
5. If the current error points to networking, inspect Windows Firewall rules for the identified listener process. Do not expose Ollama to the public internet.
6. Record the test outcome here and in the development log.

## Current milestone

**Milestone:** Android APK launches in the emulator and attempts to connect to a PC-hosted Ollama model.

**Passed:**
- APK builds and launches in Android Emulator.
- Unity UI is visible.
- Windows Ollama API responds on localhost and 127.0.0.1.
- `llama3.1:8b` generation request returns `OLLAMA_OK`.

**Not passed yet:**
- Android app receives a response from Ollama. A prior Unity HTTP-policy error was captured; current request hangs and requires fresh diagnosis.

## Source of truth and update rule

Use this document for the latest verified project state. Update it when a milestone is demonstrated, not merely planned. Record architectural choices and their rationale in `DECISIONS.md`; record dated work and test outcomes in `DEVELOPMENT_LOG.md`. At each meaningful development step, update GitHub before moving to the next step.
