import 'package:meta/meta.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:quiver/check.dart';

class Project {
  final String name;
  final String path;
  final bool isFlutter;
  final bool hasTests;
  final bool isRoot;
  final VersionConstraint flutterVersionConstraint;

  Project({
    @required this.name,
    @required this.path,
    @required this.isFlutter,
    @required this.hasTests,
    @required this.isRoot,
    VersionConstraint flutterVersionConstraint,
  }) : this.flutterVersionConstraint = flutterVersionConstraint ?? VersionConstraint.any {
    checkNotNull(name);
    checkNotNull(path);
    checkNotNull(isFlutter);
    checkNotNull(hasTests);
    checkNotNull(isRoot);
  }
}
