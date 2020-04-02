import 'package:args/args.dart';

class OptionsSetter {
  void addGlobalOptions(ArgParser argParser) {
    argParser.addOption("working-directory", abbr: "w", help: "specifies the working directory");
    argParser.addOption("project", abbr: "p", help: "specifies the project to run the command in");
    argParser.addMultiOption(
      "filter",
      abbr: "f",
      help: "runs the command for projects that match filter",
      allowed: [
        "hasTests",
        "!hasTests",
        "isFlutter",
        "!isFlutter",
        "isRoot",
        "!isRoot",
      ],
    );
    argParser.addMultiOption(
      "dependencies",
      abbr: "d",
      help: "runs the command for projects with specified dependencies",
    );
  }
}
