import 'package:meta/meta.dart';
import 'package:moronepo/moronepo.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:quiver/check.dart';

/// Represents a project returned by [ProjectFinder]
class Project {
  final String name;
  final String path;
  final bool isFlutter;
  final bool hasTests;
  final bool isRoot;
  final VersionConstraint flutterVersionConstraint;
  final Iterable<String> dependencies;
  final Iterable<String> devDependencies;

  Project({
    @required this.name,
    @required this.path,
    @required this.isFlutter,
    @required this.hasTests,
    @required this.isRoot,
    Iterable<String> dependencies,
    Iterable<String> devDependencies,
    VersionConstraint flutterVersionConstraint,
  })  : this.flutterVersionConstraint = flutterVersionConstraint ?? VersionConstraint.any,
        this.dependencies = dependencies ?? [],
        this.devDependencies = devDependencies ?? [] {
    checkNotNull(name);
    checkNotNull(path);
    checkNotNull(isFlutter);
    checkNotNull(hasTests);
    checkNotNull(isRoot);
  }

  @override
  String toString() => name;
}
