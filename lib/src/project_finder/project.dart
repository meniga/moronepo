class Project {
  final String name;
  final String path;
  final bool isFlutter;
  final bool hasTests;

  const Project({this.name, this.path, this.isFlutter, this.hasTests});

  @override
  String toString() =>
      "(name: ${name}, path: ${path}, isFlutter: ${isFlutter} hasTests: ${hasTests})";
}
