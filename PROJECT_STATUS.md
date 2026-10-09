# Project Status

**Status date:** 2026-10-10  
**Project:** Independent Android AI Agent  
**Status confidence:** Windows Ollama API is verified. Android APK logcat has identified the immediate blocker: Unity Player Settings prohibit insecure HTTP connections. The endpoint has not yet been reached; fix the HTTP policy for this local prototype, rebuild, and retest.

## Current summary

The Unity prototype was built as an Android APK and launched successfully in Android Emulator after changing the Graphics API configuration from Vulkan to OpenGLES3. The app UI is visible in the emulator.

The Unity script `Assets/Scripts/AgentPrototypeUI.cs` was changed to use the Android Emulator host alias:

```csharp
private const string OllamaUrl = "http://10.0.2.2:11434/api/generate";
```

Ollama was also configured to listen on network interfaces rather than only its loopback interface. The exact persistence mechanism for that setting has not yet been re-verified in this session.

On Windows, both `http://localhost:11434/api/tags` and `http://127.0.0.1:11434/api/tags` return the installed model list. A non-streaming `/api/generate` request to `llama3.1:8b` returned `"response":"OLLAMA_OK"` and `"done":true`.

**Current blocker (root cause identified):** Android logcat shows `Non-secure network connections disabled in Player Settings` followed by `InvalidOperationException: Insecure connection not allowed` when `UnityWebRequest.SendWebRequest()` runs. Unity is rejecting the `http://10.0.2.2:11434/api/generate` request before a network connection is attempted. The next action is to allow HTTP in Unity Player Settings for this local development prototype, rebuild/reinstall the APK, and retest. If the error changes, diagnose the new error rather than assuming connectivity is fixed.

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
- Emulator-to-host TCP connectivity on port 11434 has not yet been tested.
- ADB is not currently available as a bare command in PowerShell (`adb : The term 'adb' is not recognized`). This only indicates that adb is not on the current PATH; it does not mean the Android SDK or emulator is absent.
- Ollama's actual listening address and Windows Firewall behavior have not yet been verified.
- Android manifest Internet permission has not yet been inspected. The immediate observed rejection comes from Unity Player Settings' insecure-HTTP policy, before the request reaches Ollama.
- It is not yet known whether the currently running APK contains the latest `10.0.2.2` endpoint change; confirm before assuming the installed binary matches the source.
- Server-side cancellation, systematic timeout/HTTP/JSON failure tests, duplicate-request stress testing, agent tool execution, persistent memory, and autonomous multi-step behavior remain unverified.

## Current direction

1. In Unity, open **Edit → Project Settings → Player → Android → Other Settings → Configuration** and set **Allow downloads over HTTP** to **Always Allowed** (wording/location may vary slightly by Unity version). This is for local prototype testing only because HTTP is unencrypted.
2. Rebuild and reinstall the APK, then send one test request.
3. Use the full SDK path `C:\\Users\\max\\AppData\\Local\\Android\\Sdk\\platform-tools\\adb.exe` to capture logcat if the request still fails.
4. If the error changes, use the new error to test emulator-to-host connectivity and Ollama listener/firewall; do not assume success from removing the Unity HTTP-policy error alone.
5. Inspect Android manifest Internet permission only if evidence points there.
6. Record the test outcome here and in the development log.
7. Do not expose Ollama to the public internet; limit network access to the development environment.

## Current milestone

**Milestone:** Android APK launches in the emulator and attempts to connect to a PC-hosted Ollama model.

**Passed:**
- APK builds and launches in Android Emulator.
- Unity UI is visible.
- Windows Ollama API responds on localhost and 127.0.0.1.
- `llama3.1:8b` generation request returns `OLLAMA_OK`.

**Not passed yet:**
- Android app receives a response from Ollama. The immediate Unity HTTP-policy blocker is identified but not yet corrected or retested.

## Source of truth and update rule

Use this document for the latest verified project state. Update it when a milestone is demonstrated, not merely planned. Record architectural choices and their rationale in `DECISIONS.md`; record dated work and test outcomes in `DEVELOPMENT_LOG.md`. At each meaningful development step, update GitHub before moving to the next step.
