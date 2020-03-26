import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:mockito/mockito.dart';
import 'package:moronepo/src/command/update_flutter_sdk_command.dart';
import 'package:moronepo/src/flutter_finder/flutter_finder.dart';
import 'package:moronepo/src/monorepo_command_runner.dart';
import 'package:moronepo/src/process_starter/process_starter.dart';
import 'package:test/test.dart';

import '../directories.dart';
import '../trimmer.dart';

void main() {
  final testDirectory = "${projectDirectory.path}/test_resources/command/test_project_with_version";

  group("update-flutter-sdk", () {
    CommandRunner commandRunner;
    MockProcessStarter processStarter;

    setUp(() {
      processStarter = MockProcessStarter();
    });

    test("should notify if no projects found", () async {
      final emptyDirectory =
          "${projectDirectory.path}/test_resources/command/test_project/empty_directory";
      expect(
          () => MonorepoCommandRunner.withDefaultCommands().run([
                "-d",
                emptyDirectory,
                "update-flutter-sdk",
              ]),
          prints("No root project found in $emptyDirectory\n"));
    });

    test("should not update sdk if current version within constraints", () async {
      // given
      final updateCommand = UpdateFlutterSdkCommand(processStarter: processStarter);
      commandRunner = MonorepoCommandRunner([updateCommand]);
      when(processStarter.start("flutter", ["--version"], any))
          .thenAnswer((_) => Future.value(ProcessOutput("Flutter 1.10.1 • channel ...")));

      // when
      await commandRunner.run([
        "-d",
        testDirectory,
        "update-flutter-sdk",
      ]);

      // then
      verifyInOrder([
        processStarter.start("flutter", ["--version"], any),
      ]);
    });

    test("should fetch refs and update sdk if current version not within constraints", () async {
      // given
      final flutterFinder = MockFlutterFinder();
      final flutterSdkPath = "/path/to/flutter";
      final updateCommand = UpdateFlutterSdkCommand(
        processStarter: processStarter,
        flutterFinder: flutterFinder,
      );
      when(flutterFinder.findFlutter()).thenReturn(flutterSdkPath);
      commandRunner = MonorepoCommandRunner([updateCommand]);
      when(processStarter.start("flutter", ["--version"], any))
          .thenAnswer((_) => Future.value(ProcessOutput("Flutter 1.9.8 • channel ...")));
      when(processStarter.start("flutter", ["version"], any))
          .thenAnswer((_) => Future.value(ProcessOutput(trim("""
            v1.12.13+hotfix.8
            v1.11.0
            v1.10.1
            v1.10.0
            """))));

      // when
      await commandRunner.run([
        "-d",
        testDirectory,
        "update-flutter-sdk",
      ]);

      // then
      verifyInOrder([
        processStarter.start("flutter", ["--version"], any),
        processStarter.start("git", ["fetch"], flutterSdkPath),
        processStarter.start("flutter", ["version"], any),
        processStarter.start("flutter", ["version", "1.10.1"], any),
      ]);
    });
  });
}

class MockProcessStarter extends Mock implements ProcessStarter {}

class MockFlutterFinder extends Mock implements FlutterFinder {}
