import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:monorepo/src/project_finder/project.dart';
import 'package:monorepo/src/project_finder/project_finder.dart';

class RunCommand extends Command<Null> {
  RunCommand() {
    argParser.addOption("working-directory", abbr: "d", help: "specifies the working directory");
  }

  String get workingDirectory => _fromArgResults("working-directory");

  T _fromArgResults<T>(String name) => argResults[name] as T;

  @override
  String get description => "Run dart command for subprojects";

  @override
  String get name => "run";

  @override
  FutureOr<Null> run() async {
    final rootDirectory = workingDirectory ?? Directory.current.path;
    final finder = ProjectFinder();
    final projects = await finder.find(path: rootDirectory);
    final command = argResults.rest.join(" ");

    if (projects.isEmpty) {
      print("No projects found in ${rootDirectory}");
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
