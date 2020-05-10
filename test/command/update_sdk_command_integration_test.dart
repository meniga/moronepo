import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:mockito/mockito.dart';
import 'package:moronepo/src/command/update_flutter_sdk_command.dart';
import 'package:moronepo/src/flutter_finder/flutter_finder.dart';
import 'package:moronepo/src/moronepo_command_runner.dart';
import 'package:moronepo/src/process_starter/process_starter.dart';
import 'package:moronepo/src/tag/tag_not_found_exception.dart';
import 'package:test/test.dart';

import '../directories.dart';
import '../trimmer.dart';

void main() {
  final testDirectory =
      "${projectDirectory.path}/test_resources/command/test_project_with_version_constraint";

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
          () => MoronepoCommandRunner.withDefaultCommands().run([
                "--working-directory",
                emptyDirectory,
                "update-flutter-sdk",
              ]),
          prints("No root project found in $emptyDirectory\n"));
    });

    test("should not update sdk if current version within constraints", () async {
      // given
      final updateCommand = UpdateFlutterSdkCommand(processStarter: processStarter);
      commandRunner = MoronepoCommandRunner([updateCommand]);
      when(processStarter.start("flutter", ["--version"], any))
          .thenAnswer((_) => Future.value(ProcessOutput("Flutter 1.10.1 • channel ...")));

      // when
      await commandRunner.run([
        "--working-directory",
        testDirectory,
        "update-flutter-sdk",
      ]);

      // then
      verifyInOrder([
        processStarter.start("flutter", ["--version"], any),
      ]);
    });

    test("should not fail if flutter command is locked", () async {
      // given
      final updateCommand = UpdateFlutterSdkCommand(processStarter: processStarter);
      commandRunner = MoronepoCommandRunner([updateCommand]);
      when(processStarter.start("flutter", ["--version"], any))
          .thenAnswer((_) => Future.value(ProcessOutput(trim("""
          Waiting for another flutter command to release the startup lock...
          Flutter 1.10.1 • channel unknown • unknown source
          """))));

      // when
      await commandRunner.run([
        "--working-directory",
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
      commandRunner = MoronepoCommandRunner([updateCommand]);
      when(processStarter.start("flutter", ["--version"], any))
          .thenAnswer((_) => Future.value(ProcessOutput(trim("""
          Downloading Dart SDK from Flutter engine ...
          Flutter 0.9.6 • channel ...
          """))));
      when(processStarter.start("git", ["tag", "-l", "*.*.*"], any))
          .thenAnswer((_) => Future.value(ProcessOutput(trim("""
            1.10.1
            v1.10.0
            v0.9.6
            """))));

      // when
      await commandRunner.run([
        "--working-directory",
        testDirectory,
        "update-flutter-sdk",
      ]);

      // then
      verifyInOrder([
        processStarter.start("flutter", ["--version"], any),
        processStarter.start("git", ["fetch"], flutterSdkPath),
        processStarter.start("git", ["tag", "-l", "*.*.*"], flutterSdkPath),
        processStarter.start("git", ["checkout", "1.10.1"], flutterSdkPath),
        processStarter.start("flutter", ["doctor"], any),
      ]);
    });

    test("should throw if specified tag not found", () async {
      // given
      final flutterFinder = MockFlutterFinder();
      final flutterSdkPath = "/path/to/flutter";
      final updateCommand = UpdateFlutterSdkCommand(
        processStarter: processStarter,
        flutterFinder: flutterFinder,
      );
      when(flutterFinder.findFlutter()).thenReturn(flutterSdkPath);
      commandRunner = MoronepoCommandRunner([updateCommand]);
      when(processStarter.start("flutter", ["--version"], any))
          .thenAnswer((_) => Future.value(ProcessOutput(trim("""
          Downloading Dart SDK from Flutter engine ...
          Flutter 0.9.6 • channel ...
          """))));
      when(processStarter.start("git", ["tag", "-l", "*.*.*"], any))
          .thenAnswer((_) => Future.value(ProcessOutput(trim("""
            v0.9.6
            """))));

      // expect
      expect(
          () => commandRunner.run([
                "--working-directory",
                testDirectory,
                "update-flutter-sdk",
              ]),
          throwsA(TypeMatcher<TagNotFoundException>()));
    });
  });
}

class MockProcessStarter extends Mock implements ProcessStarter {}

class MockFlutterFinder extends Mock implements FlutterFinder {}
