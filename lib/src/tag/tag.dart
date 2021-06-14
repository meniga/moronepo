import 'package:equatable/equatable.dart';
import 'package:pub_semver/pub_semver.dart';

class Tag extends Equatable {
  final String value;

  Tag({required this.value});

  @override
  List<Object> get props => [value];

  @override
  bool get stringify => true;

  Version get version {
    try {
      if (value.startsWith("v")) {
        return Version.parse(value.substring(1));
      } else {
        return Version.parse(value);
      }
    } catch (_) {
      return Version.none;
    }
  }
}
