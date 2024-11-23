

import 'package:sup_gen_model/table/table_model.dart';

void main() {
  final table = TableModel(name: "Test", properties: [
    TableProperty(
      name: "id",
      type: "int",
      isNullable: false,
      isPrimaryKey: true,
      isAutoIncrement: true,
    ),
    TableProperty(
      name: "name",
      type: "String",
      isNullable: false,
      isPrimaryKey: false,
      isAutoIncrement: false,
    ),
  ]);

  print(table.createClass());
}
