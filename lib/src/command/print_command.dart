import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:monorepo/src/project_finder/project.dart';
import 'package:monorepo/src/project_finder/project_finder.dart';

class PrintCommand extends Command<Null> {
  PrintCommand() {
    argParser.addOption("working-directory", abbr: "d", help: "specifies the working directory");
  }

  String get workingDirectory => _fromArgResults("working-directory");

  T _fromArgResults<T>(String name) => argResults[name] as T;

  @override
  String get description => "Prints subprojects";

  @override
  String get name => "print";

  @override
  FutureOr<Null> run() async {
    final rootDirectory = workingDirectory ?? Directory.current.path;
    final finder = ProjectFinder();
    final projects = await finder.find(path: rootDirectory);
    final projectNames = projects.map((Project project) => project.name).toList();
    projectNames.sort();

    if (projectNames.isEmpty) {
      print("No projects found in ${rootDirectory}");
    } else {
      print(projectNames.join("\n"));
    }
  }
}
