# Project Architecture

**Project:** Independent Android AI Agent  
**Status:** Prototype; Android Emulator-to-host Ollama connectivity is not yet verified  
**Last verified documentation state:** 2026-10-10

## Purpose and current scope

Build an Android-capable AI agent with a Unity-based application. The current milestone is deliberately narrow: prove a text request/response from the Unity Android app in Android Emulator to an Ollama model running on the development PC. Autonomous planning, general tool execution, device control, on-device inference, and production distribution are not yet implemented or verified.

## Current components

- **Unity application (C#):** application UI and Android build. The current prototype UI is in `Assets/Scripts/AgentPrototypeUI.cs`.
- **Prototype model client:** currently included in the prototype script; sends an HTTP POST to Ollama. This is a prototype arrangement, not a final module boundary.
- **Ollama on the development PC:** local inference endpoint used for development/testing with `llama3.1:8b`. It is not assumed to be installed on end-user phones.
- **Android Emulator:** runs the built APK. In the standard emulator, `10.0.2.2` is the host-machine alias.
- **Android Studio / Android SDK:** supporting tools for emulator, APK installation, ADB and diagnostics.

## Current request path

```text
Unity UI in Android Emulator
  -> HTTP POST http://10.0.2.2:11434/api/generate
  -> Android Emulator host alias
  -> Windows networking / firewall
  -> Ollama API on the development PC
  -> llama3.1:8b
  -> response displayed by the app
```

The final response path is not yet verified end to end. Windows-local Ollama API requests succeeded, but the Android app has not yet displayed a confirmed model response.

## Intended responsibility boundaries

As the prototype grows, keep these responsibilities separate:

1. **Presentation:** UI, user input, progress, response and cancellation controls.
2. **Agent core:** task state, orchestration, memory and error handling.
3. **AI engine abstraction:** provider/model-specific request and response handling.
4. **Transport:** HTTP/network configuration, timeouts, serialization and transport errors.
5. **Android capability layer:** explicit, permission-controlled device capabilities.
6. **Validation and policy:** validate model output; never treat generated text as executable authority.

These are architectural targets, not a claim that all modules already exist. Do not perform a broad refactor merely to make the current prototype match the target structure.

## Platform and security constraints

- Unity is the primary application platform; C# is the main language.
- Android Studio is a supporting Android development and diagnostic tool, not a reason to rewrite the app as a native Android project.
- Ollama on the development PC is a current test backend, not a required end-user dependency.
- Do not expose the development Ollama endpoint to the public internet.
- Do not execute arbitrary shell commands, code or Android actions directly from model output.
- Require validation, narrow allowlists and user confirmation for consequential actions.

## Detailed architecture record

See [Android integration architecture v0.1](architecture/android_integration_architecture_v0.1.md) for the current prototype path, diagnostic sequence and milestone acceptance criteria.

## Change policy

Architecture changes must have a concrete reason, a small implementation plan, compatibility checks, acceptance criteria and user approval before a major platform, dependency or module-boundary change. Update [DECISIONS.md](DECISIONS.md) when a material decision is accepted.
