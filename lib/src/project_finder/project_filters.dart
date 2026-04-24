import 'package:args/args.dart';
import 'package:equatable/equatable.dart';
import 'package:moronepo/moronepo.dart';

/// Represents filters for the [ProjectFinder]
class ProjectFilters extends Equatable {
  final String? name;
  final List<String>? dependencies;
  final bool? isFlutter;
  final bool? hasTests;
  final bool? isRoot;

  const ProjectFilters({
     this.name,
     this.dependencies,
     this.isFlutter,
     this.hasTests,
     this.isRoot,
  });

  factory ProjectFilters.from(ArgResults? results) {
    final List<String> filter = fromResults(results, "filter") ?? [];
    final List<String>? deps = fromResults(results, "dependencies");
    return ProjectFilters(
      name: fromResults(results, "project"),
      dependencies: (deps != null && deps.isNotEmpty) ? deps : null,
      isFlutter: _extractFlag(filter, "isFlutter"),
      hasTests: _extractFlag(filter, "hasTests"),
      isRoot: _extractFlag(filter, "isRoot"),
    );
  }

  @override
  List<Object?> get props => [
        name,
        dependencies,
        isFlutter,
        hasTests,
        isRoot,
      ];

  @override
  bool get stringify => true;
}

T? fromResults<T>(ArgResults? results, String name) {
  final value = results?[name];
  if (value == null) return null;
  return value as T;
}

bool? _extractFlag(List<String> filter, String flag) {
  if (filter.contains(flag)) {
    return true;
  } else if (filter.contains("!$flag")) {
    return false;
  } else {
    return null;
  }
}
