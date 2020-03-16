import 'dart:io';

import 'package:moronepo/src/monorepo_command_runner.dart';
import 'package:test/test.dart';

void main() {
  final testResourcesPath = "${Directory.current.path}/test_resources";

  group("print", () {
    test("should print project structure", () async {
      expect(
          () => MonorepoCommandRunner().run([
                "-d",
                "$testResourcesPath/command/test_project",
                "print",
              ]),
          prints("""project1
project2
project_inside_directory
project_inside_project
project_with_tests
root
"""));
    });

    test("should notify if no projects found", () async {
      final emptyDirectory = "$testResourcesPath/command/test_project/empty_directory";
      expect(
          () => MonorepoCommandRunner().run([
                "-d",
                emptyDirectory,
                "print",
              ]),
          prints("No projects found in $emptyDirectory\n"));
    });
  });
}
