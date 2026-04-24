import 'package:moronepo/src/project_finder/project_filters.dart';
import 'package:moronepo/src/project_finder/project.dart';
import 'package:moronepo/src/project_finder/project_finder.dart';
import 'package:test/test.dart';

import '../directories.dart';
import '../matchers.dart';

void main() {
  final projectFinder = ProjectFinder();
  final testProjectPath = "${projectDirectory.path}/test_resources/command/test_project";

  group("find", () {
    test("should return all projects", () async {
      final projects = await projectFinder.find(
        path: testProjectPath,
      );

      expectProjectsWithNames(projects, [
        "project1",
        "project_inside_project",
        "project_inside_directory",
        "root",
        "project2",
        "project_with_tests",
        "project_with_flutter",
        "project_without_test_directory"
      ]);
    });

    test("should filter by name", () async {
      final projects = await projectFinder.find(
        path: testProjectPath,
        filters: ProjectFilters(name: "project1"),
      );

      expectProjectsWithNames(projects, ["project1"]);
    });

    test("should filter if project contains tests", () async {
      final projects = await projectFinder.find(
        path: testProjectPath,
        filters: ProjectFilters(hasTests: true),
      );

      expectProjectsWithNames(projects, ["project_with_tests"]);
    });

    test("should filter root project as root", () async {
      final projects = await projectFinder.find(
        path: testProjectPath,
        filters: ProjectFilters(isRoot: true),
      );

      expect(projects, hasExactlyOne(predicate((Project it) => it.isRoot)));
    });

    test("should filter pure dart projects", () async {
      final projects = await projectFinder.find(
        path: testProjectPath,
        filters: ProjectFilters(isFlutter: false),
      );

      expectProjectsWithNames(projects, [
        "project1",
        "project_inside_project",
        "project_inside_directory",
        "root",
        "project_with_tests",
        "project_without_test_directory",
        "project2"
      ]);
    });

    test("should filter flutter projects", () async {
      final projects = await projectFinder.find(
        path: testProjectPath,
        filters: ProjectFilters(isFlutter: true),
      );

      expectProjectsWithNames(projects, ["project_with_flutter"]);
    });

    test("should filter projects with dependencies", () async {
      final projects = await projectFinder.find(
        path: testProjectPath,
        filters: ProjectFilters(dependencies: ["test"]),
      );

      expectProjectsWithNames(projects, [
        "project_with_tests",
        "project_without_test_directory",
      ]);
    });
  });
}

void expectProjectsWithNames(Iterable<Project> projects, Iterable<String> expectedNames) {
  expect(projects, hasLength(expectedNames.length));
  expect(projects, everyElement(predicate((Project it) => expectedNames.contains(it.name))));
}
