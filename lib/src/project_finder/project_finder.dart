import 'dart:async';
import 'dart:io';

import 'package:glob/glob.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

import 'project.dart';

class ProjectFinder {
  Future<List<Project>> find({
    @required String path,
    String name,
    bool hasTests,
  }) {
    return Glob("{**/pubspec.yaml,pubspec.yaml}")
        .list(root: path)
        .map((FileSystemEntity entity) => File(entity.path))
        .where((file) => !file.path.contains('/.'))
        .asyncMap((File file) async {
          final content = await file.readAsString();
          final pubspec = Pubspec.parse(content);
          return Project(
              name: pubspec.name,
              path: dirname(file.path),
              isFlutter: pubspec.dependencies.containsKey("flutter"),
              hasTests:
                  pubspec.devDependencies.keys.where((it) => _isTestDependency(it)).isNotEmpty);
        })
        .where((project) => _hasParameterIfExpectedTo(project.name, name))
        .where((project) => _hasParameterIfExpectedTo(project.hasTests, hasTests))
        .toList();
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
