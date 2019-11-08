import 'dart:async';
import 'dart:io';

import 'package:glob/glob.dart';
import 'package:monorepo/src/project_finder/project.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

class ProjectFinder {
  Future<List<Project>> find({String path}) {
    return Glob("{**/pubspec.yaml,pubspec.yaml}")
        .list(root: path)
        .asyncMap((FileSystemEntity entity) => File(entity.path).readAsString())
        .map((String content) => Project(Pubspec.parse(content).name))
        .toList();
  }
}
