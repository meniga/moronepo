import 'dart:io';

import 'package:path/path.dart';


class FlutterFinder {
  final String? _environmentPath;

  FlutterFinder(this._environmentPath);


  //TODO it can be optional (?) and then check null and throw exception
  String findFlutter() {
    final pathToFlutter = _environmentPath ?? ""
        .split(":")
        .map((path) => File(join(path, "flutter")))
        .firstWhere((file) => file.existsSync())
        .parent
        .path;

    if (pathToFlutter == "") {
      throw FlutterNotFoundException();
    } else {
      return pathToFlutter;
    }
  }
}

class FlutterNotFoundException implements Exception {
  @override
  String toString() => "Flutter executable not found";
}
