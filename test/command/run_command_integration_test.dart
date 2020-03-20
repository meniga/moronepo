import 'package:moronepo/src/monorepo_command_runner.dart';
import 'package:test/test.dart';

import '../directories.dart';

void main() {
  group("run", () {
    test("should notify if no projects found", () async {
      final emptyDirectory =
          "${projectDirectory.path}/test_resources/command/test_project/empty_directory";
      expect(
          () => MonorepoCommandRunner.withDefaultCommands().run([
                "-d",
                emptyDirectory,
                "run",
                "echo",
              ]),
          prints("No projects found in $emptyDirectory\n"));
    });
  });
}
