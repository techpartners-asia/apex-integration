# InvestX Mini App SDK

## Overview

`mini_app_sdk` is a Flutter SDK package for embedding the InvestX/Apex
investment mini app inside a host Flutter application.

This repository is a Melos monorepo. The repository root is only the workspace;
the actual SDK package is located here:

```text
packages/apex_mini_app_sdk
```

Use the package name from that package's `pubspec.yaml`:

```yaml
name: mini_app_sdk
```

## Installation

### 1. Using Git Tag

Recommended for host apps.

Add this to the host app's `pubspec.yaml`:

```yaml
dependencies:
  mini_app_sdk:
    git:
      url: https://github.com/techpartners-asia/apex-integration.git
      path: packages/apex_mini_app_sdk
      ref: v0.0.1
```

--- Getting Dependencies --- 

For host apps using the Git tag dependency, run only:

```bash
flutter pub get
```

Notes:

- Use `mini_app_sdk` as the dependency key because that is the package name.
- `path: packages/apex_mini_app_sdk` is required because the repository root is
  a workspace, not the SDK package.
- Prefer a stable Git tag such as `v0.0.1` for production usage.



### 2. Using Local Path

Recommended for SDK development or local testing.

```yaml
dependencies:
  mini_app_sdk:
    path: ../apex-integration/packages/apex_mini_app_sdk
```

Make sure the relative path matches your local folder structure.

--- Getting Dependencies ---

For local SDK development, run from the repository root when needed:

```bash
flutter pub get
melos bootstrap
```

## Import

```dart
import 'package:mini_app_sdk/mini_app_sdk.dart';
```

## Notes

- Do not use `apex_integration` as the dependency key.
- Use `mini_app_sdk` because the SDK package defines `name: mini_app_sdk`.
- Always include `path: packages/apex_mini_app_sdk` when using the Git
  dependency.
- Prefer release tags over `main` for production usage.
- Use `main` only when testing the latest unreleased changes.

## Example `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter

  mini_app_sdk:
    git:
      url: https://github.com/techpartners-asia/apex-integration.git
      path: packages/apex_mini_app_sdk
      ref: v0.0.1
```
