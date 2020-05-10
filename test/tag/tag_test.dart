import 'package:moronepo/src/tag/tag.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:test/test.dart';

void main() {
  group("tag", () {
    Map.of({
      "v1.12.13+hotfix.9": Version.parse("1.12.13+hotfix.9"),
      "1.12.13+hotfix.9": Version.parse("1.12.13+hotfix.9"),
      "this is not a proper version": Version.none,
    }).forEach((value, expected) {
      test("should return version $expected from $value tag", () {
        // given
        final actual = Tag(value);

        // expect
        expect(actual.version, expected);
      });
    });
  });
}
