import 'package:equatable/equatable.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:quiver/check.dart';

class Project extends Equatable {
  final String name;
  final String path;
  final bool isFlutter;
  final bool hasTests;
  final bool isRoot;
  final Pubspec pubspec;

  Project({this.name, this.path, this.isFlutter, this.hasTests, this.isRoot, this.pubspec}) {
    checkNotNull(name);
    checkNotNull(path);
    checkNotNull(isFlutter);
    checkNotNull(hasTests);
    checkNotNull(isRoot);
    checkNotNull(pubspec);
  }

  @override
  List<Object> get props => [
        name,
        path,
        isFlutter,
        hasTests,
        isRoot,
        pubspec,
      ];

  @override
  bool get stringify => true;
}
