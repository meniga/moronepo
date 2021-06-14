import 'dart:async';
import 'dart:io';

import 'package:moronepo/src/command/moronepo_command.dart';
import 'package:moronepo/src/flutter_finder/flutter_finder.dart';
import 'package:moronepo/src/process_starter/process_starter.dart';
import 'package:moronepo/src/project_finder/project_filters.dart';
import 'package:moronepo/src/tag/tag.dart';
import 'package:moronepo/src/tag/tag_not_found_exception.dart';
import 'package:pub_semver/pub_semver.dart';

import '../project_finder/project_finder.dart';

class UpdateFlutterSdkCommand extends MoronepoCommand<Null> {
  @override
  String get description =>
      "Updates Flutter SDK version to environment.flutter in root pubspec.yaml";

  @override
  String get name => "update-flutter-sdk";

  final ProcessStarter _processStarter;
  final FlutterFinder _flutterFinder;

  UpdateFlutterSdkCommand({
     ProcessStarter? processStarter,
     FlutterFinder? flutterFinder,
  })  : this._processStarter = processStarter ?? ProcessStarter(),
        this._flutterFinder = flutterFinder ?? FlutterFinder(Platform.environment["PATH"]);

  @override
  FutureOr<Null> run() async {
    final rootDirectory = moronepoResults.workingDirectory;
    final foundProjects = await ProjectFinder().find(
      path: rootDirectory,
      filters: ProjectFilters(isRoot: true),
    );
    final rootProject = foundProjects.isNotEmpty ? foundProjects.single : null;

    if (rootProject == null) {
      print("No root project found in $rootDirectory");
    } else {
      final versionConstraint = rootProject.flutterVersionConstraint;
      final currentVersion = await _fetchFlutterVersion(rootProject.path);
      final flutterSdkPath = _flutterFinder.findFlutter();

      if (versionConstraint.allows(currentVersion)) {
        print("Flutter version ${currentVersion} within ${versionConstraint}. No need to update.");
      } else {
        await _fetchFlutterSdk(flutterSdkPath);
        final availableTags = await _fetchAvailableFlutterVersions(flutterSdkPath);
        final forcedTag = _determineBestVersion(versionConstraint, availableTags);
        print("Enforcing version ${forcedTag.version} for ${rootProject.name} project");
        await _enforceVersion(forcedTag, flutterSdkPath);
        await _runFlutterPreCache(flutterSdkPath);
      }
    }
  }

  Future<Version> _fetchFlutterVersion(String path) async {
    final processOutput = await _processStarter.start("flutter", ["--version"], path);

    //TODO: delete force unwrap
    final version =
        RegExp(r"Flutter ([^\.]+\.[^\.]+\.[^\s]*)").firstMatch(processOutput.output)!.group(1);
    return Version.parse(version!);
  }

  Future<ProcessOutput> _fetchFlutterSdk(String flutterSdkPath) async {
    return await _processStarter.start("git", ["fetch"], flutterSdkPath);
  }

  Future<List<Tag>> _fetchAvailableFlutterVersions(String path) async {
    final processOutput = await _processStarter.start("git", ["tag", "-l", "*.*.*"], path);
    final versionStrings = processOutput.output.split("\n");
    return versionStrings
        .where((it) => it.isNotEmpty)
        .map((it) => Tag(value: it))
        .toList();
  }

  Tag _determineBestVersion(VersionConstraint constraint, List<Tag> availableTags) {
    final versionCandidates = availableTags.where((it) => constraint.allows(it.version)).toList();
    versionCandidates.sort((first, second) => Version.antiprioritize(first.version, second.version));
    return versionCandidates.isNotEmpty ? versionCandidates.first : throw TagNotFoundException(constraint);
  }

  Future<void> _enforceVersion(Tag forcedTag, String path) async {
    await _processStarter.start(
      "git",
      [
        "checkout",
        forcedTag.value,
      ],
      path,
    );
  }

  Future<ProcessOutput> _runFlutterPreCache(String path) async {
   return await _processStarter.start("flutter", ["precache"], path);
  }
}
