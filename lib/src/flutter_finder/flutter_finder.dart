import 'dart:io';

import 'package:path/path.dart';
import 'package:quiver/check.dart';

class FlutterFinder {
  final String _environmentPath;

  FlutterFinder(this._environmentPath) {
    checkNotNull(_environmentPath);
  }

  String findFlutter() {
    final pathToFlutter = _environmentPath
        .split(":")
        .map((path) => File(join(path, "flutter")))
        .firstWhere((file) => file.existsSync(), orElse: () => null)
        ?.parent
        ?.path;

    if (pathToFlutter != null) {
      return pathToFlutter;
    } else {
      throw FlutterNotFoundException();
    }
  }
}

class FlutterNotFoundException implements Exception {
  @override
  String toString() => "Exception: Flutter executable not found";
}
