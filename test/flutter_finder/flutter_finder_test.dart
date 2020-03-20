import 'package:moronepo/src/flutter_finder/flutter_finder.dart';
import 'package:test/test.dart';

import '../directories.dart';

void main() {
  test("should find flutter executable path", () {
    // given
    final expectedFlutterPath = "${testDirectory.path}/flutter_finder/test_directory_with_flutter";
    final path = "/some/directory:${expectedFlutterPath}";
    final finder = FlutterFinder(path);

    // when
    final actualFlutterPath = finder.findFlutter();

    // then
    expect(actualFlutterPath, expectedFlutterPath);
  });

  test("should throw if flutter not found in path", () {
    // given
    final path = "/some/directory";
    final finder = FlutterFinder(path);

    // expect
    expect(() => finder.findFlutter(), throwsA(TypeMatcher<FlutterNotFoundException>()));
  });
}
