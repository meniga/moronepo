import 'dart:async';
import 'dart:io';

import 'package:moronepo/src/command/command_and_arguments_formatter.dart';
import 'package:moronepo/src/command/moronepo_command.dart';
import 'package:moronepo/src/command/project_filters.dart';

import '../project_finder/project.dart';
import '../project_finder/project_finder.dart';

class RunCommand extends MoronepoCommand<Null> {
  @override
  String get description => "Runs command for all subprojects or a specified project";

  @override
  String get name => "run";

  @override
  FutureOr<Null> run() async {
    final projectFilters = moronepoResults.projectFilters;
    final projectName = projectFilters.name;
    final isProjectSpecified = projectName?.isNotEmpty ?? false;
    final rootDirectory = moronepoResults.workingDirectory ?? Directory.current.path;
    Iterable<Project> projects = await _findProjects(rootDirectory, projectFilters);
    if (isProjectSpecified) {
      projects = projects.where((project) => project.name == projectName);
    }
    final command = argResults.rest[0];
    final arguments = argResults.rest.skip(1);

    if (projects.isEmpty) {
      if (isProjectSpecified) {
        print("Project $projectName not found in $rootDirectory");
      } else {
        print("No projects found in $rootDirectory");
      }
      return;
    }

    try {
      await Future.forEach(projects, (Project project) async {
        print("Running \"${formatCommand(command, arguments)}\" for ${project.name} project");
        print("Project directory \"${project.path}\"");
        final code = await Process.start(
          command,
          arguments.toList(),
          workingDirectory: project.path,
          runInShell: true,
        ).then((process) async {
          await stdout.addStream(process.stdout);
          await stderr.addStream(process.stderr);
          return process;
        }).then((process) => process.exitCode);

        if (code != 0) {
          throw CommandException(code);
        }
      });
    } on CommandException catch (exception) {
      exitCode = exception.exitCode;
    }
  }

  Future<List<Project>> _findProjects(String rootDirectory, ProjectFilters filters) async {
    return ProjectFinder().find(
      path: rootDirectory,
      dependencies: filters.dependencies,
      hasTests: filters.hasTests,
      isFlutter: filters.isFlutter,
      name: filters.name,
    );
  }
}

class CommandException {
  final int exitCode;

  CommandException(this.exitCode);

  @override
  String toString() => "Command exitted with code $exitCode";
}
