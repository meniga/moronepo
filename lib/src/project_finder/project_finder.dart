import 'dart:async';
import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:moronepo/src/project_finder/project_filters.dart';
import 'package:path/path.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

import 'project.dart';

/// Search helper for projects in a mono repo.
class ProjectFinder {
  /// Find [Project]s in [path] using [filters]
  Future<List<Project>> find({
    required String path,
    ProjectFilters filters = const ProjectFilters(),
  }) {
    return Glob("{**/pubspec.yaml,pubspec.yaml}")
        .list(root: path)
        .map((FileSystemEntity entity) => File(entity.path))
        .where((file) => !file.path.contains('/.'))
        .asyncMap((File file) async {
          final content = await file.readAsString();
          final pubspec = Pubspec.parse(content);
          final projectPath = dirname(file.path);
          return Project(
            name: pubspec.name,
            path: projectPath,
            isFlutter: pubspec.dependencies.containsKey("flutter"),
            hasTests: _hasTests(pubspec, projectPath),
            isRoot: file.parent.path == path,
            //TODO Force unwrap
            flutterVersionConstraint: pubspec.environment!["flutter"],
            dependencies: pubspec.dependencies.keys,
            devDependencies: pubspec.devDependencies.keys,
          );
        })
        .where((project) => _hasParameterIfExpectedTo(project.isRoot, filters.isRoot))
        .where((project) => _hasParameterIfExpectedTo(project.name, filters.name))
        .where((project) => _hasParameterIfExpectedTo(project.hasTests, filters.hasTests))
        .where((project) => _hasParameterIfExpectedTo(project.isFlutter, filters.isFlutter))
        .where((project) => _hasDependenciesIfExpectedTo(project, filters.dependencies))
        .toList();
  }

  bool _hasTests(Pubspec pubspec, String projectPath) {
    final hasTestDependency =
        pubspec.devDependencies.keys.where((it) => _isTestDependency(it)).isNotEmpty;
    final hasTestDirectory = Directory("${projectPath}/test").existsSync();
    return hasTestDependency && hasTestDirectory;
  }

  bool _hasDependenciesIfExpectedTo(Project project, List<String>? dependencies) {
    final allDependencies = project.dependencies.followedBy(project.devDependencies);
    return (dependencies != null && dependencies.isNotEmpty)
        ? dependencies.every((it) => allDependencies.contains(it))
        : true;
  }

  bool _isTestDependency(String dependencyName) => [
        "flutter_test",
        "test",
        "test_api",
      ].contains(dependencyName);

  bool _hasParameterIfExpectedTo<T>(T provided, T expected) {
    return expected != null ? provided == expected : true;
  }
}
