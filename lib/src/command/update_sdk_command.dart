import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:moronepo/src/command/moronepo_command.dart';
import 'package:moronepo/src/flutter_finder/flutter_finder.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:quiver/check.dart';

import '../project_finder/project.dart';
import '../project_finder/project_finder.dart';

class UpdateSdkCommand extends MoronepoCommand<Null> {
  @override
  String get description =>
      "Updates Flutter SDK version to environment.flutter in root pubspec.yaml";

  @override
  String get name => "update-sdk";

  final ProcessStarter _processStarter;
  final FlutterFinder _flutterFinder;

  UpdateSdkCommand({
    ProcessStarter processStarter,
    FlutterFinder flutterFinder,
  })
      : this._processStarter = processStarter ?? ProcessStarter(),
        this._flutterFinder = flutterFinder ?? FlutterFinder(Platform.environment["PATH"]);

  @override
  FutureOr<Null> run() async {
    final rootDirectory = moronepoResults.workingDirectory ?? Directory.current.path;
    final finder = ProjectFinder();
    Iterable<Project> projects = await finder.find(path: rootDirectory);
    final project = projects.firstWhere((it) => it.isRoot, orElse: () => null);

    if (project == null) {
      print("No root project found in $rootDirectory");
    } else {
      final versionConstraint = project.pubspec.environment["flutter"];
      final currentVersion = await _fetchFlutterVersion(project.path);

      if (versionConstraint.allows(Version.parse(currentVersion))) {
        print("Flutter version ${currentVersion} within ${versionConstraint}. No need to update.");
      } else {
        await _fetchFlutterSdk();
        final availableVersions = await _fetchAvailableFlutterVersions(project.path);
        final forcedVersion = _determineBestVersion(versionConstraint, availableVersions);
        print("Running flutter version ${forcedVersion} for ${project.name} project");
        await _enforceVersion(forcedVersion, project.path);
      }
    }
  }

  Future<String> _fetchFlutterVersion(String path) async {
    final processOutput = await _processStarter.start("flutter", ["--version"], path);
    return processOutput.output.split(" ")[1];
  }

  Future<void> _fetchFlutterSdk() async {
    final flutterSdkPath = _flutterFinder.findFlutter();
    return _processStarter.start("git", ["fetch"], flutterSdkPath);
  }

  Future<List<Version>> _fetchAvailableFlutterVersions(String path) async {
    final processOutput = await _processStarter.start("flutter", ["version"], path);
    final versionStrings = processOutput.output.split("\n");
    return versionStrings
        .where((it) => it.isNotEmpty)
        .map((it) => Version.parse(it.substring(1)))
        .toList();
  }

  Version _determineBestVersion(VersionConstraint constraint, List<Version> availableVersions) {
    final versionCandidates = availableVersions.where((it) => constraint.allows(it)).toList();
    versionCandidates.sort((first, second) => Version.antiprioritize(first, second));
    return versionCandidates.first ?? Version.none;
  }

  Future<void> _enforceVersion(Version forcedVersion, String path) async {
    await _processStarter.start(
      "flutter",
      [
        "version",
        forcedVersion.toString(),
      ],
      path,
    );
  }
}

class ProcessStarter {
  Future<ProcessOutput> start(String command,
      List<String> arguments,
      String workingDirectory,) {
    return Process.start(
      command,
      arguments,
      workingDirectory: workingDirectory,
      runInShell: true,
    ).then((process) async {
      final stdoutBroadcast = process.stdout.asBroadcastStream();
      final output = stdoutBroadcast.transform(utf8.decoder).join();
      await stdout.addStream(stdoutBroadcast);
      await stderr.addStream(process.stderr);
      final stringOutput = await output;
      return ProcessOutput(stringOutput);
    });
  }
}

class ProcessOutput {
  final String output;

  ProcessOutput(this.output) {
    checkNotNull(output);
  }
}
