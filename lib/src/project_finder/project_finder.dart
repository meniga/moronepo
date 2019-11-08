import 'dart:async';
import 'dart:io';

import 'package:glob/glob.dart';
import 'package:monorepo/src/project_finder/project.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:path/path.dart';

class ProjectFinder {
  Future<List<Project>> find({String path}) {
    return Glob("{**/pubspec.yaml,pubspec.yaml}")
        .list(root: path)
        .map((FileSystemEntity entity) => File(entity.path))
        .where((file) => !file.path.contains('/.'))
        .asyncMap((File file) async {
      final content = await file.readAsString();
      final pubspec = Pubspec.parse(content);
      return Project(name: pubspec.name, path: dirname(file.path));
    }).toList();
  }
}
