import 'dart:io';

import 'package:path/path.dart';

final Directory testDirectory = Directory(join(
  Directory.current.path,
  Directory.current.path.endsWith("test") ? "" : "test",
));

final Directory projectDirectory = testDirectory.parent;
