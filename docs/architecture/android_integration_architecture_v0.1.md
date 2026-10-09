# Android Integration Architecture v0.1

- **Status:** Draft proposal, not implemented
- **Version:** 0.1
- **Date:** 2026-10-09
- **Scope:** First practical path from the Unity prototype to a model, with Android deployment considered explicitly.

## 1. Purpose

Define a small, testable integration path for the Independent Android AI Agent. The first goal is to prove model communication; autonomous planning, device control, and broad permissions are out of scope for this milestone.

## 2. Current baseline

The Unity prototype contains a task input, send/stop controls, status text, and response text. A text request from Unity to the local Ollama API using `llama3.1:8b` has been demonstrated on the development PC, and the actual model response was displayed in the Unity UI.

This verifies the basic text request-response path only. Android deployment, device-to-PC connectivity, systematic failure handling, cancellation semantics, and execution of external actions have not been established by this test.

This document is a proposal. It does not imply that any component below has already been implemented.

## 3. Proposed staged architecture

### Stage A — Development PC

```text
Unity UI
  |
  | prompt / status / response
  v
Unity model client (HTTP)
  |
  | HTTP request to configured endpoint
  v
Ollama API on development PC
  |
  v
Selected local model
```

Keep the first integration deliberately narrow: one user prompt produces one model response. Do not add agent tools or Android-specific privileges yet.

### Stage B — Android device

Two deployment options remain open:

1. **Phone connects to Ollama on the development PC.** The phone and PC must be on a reachable network; the server must be configured deliberately for network access, and firewall exposure must be restricted. Do not assume `localhost` on Android refers to the PC—it refers to the device itself.
2. **Inference runs on the Android device.** This requires a separate feasibility check for model format, memory, performance, runtime support, battery use, and distribution size. It is not the first milestone.

Choose between these only after Stage A works and device requirements are known.

## 4. Suggested responsibilities

- **Unity UI:** collect a prompt, show progress and result, allow the user to request cancellation.
- **Model client:** own endpoint configuration, request serialization, HTTP transport, timeouts, response parsing, and error reporting.
- **Ollama:** host the selected model and return generated text.
- **Future agent coordinator (not in v0.1 implementation):** interpret model output and request narrowly defined tools only through explicit, validated interfaces.
- **Future Android capability layer:** expose only approved Android capabilities, with permissions and user confirmation where appropriate.

Avoid mixing networking code into UI event handlers. Keep the model client independently testable.

## 5. First API integration

Ollama commonly exposes a local HTTP API. Before writing Unity networking code, verify the installed Ollama version and API behavior on the development PC. A simple non-streaming generation request is the recommended first integration because it is easier to parse and debug than streaming.

The endpoint and model name must be configurable rather than hard-coded throughout the UI. Use the exact model name shown by the local Ollama installation. Treat example endpoints as environment-specific; do not assume the Android device can reach a PC-only loopback address.

### Request lifecycle

1. User enters a prompt and presses **SEND TASK**.
2. UI validates that the prompt is not empty.
3. Model client sends a request with a bounded timeout.
4. UI shows a pending state and prevents accidental duplicate submissions.
5. On success, the actual model response is shown.
6. On failure, show a useful error category (connection, timeout, HTTP response, or response parsing).
7. **STOP** cancels local waiting/UI work where supported. Do not claim it stops server-side inference unless that behavior has been verified.

## 6. Safety and trust boundaries

Model output is untrusted text, not executable authority.

- Do not execute shell commands, arbitrary code, or Android actions directly from generated text.
- Future tools must use a small allowlist, typed parameters, validation, and clear success/failure results.
- Ask for user confirmation before consequential or destructive actions.
- Keep credentials and private data out of logs.
- Do not expose the Ollama endpoint to the public internet as a shortcut for phone connectivity.
- Distinguish “model generated a suggestion” from “the system performed an action.”

## 7. Reliability requirements for the first client

- Configurable endpoint and model name.
- Non-empty prompt validation.
- Request timeout.
- Visible loading, success, and failure states.
- Response-body and HTTP-status handling.
- Protection against duplicate requests.
- A defined behavior when the user presses **STOP**.
- Logs that help debug failures without dumping sensitive prompt content by default.

## 8. Acceptance criteria for v0.1

- [x] A request succeeds against the local Ollama API outside Unity.
- [x] Unity sends a prompt to that same API.
- [x] Unity displays the real model response rather than a demo placeholder.
- [ ] Invalid input and connection/API errors are systematically tested and shown clearly.
- [ ] Timeout, duplicate-request, and cancellation behavior are tested.
- [ ] The UI wording is verified to distinguish generated text from an executed action.
- [x] The tested endpoint and model name are recorded in project notes: `http://localhost:11434`, `llama3.1:8b`.

## 9. Out of scope

- Fully autonomous operation.
- Arbitrary device control.
- General-purpose tool execution.
- On-device inference selection or optimization.
- Production security model and app distribution.
- Claims of persistent memory or multi-step task completion without an implementation and tests.

## 10. Open decisions

1. Which Ollama model and exact model tag will be the baseline?
2. Which Unity version and API compatibility level are in use?
3. Should the first Android build connect to a PC-hosted model, or is on-device inference a hard requirement?
4. Which actions, if any, should the future agent be allowed to perform?
5. What user confirmation is required for each consequential action?

Resolve these decisions with small experiments and record outcomes in `DECISIONS.md`. Do not treat unanswered questions as settled architecture.
