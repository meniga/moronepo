//import 'package:moronepo/src/process_starter/process_starter.dart';
//import 'package:test/test.dart';
//
//import '../directories.dart';
//
//void main() {
//  group("process starter", () {
//    ProcessStarter processStarter;
//
//    setUp(() {
//      processStarter = ProcessStarter();
//    });
//
//    test("should return output", () async {
//      expect(
//        processStarter.start("echo", ["line1\nline2"], testDirectory.path),
//        completion(equals(ProcessOutput("line1\nline2\n"))),
//      );
//    });
//
//    test("should output to stdout", () async {
//      expect(
//        () => processStarter.start("echo", ["line1\nline2"], testDirectory.path),
//        prints("line1\nline2\n"),
//      );
//    });
//  });
//}
