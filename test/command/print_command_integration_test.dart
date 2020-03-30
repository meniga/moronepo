import 'package:moronepo/src/monorepo_command_runner.dart';
import 'package:test/test.dart';

import '../directories.dart';
import '../trimmer.dart';

void main() {
  final testResourcesPath = "${projectDirectory.path}/test_resources";

  group("print", () {
    test("should print project structure", () async {
      expect(
          () => MonorepoCommandRunner.withDefaultCommands().run([
                "--working-directory",
                "$testResourcesPath/command/test_project",
                "print",
              ]),
          prints(trim("""
            project1
            project2
            project_inside_directory
            project_inside_project
            project_with_flutter
            project_with_tests
            root
          """)));
    });

    test("should notify if no projects found", () async {
      final emptyDirectory = "$testResourcesPath/command/test_project/empty_directory";
      expect(
          () => MonorepoCommandRunner.withDefaultCommands().run([
                "--working-directory",
                emptyDirectory,
                "print",
              ]),
          prints("No projects found in $emptyDirectory\n"));
    });
  });
}
