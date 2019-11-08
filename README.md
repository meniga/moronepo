# monorepo

[![Build Status](https://travis-ci.org/meniga/moronepo.svg?branch=master)](https://travis-ci.org/meniga/moronepo)
[![codecov](https://codecov.io/gh/meniga/moronepo/branch/master/graph/badge.svg)](https://codecov.io/gh/meniga/moronepo)

A tool to simplify development in a dart multi-package repository. 

Currently, it supports:

[Print packages](#print-packages)

[Run command](#run-command)

# Usage

Add `monorepo` to `dev_dependencies`.

```yaml
dev_dependencies:
  monorepo: any
```

### Print packages 

```bash
pub run monorepo print
```

### Run command

```bash
pub run monorepo run [-p project_name>] <command>
```

For example:

```bash
pub run monorepo run pub get
```

# MVP

- installable as a global command, e.g. `pub global activate moronepo`
- what is a subproject (including root)? everything that has a pubspec.yaml file

# Next iterations
- flutter test --update-goldens ||

class Subproject {
  hasTestDirectory;
  isFlutter;
}

- filter projects by relative path
- filter projects by type and features (e.g. has tests or not)

- run multiple commands per project
