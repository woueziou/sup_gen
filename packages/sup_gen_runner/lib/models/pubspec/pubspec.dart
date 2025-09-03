// @JsonSerializable()
class Pubspec {
  Pubspec({
    required this.packageName,
    required this.supGenOption,
  });

  factory Pubspec.fromJson(dynamic json) {
    return Pubspec(
      packageName: json['name'] as String,
      supGenOption: SupGen.fromJson(json['sup_gen_option']),
    );
  }

  final String packageName;
  final SupGen supGenOption;
}

// @JsonSerializable(fieldRename: FieldRename.snake)
class SupGen {
  final bool enable;
  final String schema;
  final bool? useSsl;
  final String output;

  // factory SupGen.fromJson(Map json) => _$SupGenFromJson(json);

  /// Creates a SupGen instance from a JSON map.
  ///
  /// [json] A map containing the sup_gen_option configuration data
  ///
  /// Returns a new SupGen instance with the parsed data.
  factory SupGen.fromJson(dynamic json) {
    return SupGen(
      enable: json['enable'] as bool,
      schema: json['schema'] as String,
      useSsl: json['use_ssl'] as bool?,
      output: json['output'] as String,
    );
  }

  SupGen(
      {required this.enable,
      required this.schema,
      this.useSsl,
      required this.output});
}
