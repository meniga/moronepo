import 'dart:io';

import 'package:moronepo/src/monorepo_command_runner.dart';
import 'package:test/test.dart';

void main() {
  group("run", () {
    
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
