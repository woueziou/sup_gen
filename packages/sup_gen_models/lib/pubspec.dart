import 'package:json_annotation/json_annotation.dart';
part 'pubspec.g.dart';

@JsonSerializable()
class Pubspec {
  Pubspec({
    required this.packageName,
    required this.supGenOption,
  });

  factory Pubspec.fromJson(Map json) => _$PubspecFromJson(json);

  @JsonKey(name: 'name', required: true)
  final String packageName;

  @JsonKey(name: 'sup_gen_option', required: true)
  final SupGen supGenOption;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SupGen {
  final bool enable;
  final String schema;
  final bool? useSsl;
  final String output;

  factory SupGen.fromJson(Map json) => _$SupGenFromJson(json);

  SupGen(
      {required this.enable,
      required this.schema,
      this.useSsl,
      required this.output});
}
