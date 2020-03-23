import 'package:moronepo/src/monorepo_command_runner.dart';
import 'package:test/test.dart';

import '../directories.dart';

void main() {
  group("test", () {
    test("should run proper test command for every project with tests", () async {
      final emptyDirectory =
          "${projectDirectory.path}/test_resources/command/test_project_for_test";
      expect(
          () => MonorepoCommandRunner().run([
                "-d",
                emptyDirectory,
                "test",
              ]),
          prints(allOf(
            contains("Running \"flutter test\" for project_with_flutter_tests project\n"),
            contains("Running \"flutter pub test\" for project_with_tests project\n"),
            contains("Skipping running tests for project_without_tests project\n"),
          )));
    });
  });
}
