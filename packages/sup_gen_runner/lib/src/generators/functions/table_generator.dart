import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:sup_gen_model/table/table_model.dart';

String generateTable(
    {required List<TableModel> tableList, required DartFormatter formatter}) {
  final buffer = StringBuffer();
  buffer.writeln('// ignore_for_file: camel_case_types');
  buffer.writeln("import 'dart:convert'; \n");
  buffer.writeln("import 'supabase_enums.gen.dart'; \n");
  for (var table in tableList) {
    if (table.hasValidName) {
      buffer.writeln('${table.createClass()}\n');
      stdout.writeln('Generated Table: ${table.name}');
    } else {
      stdout.writeln(
          '[SupGen] ${table.name} cannot be generated | Check table name');
    }
  }

  return formatter.format(buffer.toString());
}

String generateEnums(
    {required List<EnumModel> enums, required DartFormatter formatter}) {
  final buffer = StringBuffer();

  buffer.writeln(
      '// ignore_for_file: camel_case_types, constant_identifier_names');

  for (var enumItem in enums) {
    buffer.writeln('enum ${enumItem.namePascalCase} {');
    for (var item in enumItem.dartValues) {
      buffer.writeln('  $item,');
    }
    buffer.writeln('}');
    buffer.writeCharCode("\n".codeUnitAt(0));
  }

  return formatter.format(buffer.toString());
}



