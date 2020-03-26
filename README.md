# moronepo

[![pub package](https://img.shields.io/pub/v/moronepo.svg)](https://pub.dev/packages/moronepo)
[![Build Status](https://travis-ci.org/meniga/moronepo.svg?branch=master)](https://travis-ci.org/meniga/moronepo)
[![codecov](https://codecov.io/gh/meniga/moronepo/branch/master/graph/badge.svg)](https://codecov.io/gh/meniga/moronepo)

A tool to simplify development in a dart multi-package repository. 

Currently, it supports:

[Print packages](#print-packages)

[Run command](#run-command)

[Test command](#test-command)

[Update Flutter SDK command](#update-flutter-sdk-command)

# Usage

Add `moronepo` to `dev_dependencies`.

```yaml
dev_dependencies:
  moronepo: any
```

### Print packages 

```bash
pub run moronepo print
```

### Run command

```bash
pub run moronepo run [-p project_name>] <command>
```

For example:

```bash
pub run moronepo run pub get
```

### Test command

```bash
pub run moronepo test [-p project_name] <args_for_test>
```

### Update-flutter-sdk command

Specifying `environment.flutter` in `pubspec.yaml`:

```yaml
name: project
environment:
  flutter: ">=1.10.0 <1.11.0"
```

and then running:

```bash
pub run moronepo update-flutter-sdk [-p project_name]
```

forces an update to the Flutter SDK to the latest version within those
constraints.

# MVP

- installable as a global command, e.g. `pub global activate moronepo`
- what is a subproject (including root)? everything that has a pubspec.yaml file

# Next iterations
- filter projects by relative path
- filter projects by type and features (e.g. has tests or not)
- run multiple commands per project
