import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';

class ProcessStarter {
  Future<ProcessOutput> start(
    String command,
    List<String> arguments,
    String workingDirectory,
  ) {
    return Process.start(
      command,
      arguments,
      workingDirectory: workingDirectory,
      runInShell: true,
    ).then((process) async {
      final stringOutput = await process.stdout.transform(utf8.decoder).join();
      _printRemovingTrailingNewLine(stringOutput);
      await stderr.addStream(process.stderr);
      return ProcessOutput(output: stringOutput);
    });
  }

  void _printRemovingTrailingNewLine(String string) {
    if (string.isNotEmpty) {
      print(string.substring(0, string.length - 1));
    }
  }
}

class ProcessOutput extends Equatable {
  final String output;

  ProcessOutput({required this.output});

  @override
  List<Object> get props => [output];

  @override
  bool get stringify => true;
}
