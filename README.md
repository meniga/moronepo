# moronepo

A tool to simplify developement in a dart multi-package repository. 

# MVP

- run command for each project
- run command for a specific project, e.g. `moronepo -p bank42_widgets flutter test --update-goldens`
- installable as a global command, e.g. `pub global activate moronepo`
- what is a subproject (including root)? everything that has a pubspec.yaml file
- print out packages tree (name, path)

# Next iterations
- flutter test --update-goldens ||

class Subproject {
  hasTestDirectory;
  isFlutter;
}

- filter projects by relative path
- filter projects by type and features (e.g. has tests or not)

- run multiple commands per project
