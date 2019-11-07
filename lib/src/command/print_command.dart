import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:glob/glob.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

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
    final rootDirectory =
        workingDirectory == null ? Directory.current : Directory(workingDirectory);
    final projectNames = await Glob("{**/pubspec.yaml,pubspec.yaml}")
        .list(root: rootDirectory.path)
        .asyncMap((FileSystemEntity entity) => File(entity.path).readAsString())
        .map((String content) => Pubspec.parse(content).name)
        .toList();
    projectNames.sort();

    if (projectNames.isEmpty) {
      print("No projects found in ${rootDirectory.path}");
    } else {
      print(projectNames.join("\n"));
    }
  }
}
