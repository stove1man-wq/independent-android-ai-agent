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
