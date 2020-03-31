import 'package:args/args.dart';
import 'package:equatable/equatable.dart';

class ProjectFilters extends Equatable {
  final String name;
  final List<String> dependencies;
  final bool isFlutter;
  final bool hasTests;

  ProjectFilters({
    this.name,
    List<String> dependencies,
    this.isFlutter,
    this.hasTests,
  }) : this.dependencies = dependencies ?? [];

  factory ProjectFilters.from(ArgResults results) {
    List<String> filter = fromResults(results, "filter");
    return ProjectFilters(
      name: fromResults(results, "project"),
      dependencies: fromResults(results, "dependencies"),
      isFlutter: _extractFlag(filter, "isFlutter"),
      hasTests: _extractFlag(filter, "hasTests"),
    );
  }

  @override
  List<Object> get props => [
        name,
        dependencies,
        isFlutter,
        hasTests,
      ];

  @override
  bool get stringify => true;
}

R fromResults<R>(ArgResults results, String name) => results[name] as R;

bool _extractFlag(List<String> filter, String flag) {
  if (filter.contains(flag)) {
    return true;
  } else if (filter.contains("!$flag")) {
    return false;
  } else {
    return null;
  }
}
