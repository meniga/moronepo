import 'dart:async';
import 'dart:io';

import 'package:moronepo/src/command/moronepo_command.dart';
import 'package:moronepo/src/project_finder/project.dart';
import 'package:moronepo/src/project_finder/project_finder.dart';

import 'command_and_arguments_formatter.dart';

class TestCommand extends MoronepoCommand<Null> {
  @override
  String get description => "Runs tests for all subprojects or a specified project";

  @override
  String get name => "test";

  @override
  FutureOr<Null> run() async {
    final projectName = moronepoResults.projectName;
    final isProjectSpecified = projectName?.isNotEmpty ?? false;
    final rootDirectory = moronepoResults.workingDirectory ?? Directory.current.path;
    final finder = ProjectFinder();
    Iterable<Project> projects = await finder.find(
      path: rootDirectory,
      name: projectName,
    );

    if (projects.isEmpty) {
      if (isProjectSpecified) {
        print("Project $projectName not found in $rootDirectory");
      } else {
        print("No projects found in $rootDirectory");
      }
    } else {
      await Future.forEach(projects, (Project project) async {
        if (!project.hasTests) {
          print("Skipping running tests for ${project.name} project");
          return;
        }
        final command = "flutter";
        final arguments = _determineTestArguments(project, argResults.rest);
        print("Running \"${formatCommand(command, arguments)}\" for ${project.name} project");
        print("Project directory \"${project.path}\"");
        await Process.start(
          command,
          arguments.toList(),
          workingDirectory: project.path,
          runInShell: true,
        ).then((process) async {
          await stdout.addStream(process.stdout);
          await stderr.addStream(process.stderr);
          return process;
        });
      });
    }
  }

  Iterable<String> _determineTestArguments(Project project, Iterable<String> arguments) {
    return (project.isFlutter ? ["test"] : ["pub", "test"]).followedBy(arguments);
  }
}
