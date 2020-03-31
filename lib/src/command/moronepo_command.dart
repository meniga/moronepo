import 'package:args/command_runner.dart';
import 'package:args/src/arg_results.dart';

abstract class MoronepoCommand<T> extends Command<T> {
  MoronepoResults get moronepoResults => MoronepoResults(
        workingDirectory: _fromGlobalResults("working-directory"),
        projectFilters: ProjectFilters.from(globalResults),
      );

  R _fromGlobalResults<R>(String name) => _fromResults(globalResults, name);
}

class MoronepoResults {
  final String workingDirectory;
  final ProjectFilters projectFilters;

  MoronepoResults({
    this.workingDirectory,
    this.projectFilters,
  });
}

class ProjectFilters {
  final String name;
  final List<String> dependencies;
  final bool isFlutter;
  final bool hasTests;

  ProjectFilters({
    this.name,
    this.dependencies,
    this.isFlutter,
    this.hasTests,
  });

  factory ProjectFilters.from(ArgResults results) {
    List<String> filter = _fromResults(results, "filter");
    return ProjectFilters(
      name: _fromResults(results, "project"),
      dependencies: _fromResults(results, "dependencies"),
      isFlutter: _extractFlag(filter, "isFlutter"),
      hasTests: _extractFlag(filter, "hasTests"),
    );
  }
}

R _fromResults<R>(ArgResults results, String name) => results[name] as R;

bool _extractFlag(List<String> filter, String flag) {
  if (filter.contains(flag)) {
    return true;
  } else if (filter.contains("!$flag")) {
    return false;
  } else {
    return null;
  }
}
