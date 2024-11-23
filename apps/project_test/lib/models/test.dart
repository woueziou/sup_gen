import 'package:freezed_annotation/freezed_annotation.dart';

part 'test.freezed.dart';
part 'test.g.dart';

@freezed
class Test with _$Test {

  factory Test() = _Test;

  factory Test.fromJson(Map<String, dynamic> json) => _$TestFromJson(json);
}