import 'package:dart_style/dart_style.dart';
import 'package:sup_gen_runner/models/enum_model.dart';

String generateEnums(
    {required List<EnumModel> enums, required DartFormatter formatter}) {
  final buffer = StringBuffer();

  buffer.writeln(
      '// ignore_for_file: camel_case_types, constant_identifier_names');

  for (var enumItem in enums) {
    buffer.writeln('enum ${enumItem.enumName} {');
    final list = enumItem.mappedData.keys.toList();
    for (var i = 0; i < list.length; i++) {
      final item = list[i];
      buffer.write(item);
      if (i != list.length - 1) {
        buffer.write(',');
      } else {
        buffer.write(';');
      }
      // buffer.writeCharCode("\n".codeUnitAt(0));
    }

    // for (var item in enumItem.mappedData.keys) {
    //   buffer.writeln('  $item');
    // }
    // buffer.writeln('@override');
    buffer.writeln('String get name {');
    buffer.writeln('switch (this) {');
    for (var item in enumItem.mappedData.entries) {
      buffer.writeln('case ${enumItem.enumName}.${item.key}:');
      buffer.writeln('return ${item.value};');
    }
    buffer.writeln('default:');
    buffer.writeln('return "${enumItem.enumName}";');
    buffer.writeln('}');
    buffer.writeln('}');
//  @override
//   String get name {
//     switch (this) {
//       case MyEnum.optionOne:
//         return 'Option One';
//       case MyEnum.optionTwo:
//         return 'Option Two';
//       case MyEnum.optionThree:
//         return 'Option Three';
//       default:
//         return super.name;
//     }
//   }

    buffer.writeln('}');
    buffer.writeCharCode("\n".codeUnitAt(0));
  }

  return formatter.format(buffer.toString());
}
