import 'dart:io';

import 'package:monorepo/src/monorepo_command_runner.dart';
import 'package:test/test.dart';

void main() {
  group("print", () {
    test("should print project structure", () async {
      expect(
          () => MonorepoCommandRunner().run([
                "print",
                "-d",
                "${Directory.current.path}/test/command/test_project",
              ]),
          prints("""project1
project2
project_inside_directory
project_inside_project
root
"""));
    });

    test("should notify if no projects found", () async {
      final emptyDirectory = "${Directory.current.path}/test/command/test_project/empty_directory";
      expect(
          () => MonorepoCommandRunner().run([
                "print",
                "-d",
                emptyDirectory,
              ]),
          prints("No projects found in $emptyDirectory\n"));
    });
  });
}
