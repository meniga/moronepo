import 'package:args/command_runner.dart';

abstract class MoronepoCommand<T> extends Command<T> {
  MoronepoResults get moronepoResults => MoronepoResults(
        workingDirectory: _fromGlobalResults("working-directory"),
        projectName: _fromGlobalResults("project"),
      );

  T _fromGlobalResults<T>(String name) => globalResults[name] as T;
}

class MoronepoResults {
  final String workingDirectory;
  final String projectName;

  MoronepoResults({
    this.workingDirectory,
    this.projectName,
  });
}
