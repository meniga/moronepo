import 'dart:io';

import 'package:path/path.dart';


class FlutterFinder {
  final String? _environmentPath;

  FlutterFinder(this._environmentPath);


  String findFlutter() {
    for (final dir in (_environmentPath ?? "").split(":")) {
      final file = File(join(dir, "flutter"));
      if (file.existsSync()) return file.parent.path;
    }
    throw FlutterNotFoundException();
  }
}

class FlutterNotFoundException implements Exception {
  @override
  String toString() => "Flutter executable not found";
}
