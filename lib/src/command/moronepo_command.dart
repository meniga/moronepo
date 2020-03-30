import 'package:args/command_runner.dart';

abstract class MoronepoCommand<T> extends Command<T> {
  MoronepoResults get moronepoResults => MoronepoResults(
        workingDirectory: _fromGlobalResults("working-directory"),
        projectName: _fromGlobalResults("project"),
        filter: _fromGlobalResults("filter"),
        dependencies: _fromGlobalResults("dependencies"),
      );

  R _fromGlobalResults<R>(String name) => globalResults[name] as R;
}

class MoronepoResults {
  final String workingDirectory;
  final String projectName;
  final List<String> filter;
  final List<String> dependencies;

  MoronepoResults({
    this.workingDirectory,
    this.projectName,
    this.filter,
    this.dependencies,
  });

  bool get isDart => filter.contains("isDart") ? true : null;

  bool get isFlutter => filter.contains("isFlutter") ? true : null;

  bool get hasTests => filter.contains("hasTests") ? true : null;
}
