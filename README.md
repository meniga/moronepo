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

Activate `moronepo`:

```bash
pub global activate moronepo
```

or prepend each command with `flutter` if used:

```bash
flutter pub global activate moronepo
```

Now it should be possible to run `moronepo`:

```bash
pub global run moronepo [--filter <filter>] [--project <name>] [--working-directory <path>] <command>
```

where `filter` is a comma-separated list of filters `hasTests,isFlutter,isRoot`.
Each filter can be negated by preceding it with a `!`, for example `!isFlutter`.

You can also follow [how to set up a global command](https://dart.dev/tools/pub/cmd/pub-global)  
to make it available as a regular shell command by appending `PATH`.

```bash
moronepo print
```

or creating an alias instead:

```bash
alias moronepo="flutter pub global run moronepo"

moronepo print
```

### print command

```bash
moronepo print
```

### run command

```bash
moronepo run <command>
```

For example:

```bash
moronepo run pub get
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
moronepo update-flutter-sdk
```

forces an update to the Flutter SDK to the latest version within those
constraints.
