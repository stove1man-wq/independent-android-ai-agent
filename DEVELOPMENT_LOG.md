# Development Log

## 2026-10-10 — Android Emulator to Ollama connectivity investigation

### Confirmed
- The Android APK is already installed/launched in Android Emulator and the Unity UI is visible.
- The Unity script `Assets/Scripts/AgentPrototypeUI.cs` was changed to use `http://10.0.2.2:11434/api/generate`.
- The user reports configuring Ollama to listen on all/network interfaces.
- Windows requests to both `http://localhost:11434/api/tags` and `http://127.0.0.1:11434/api/tags` return the installed model list.
- A request posted from PowerShell via a UTF-8 JSON file to `http://localhost:11434/api/generate` succeeded with model `llama3.1:8b`, response `OLLAMA_OK`, and `done:true`.
- The Android app still does not receive a response from Ollama.

### Diagnostic attempt
- `adb devices` was attempted from PowerShell but failed because `adb` is not recognized as a command. This means the executable is not available on the current PATH; emulator/SDK absence has not been established.
- Next: locate Android SDK in Android Studio and call `platform-tools\adb.exe` by full path; capture app error/logcat; then test listener, firewall, and emulator-to-host connectivity.
- No conclusion has yet been reached about the root cause. Do not claim the Android network path is fixed.

### Guardrails
- Do not rebuild the APK unless source/build mismatch or a required manifest/code change is demonstrated.
- Change one variable at a time and record the result here.
- Keep Ollama access limited to the development environment; do not expose it to the public internet.


## 2026-10-10 — Root cause identified in Android logcat

- User ran `adb.exe logcat` via the full Android SDK path and reproduced the failure by pressing SEND TASK in the emulator.
- Exact log: `Non-secure network connections disabled in Player Settings` and `InvalidOperationException: Insecure connection not allowed` from `UnityEngine.Networking.UnityWebRequest.SendWebRequest()` called by `AgentPrototypeUI.SendTaskToOllama`.
- This proves Unity rejects the HTTP request under its Player Settings policy before a connection to Ollama is attempted. It does not yet prove that emulator-to-host networking works.
- Next action: in Unity open Edit → Project Settings → Player → Android → Other Settings → Configuration; set **Allow downloads over HTTP** to **Always Allowed** for this local development prototype (HTTP is unencrypted), rebuild/reinstall, and test once more.
- If the error changes, capture fresh logcat and diagnose the new failure. Do not claim the integration works until the app displays a response from Ollama.


## 2026-10-10 — Listener and Android shell checks

- `adb shell` opened successfully. Android emulator shell does not include `curl` (`/system/bin/sh: curl: inaccessible or not found`), so no emulator HTTP request was actually made.
- `Test-NetConnection 10.0.2.2 -Port 11434` was run from Windows; it is not a valid test of emulator-to-host reachability because it runs on the host.
- `netstat -ano | findstr :11434` showed listeners at `0.0.0.0:11434` and `[::]:11434` under PID 17632, and `127.0.0.1:11434` under PID 19544. These PIDs must be identified before changing anything.
- The user reports the app request hangs. A filtered logcat query returned no matching lines; capture broader fresh logs after reproducing before deciding whether the HTTP-policy exception remains.
- Next PowerShell diagnostic: `Get-Process -Id 17632,19544`.
