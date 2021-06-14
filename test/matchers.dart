//import 'package:matcher/matcher.dart';
//import 'package:test/test.dart';
//
//Matcher hasExactlyOne(dynamic matcher) => _HasExactlyOneMatcher(wrapMatcher(matcher));
//
//class _HasExactlyOneMatcher extends TypeMatcher<Iterable> {
//  final Matcher _matcher;
//
//  _HasExactlyOneMatcher(this._matcher);
//
//  @override
//  Description describe(Description description) =>
//      description.add("exactly one element ").addDescriptionOf(_matcher);
//
//  @override
//  bool matches(Object item, Map matchState) =>
//      super.matches(item, matchState) && _typedMatches(item as Iterable, matchState);
//
//  bool _typedMatches(Iterable item, Map matchState) {
//    return item.where((it) => _matcher.matches(it, matchState)).length == 1;
//  }
//
//  @override
//  Description describeMismatch(
//      item, Description mismatchDescription, Map matchState, bool verbose) {
//    if (item is Iterable) {
//      return _describeTypedMismatch(item, mismatchDescription, matchState, verbose);
//    }
//
//    return super.describe(mismatchDescription.add("not an "));
//  }
//
//  Description _describeTypedMismatch(
//          Iterable item, Description mismatchDescription, Map matchState, bool verbose) =>
//      mismatchDescription;
//}
