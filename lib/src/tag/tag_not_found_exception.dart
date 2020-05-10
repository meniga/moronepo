import 'package:pub_semver/src/version_constraint.dart';

class TagNotFoundException {
  final VersionConstraint _constraint;

  TagNotFoundException(this._constraint);

  @override
  String toString() => "Tag not found for ${_constraint.toString()} constraint";
}
