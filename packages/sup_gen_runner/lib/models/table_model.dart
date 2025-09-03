import 'dart:developer';
import 'dart:io';

import 'package:sup_gen_runner/extensions/string_extension.dart';

class TableModel {
  final String name;
  final List<TableProperty> properties;
  TableModel({required this.name, required this.properties});

  bool get hasValidName => isValidDartClassName(name);
  String get className => snakeToPascalCase(name);

  String get fromJsonFunction {
    final buffer = StringBuffer();
    buffer.writeln("factory $className.fromJson(Map<String, dynamic> json) {");
    buffer.writeln("return $className(");
    for (var element in properties) {
      if (element.type == 'json' || element.type == 'jsonb') {
        final command = '''
jsonDecode(json['${element.name}'].toString()) as Map<String, dynamic>
''';
        buffer.writeln(
            "${element.dartName}: json['${element.name}'] != null ? $command: null,");
      } else {
        buffer.writeln("${element.dartName}: json['${element.name}'],");
      }
    }
    buffer.writeln(");");
    buffer.writeln("}");
    return buffer.toString();
  }

  String createClass() {
    final buffer = StringBuffer();
    if (hasValidName) {
      buffer.writeln('class $className {');

      // Generate constructors
      buffer.writeln('  $className({');
      for (final prop in properties) {
        buffer.writeln(
            ' ${prop.isNullable ? "" : "required"}   this.${prop.dartName},');
      }
      buffer.writeln('});');

      // Genereate properties
      for (final prop in properties) {
        buffer.writeln(prop.field);
      }

      buffer.writeln(fromJsonFunction);
      buffer.writeln('}');
      buffer.writeCharCode("\n".codeUnitAt(0));
    }
    return buffer.toString();
  }
}

class TableProperty {
  final String name;
  final String type;
  final bool isNullable;
  final bool isPrimaryKey;
  final bool isAutoIncrement;

  TableProperty({
    required this.name,
    required this.type,
    required this.isNullable,
    required this.isPrimaryKey,
    required this.isAutoIncrement,
  });

  String get dartName => snakeToCamelCase(name);
  String get dartType => _dartType;
  String get _dartType {
    switch (type) {
      case "float4" || "real" || "float8" || "double precision":
        return 'double';
      case 'integer' ||
            'int4' ||
            'int' ||
            'int2' ||
            'int8' ||
            'bigint' ||
            'smallint' ||
            'serial' ||
            'bigserial':
        return 'int';

      case 'numeric':
        return 'num';
      case 'boolean' || 'bool':
        return 'bool';
      case '_numeric':
        return 'List<num>';
      case '_text':
        return 'List<String>';
      case 'text' ||
            'uuid' ||
            'character varying' ||
            'varchar' ||
            'timestamp' ||
            'timestamptz' ||
            'date':
        return 'String';
      case 'json':
        return 'Map<String, dynamic>';
      case 'jsonb':
        return 'Map<String, dynamic>';
      default:
        log(type);
        stdout.writeln('Unknown type: $type');
        return snakeToPascalCase(type);
    }
  }

  String get field {
    return "final $dartType${isNullable ? "?" : ""} $dartName;";
  }
}
