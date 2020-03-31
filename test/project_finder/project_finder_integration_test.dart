import 'package:moronepo/src/project_finder/project.dart';
import 'package:moronepo/src/project_finder/project_finder.dart';
import 'package:test/test.dart';

import '../directories.dart';

void main() {
  final projectFinder = ProjectFinder();
  final testProjectPath = "${projectDirectory.path}/test_resources/command/test_project";

  test("should return all projects", () async {
    // when
    final projects = await projectFinder.find(
      path: testProjectPath,
    );

    // then
    expect(projects, hasLength(8));
    expect(projects, anyElement((Project it) => it.name == "project1"));
    expect(projects, anyElement((Project it) => it.name == "project_inside_project"));
    expect(projects, anyElement((Project it) => it.name == "project_inside_directory"));
    expect(projects, anyElement((Project it) => it.name == "root"));
    expect(projects, anyElement((Project it) => it.name == "project2"));
    expect(projects, anyElement((Project it) => it.name == "project_with_tests"));
    expect(projects, anyElement((Project it) => it.name == "project_with_flutter"));
    expect(projects, anyElement((Project it) => it.name == "project_without_test_directory"));
  });

  test("should filter by name", () async {
    // when
    final projects = await projectFinder.find(
      path: testProjectPath,
      name: "project1",
    );

    // then
    expect(projects, hasLength(1));
    expect(projects, anyElement((Project it) => it.name == "project1"));
  });

  test("should filter if project contains tests", () async {
    // when
    final projects = await projectFinder.find(
      path: testProjectPath,
      hasTests: true,
    );

    // then
    expect(projects, hasLength(1));
    expect(projects, anyElement((Project it) => it.name == "project_with_tests"));
  });

  test("should mark root project as root", () async {
    // when
    final projects = await projectFinder.find(
      path: testProjectPath,
    );

    // then
    expect(projects.where((it) => it.isRoot), hasLength(1));
    expect(projects.where((it) => !it.isRoot), hasLength(7));
  });

  test("should filter pure dart projects", () async {
    // when
    final projects = await projectFinder.find(
      path: testProjectPath,
      isDart: true,
    );

    // then
    expect(projects, hasLength(7));
    expect(projects, anyElement((Project it) => it.name == "project1"));
    expect(projects, anyElement((Project it) => it.name == "project_inside_project"));
    expect(projects, anyElement((Project it) => it.name == "project_inside_directory"));
    expect(projects, anyElement((Project it) => it.name == "root"));
    expect(projects, anyElement((Project it) => it.name == "project_with_tests"));
    expect(projects, anyElement((Project it) => it.name == "project_without_test_directory"));
    expect(projects, anyElement((Project it) => it.name == "project2"));
  });

  test("should filter flutter projects", () async {
    // when
    final projects = await projectFinder.find(
      path: testProjectPath,
      isFlutter: true,
    );

    // then
    expect(projects, hasLength(1));
    expect(projects, anyElement((Project it) => it.name == "project_with_flutter"));
  });

  test("should filter projects with dependencies", () async {
    // when
    final projects = await projectFinder.find(
      path: testProjectPath,
      dependencies: ["test"],
    );

    // then
    expect(projects, hasLength(2));
    expect(projects, anyElement((Project it) => it.name == "project_with_tests"));
    expect(projects, anyElement((Project it) => it.name == "project_without_test_directory"));
  });
}
