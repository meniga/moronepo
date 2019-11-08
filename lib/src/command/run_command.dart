import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:monorepo/src/project_finder/project.dart';
import 'package:monorepo/src/project_finder/project_finder.dart';

class RunCommand extends Command<Null> {
  RunCommand() {
    argParser.addOption("working-directory", abbr: "d", help: "specifies the working directory");
    argParser.addOption("project", abbr: "p", help: "specifies the project to run the command in");
  }

  String get workingDirectory => _fromArgResults("working-directory");

  String get projectName => _fromArgResults("project");

  T _fromArgResults<T>(String name) => argResults[name] as T;

  @override
  String get description => "Runs command for all subprojects or specified project";

  @override
  String get name => "run";

  @override
  FutureOr<Null> run() async {
    final isProjectSpecified = projectName?.isNotEmpty ?? false;
    final rootDirectory = workingDirectory ?? Directory.current.path;
    final finder = ProjectFinder();
    Iterable<Project> projects = await finder.find(path: rootDirectory);
    if (isProjectSpecified) {
      projects = projects.where((project) => project.name == projectName);
    }
    final command = argResults.rest.join(" ");

    if (projects.isEmpty) {
      if (isProjectSpecified) {
        print("Project $projectName not found in $rootDirectory");
      } else {
        print("No projects found in $rootDirectory");
      }
    } else {
      await Future.forEach(projects, (Project project) async {
        print("Running \"$command\" for ${project.name} project");
        print("Project directory \"${project.path}\"");
        await Process.start(
          command,
          [],
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
