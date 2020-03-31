import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:logging/logging.dart';
import 'package:moronepo/src/options_setter.dart';
import 'package:moronepo/src/command/print_command.dart';
import 'package:moronepo/src/command/run_command.dart';
import 'package:moronepo/src/command/update_flutter_sdk_command.dart';

class MoronepoCommandRunner extends CommandRunner<Null> {
  final Logger _logger = Logger.root;

  MoronepoCommandRunner.withDefaultCommands()
      : this([
          PrintCommand(),
          RunCommand(),
          UpdateFlutterSdkCommand(),
        ]);

  MoronepoCommandRunner([List<Command<Null>> commands])
      : super(
          "moronepo",
          "A tool to simplify development in a dart multi-package repository.",
        ) {
    OptionsSetter().addGlobalOptions(argParser);
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
