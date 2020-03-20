import 'dart:async';
import 'dart:io';

import 'package:moronepo/src/command/command_and_arguments_formatter.dart';
import 'package:moronepo/src/command/moronepo_command.dart';

import '../project_finder/project.dart';
import '../project_finder/project_finder.dart';

class RunCommand extends MoronepoCommand<Null> {
  @override
  String get description => "Runs command for all subprojects or a specified project";

  @override
  String get name => "run";

  @override
  FutureOr<Null> run() async {
    final projectName = moronepoResults.projectName;
    final isProjectSpecified = projectName?.isNotEmpty ?? false;
    final rootDirectory = moronepoResults.workingDirectory ?? Directory.current.path;
    final finder = ProjectFinder();
    Iterable<Project> projects = await finder.find(path: rootDirectory);
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
    } else {
      await Future.forEach(projects, (Project project) async {
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
}
