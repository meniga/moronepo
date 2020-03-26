import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:logging/logging.dart';
import 'package:moronepo/src/command/print_command.dart';
import 'package:moronepo/src/command/run_command.dart';
import 'package:moronepo/src/command/test_command.dart';
import 'package:moronepo/src/command/update_flutter_sdk_command.dart';

class MonorepoCommandRunner extends CommandRunner<Null> {
  final Logger _logger = Logger.root;

  MonorepoCommandRunner.withDefaultCommands()
      : this([
          PrintCommand(),
          RunCommand(),
          TestCommand(),
          UpdateFlutterSdkCommand(),
        ]);

  MonorepoCommandRunner([List<Command<Null>> commands])
      : super(
          "moronepo",
          "A tool to simplify development in a dart multi-package repository.",
        ) {
    argParser.addOption("working-directory", abbr: "d", help: "specifies the working directory");
    argParser.addOption("project", abbr: "p", help: "specifies the project to run the command in");
    commands.forEach((it) => addCommand(it));
  }

  @override
  FutureOr<Null> runCommand(ArgResults topLevelResults) {
    _configureLogger();
    return super.runCommand(topLevelResults);
  }

  void _configureLogger() {
    _logger.level = Level.ALL;
    _logger.onRecord.listen((LogRecord logRecord) {
      if (logRecord.level >= Level.SEVERE) {
        stderr.writeln(logRecord);
      } else {
        stdout.writeln(logRecord);
      }
    });
  }
}
