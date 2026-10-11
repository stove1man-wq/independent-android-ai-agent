# Sync documentation into the local Unity project

The Unity source project and this documentation repository are separate working folders. The helper script copies only the agreed agent/context documents into the Unity project; it does not modify Unity assets, scripts, scenes, project settings, packages, or builds.

## Preview first

From the documentation repository in PowerShell:

```powershell
.\tools\Sync-ProjectDocsToUnity.ps1
```

The default behavior is a dry run. It does not write or delete files.

## Apply

After reviewing the preview:

```powershell
.\tools\Sync-ProjectDocsToUnity.ps1 -Apply
```

The script copies:
- `AGENTS.md`
- `docs/ARCHITECTURE.md`
- `docs/DECISIONS.md`
- `docs/PROGRESS.md`
- `docs/architecture/android_integration_architecture_v0.1.md`

If a destination file exists and differs, the script creates a timestamped backup before replacing it. It never deletes files. The default Unity path is the currently documented working folder; pass `-UnityProjectPath 'D:\path\to\UnityProject'` to override it.

This script synchronizes documentation only. It does not synchronize source code or make the Unity folder a Git repository. Source synchronization and removal of project files require a separate inventory and explicit review.
