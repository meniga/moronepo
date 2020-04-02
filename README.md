# moronepo

[![pub package](https://img.shields.io/pub/v/moronepo.svg)](https://pub.dev/packages/moronepo)
[![Build Status](https://travis-ci.org/meniga/moronepo.svg?branch=master)](https://travis-ci.org/meniga/moronepo)
[![codecov](https://codecov.io/gh/meniga/moronepo/branch/master/graph/badge.svg)](https://codecov.io/gh/meniga/moronepo)

A tool to simplify development in a dart multi-package repository. 

Currently, it supports following commands:

[print command](#print-command)

[run command](#run-command)

[update-flutter-sdk command](#update-flutter-sdk-command)

# Usage

Add `moronepo` to `dev_dependencies`.

```yaml
dev_dependencies:
  moronepo: ^0.1.1
```

Run the moronepo command:

```bash
pub run moronepo [--filter <filter>] [--project <name>] [--working-directory <path>] <command>
```

where `filter` is a comma-separated list of filters `hasTests,isFlutter,isRoot`.
Each filter can be negated by preceding it with a `!`, for example `!isFlutter`.

### print command

```bash
pub run moronepo print
```

### run command

```bash
pub run moronepo run <command>
```

For example:

```bash
pub run moronepo run pub get
```

### update-flutter-sdk command

Specifying `environment.flutter` in `pubspec.yaml`:

```yaml
name: project
environment:
  flutter: ">=1.10.0 <1.11.0"
```

and then running:

```bash
pub run moronepo update-flutter-sdk
```

forces an update to the Flutter SDK to the latest version within those
constraints.

# Tips

### Installing as a global command

You can follow [how to set up a global command](https://dart.dev/tools/pub/cmd/pub-global)  
and activate `moronepo`:

```bash
pub global activate moronepo
```

to make it available as a regular shell command:

```bash
moronepo print
```
