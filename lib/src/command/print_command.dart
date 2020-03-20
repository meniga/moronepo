import 'dart:async';
import 'dart:io';

import 'package:moronepo/src/command/moronepo_command.dart';
import 'package:moronepo/src/project_finder/project.dart';
import 'package:moronepo/src/project_finder/project_finder.dart';

class PrintCommand extends MoronepoCommand<Null> {
  @override
  String get description => "Prints subprojects";

  @override
  String get name => "print";

  @override
  FutureOr<Null> run() async {
    final rootDirectory = moronepoResults.workingDirectory ?? Directory.current.path;
    final finder = ProjectFinder();
    final projects = await finder.find(path: rootDirectory);
    final projectNames = projects.map((Project project) => project.name).toList();
    projectNames.sort();

    if (projectNames.isEmpty) {
      print("No projects found in $rootDirectory");
    } else {
      print(projectNames.join("\n"));
    }
  }
}
