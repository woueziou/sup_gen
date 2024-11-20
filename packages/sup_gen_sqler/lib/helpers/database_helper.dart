import 'dart:io';

import 'package:postgres/postgres.dart';
import 'package:sup_gen_model/database_option.dart';
import 'package:sup_gen_model/table/table_model.dart';

class DatabaseHelper {
  final DatabaseOption option;

  DatabaseHelper({required this.option});

  Future<List<String>> _getTables() async {
    final conn = await _getConnection();

    final tables = await conn.execute(
      "select table_name from information_schema.tables where  table_schema='${option.schema}' and table_type='BASE TABLE';",
    );
    var result = tables.map((e) => e[0].toString()).toList();
    conn.close().then(
      (_) {
        print('Connection closed');
      },
    );
    return result;
  }

  Future<Connection> _getConnection() {
    return Connection.open(
        Endpoint(
            host: option.host,
            database: 'postgres',
            username: option.userName,
            password: option.password,
            port: option.port),
        settings: ConnectionSettings(
          sslMode: option.useSSL == true ? SslMode.require : SslMode.disable,
        ));
  }

  Future<List<String>> getViews() async {
    final conn = await _getConnection();

    final tables = await conn.execute(
      "select table_name from information_schema.tables where  table_schema='${option.schema}' and table_type='VIEW';",
    );
    var result = tables.map((e) => e[0].toString()).toList();
    conn.close().then(
      (_) {
        print('Connection closed');
      },
    );
    return result;
  }

  Future<List<TableProperty>> getTableDefinition(
      {required String table}) async {
    final conn = await _getConnection();
    final response = await conn.execute('''
SELECT
    cols.column_name,
    cols.udt_name,
    cols.is_nullable,
    -- cols.character_maximum_length,
    refs.foreign_table AS referenced_table,
    refs.foreign_column AS referenced_column
FROM
    information_schema.columns AS cols
        LEFT JOIN (
        SELECT
            con.conname AS constraint_name,
            con.conrelid::regclass AS table_name,
            con.confrelid::regclass AS foreign_table,
            a1.attname AS column_name,
            a2.attname AS foreign_column
        FROM
            pg_constraint AS con
                JOIN pg_attribute AS a1
                     ON a1.attnum = con.conkey[1] AND a1.attrelid = con.conrelid
                JOIN pg_attribute AS a2
                     ON a2.attnum = con.confkey[1] AND a2.attrelid = con.confrelid
        WHERE con.contype = 'f' -- Only foreign key constraints
    ) AS refs
                  ON
                      cols.table_name = refs.table_name::text
                          AND cols.column_name = refs.column_name
WHERE
    cols.table_schema = '${option.schema}'
  AND cols.table_name = '$table';
''');
    final listProperties = <TableProperty>[];
    for (var element in response) {
      final property = TableProperty(
        name: element[0].toString(),
        type: element[1].toString(),
        isNullable: element[2] == 'YES',
        isPrimaryKey: false,
        isAutoIncrement: false,
      );
      listProperties.add(property);
    }

    return listProperties;
  }

  Future<List<EnumModel>> retrieveEnumsFromServer() async {
    final conn = await _getConnection();
    final response = await conn.execute('''
SELECT
    t.typname AS enum_type,
    array_agg('"'||e.enumlabel||'"') AS enum_values
FROM
    pg_catalog.pg_type t
        JOIN
    pg_catalog.pg_enum e ON e.enumtypid = t.oid
        JOIN
    pg_catalog.pg_namespace n ON n.oid = t.typnamespace
WHERE
    t.typtype = 'e'  -- 'e' indicates enum types
  AND n.nspname = '${option.schema}'  -- Specify schema name here
GROUP BY
    t.typname
ORDER BY
    t.typname;
''');

    final result = response.fold(
      <EnumModel>[],
      (previousValue, element) {
        final undc = element[1] as List<String>;
        print((element[1]));
        final enumModel = EnumModel(
          name: element[0].toString(),
          values: undc,
        );
        return [...previousValue, enumModel];
      },
    );

    conn.close().then((value) {
      
    },);

    return result;
  }

  Future<List<TableModel>> retrieveTableFromServer() async {
    final tables = await _getTables();

    final List<TableModel> tableModels = [];
    for (var table in tables) {
      // TODO: Add definition to generation
      final tableDefinition = await getTableDefinition(table: table);
      // final model = TableModel(name: table, properties: []);
      final model = TableModel(name: table, properties: tableDefinition);
      tableModels.add(model);
    }
    return tableModels;
  }

  Future<void> closeConnection() async {
    final conn = await _getConnection();
    conn.close().then(
      (_) {
        print('Connection closed');
      },
    );
  }
}
