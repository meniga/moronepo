import 'package:moronepo/src/monorepo_command_runner.dart';
import 'package:test/test.dart';

import '../directories.dart';

void main() {
  group("run", () {
    final testDirectory = "${projectDirectory.path}/test_resources/command/test_project";

    test("should notify if no projects found", () async {
      final emptyDirectory = "${testDirectory}/empty_directory";
      expect(
          () => MonorepoCommandRunner.withDefaultCommands().run([
                "--working-directory",
                emptyDirectory,
                "run",
                "echo",
              ]),
          prints("No projects found in $emptyDirectory\n"));
    });

    test("should run command for each project", () async {
      expect(
          () => MonorepoCommandRunner.withDefaultCommands().run([
                "--working-directory",
                testDirectory,
                "run",
                "echo",
                "i",
                "ran",
              ]),
          prints(allOf(
            contains("Running \"echo i ran\" for project_inside_project project\n"),
            contains("Running \"echo i ran\" for project_inside_directory project\n"),
            contains("Running \"echo i ran\" for root project\n"),
            contains("Running \"echo i ran\" for project_with_tests project\n"),
            contains("Running \"echo i ran\" for project2 project\n"),
            contains("Running \"echo i ran\" for project_inside_project project\n"),
          )));
    });

    test("should exit on first failure", () async {
      expect(
        () => MonorepoCommandRunner.withDefaultCommands().run([
          "--working-directory",
          testDirectory,
          "run",
          "UNAVAILABLE_COMMAND_TO_FAIL_THE_TEST",
        ]),
        prints(
          contains(
              "Running \"UNAVAILABLE_COMMAND_TO_FAIL_THE_TEST\" for project_with_flutter project\n"),
        ),
      );
    });
  });

  group("test", () {
    final testDirectory = "${projectDirectory.path}/test_resources/command/test_project_for_test";

    test("should run flutter test command for flutter projects", () async {
      expect(
          () => MonorepoCommandRunner.withDefaultCommands().run([
                "--working-directory",
                testDirectory,
                "--filter",
                "hasTests,isFlutter",
                "run",
                "--",
                "flutter",
                "test",
                "--coverage",
              ]),
          prints(allOf(
            contains(
                "Running \"flutter test --coverage\" for project_with_flutter_tests project\n"),
          )));
    });

    test("should run flutter pub run test command for dart projects", () async {
      expect(
          () => MonorepoCommandRunner.withDefaultCommands().run([
                "--working-directory",
                testDirectory,
                "--filter",
                "hasTests,isDart",
                "run",
                "flutter",
                "pub",
                "run",
                "test",
              ]),
          prints(allOf(
            contains("Running \"flutter pub run test\" for project_with_tests project\n"),
          )));
    });
  });
}
