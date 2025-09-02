import 'package:json_annotation/json_annotation.dart';
import 'package:sup_gen_model/extensions/string_extension.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class EnumModel {
  final String name;
  final List<String> values;
  EnumModel({required this.name, required this.values});

  String get enumName {
    final pascalCase =
        snakeToPascalCase(name.replaceAll('"', '').replaceAll(" ", "_"));
    return pascalCase[0].toUpperCase() + pascalCase.substring(1);
  }

  Map<String, String> get mappedData {
    final result = <String, String>{};
    for (var element in values) {
      final data = _formatEnumProperty(element);
      result[data]=element;
    }

    return result;
  }

  String _formatEnumProperty(String value) {
    String sanitizedValue =
        value.replaceAll('"', '').replaceAll(" ", "_").replaceAll("-", "_");
    final result = snakeToPascalCase(sanitizedValue);
    return result;
  }
}
