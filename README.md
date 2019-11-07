# moronepo

[![Build Status](https://travis-ci.org/meniga/moronepo.svg?branch=master)](https://travis-ci.org/meniga/moronepo)
[![codecov](https://codecov.io/gh/meniga/moronepo/branch/master/graph/badge.svg)](https://codecov.io/gh/meniga/moronepo)

A tool to simplify development in a dart multi-package repository. 

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

# MVP

- run command for each project
- run command for a specific project, e.g. `moronepo -p bank42_widgets flutter test --update-goldens`
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
