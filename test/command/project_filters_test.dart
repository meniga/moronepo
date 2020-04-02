import 'package:args/args.dart';
import 'package:moronepo/src/project_finder/project_filters.dart';
import 'package:moronepo/src/options_setter.dart';
import 'package:test/test.dart';

void main() {
  group("project_filters", () {
    Map.of({
      ["--project", "my_project"]: ProjectFilters(name: "my_project"),
      ["--filter", "isFlutter,!hasTests,!isRoot"]: ProjectFilters(
        isFlutter: true,
        hasTests: false,
        isRoot: false,
      ),
      ["--dependencies", "test,flutter"]: ProjectFilters(dependencies: ["test", "flutter"]),
    }).forEach((args, expected) {
      test("should instantiate $expected from arguments $args", () {
        // given
        final argParser = ArgParser();
        OptionsSetter().addGlobalOptions(argParser);
        final argResults = argParser.parse(args);

        // when
        final actual = ProjectFilters.from(argResults);

        // then
        expect(actual, expected);
      });
    });
  });
}
