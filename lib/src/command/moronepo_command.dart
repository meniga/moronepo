import 'package:args/command_runner.dart';
import 'package:moronepo/src/project_finder/project_filters.dart';

abstract class MoronepoCommand<T> extends Command<T> {
  MoronepoResults get moronepoResults => MoronepoResults(
        workingDirectory: _fromGlobalResults("working-directory"),
        projectFilters: ProjectFilters.from(globalResults),
      );

  R _fromGlobalResults<R>(String name) => fromResults(globalResults, name);
}

class MoronepoResults {
  final String workingDirectory;
  final ProjectFilters projectFilters;

  MoronepoResults({
    required this.workingDirectory,
    required this.projectFilters,
  });
}
