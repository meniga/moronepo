import 'package:args/args.dart';
import 'package:moronepo/src/options_setter.dart';
import 'package:test/test.dart';

void main() {
  group("options_setter", () {
    test("should add a predefined set of global options", () {
      // given
      final optionsSetter = OptionsSetter();
      final argParser = ArgParser();

      // when
      optionsSetter.addGlobalOptions(argParser);

      // then
      expect(
          argParser.options.keys,
          unorderedEquals([
            "working-directory",
            "project",
            "filter",
            "dependencies",
          ]));
    });
  });
}
