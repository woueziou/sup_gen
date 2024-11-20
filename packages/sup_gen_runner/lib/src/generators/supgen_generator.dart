import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart';
import 'package:sup_gen_model/database_option.dart';
import 'package:sup_gen_runner/src/generators/functions/table_generator.dart';
import 'package:sup_gen_runner/src/helpers/config.dart';
import 'package:sup_gen_runner/src/helpers/utils.dart';
import 'package:sup_gen_sqler/helpers/database_helper.dart';

class SupgenGenerator {
  final File pubspecFile;
  final File? buildFile;
  final DatabaseOption dbOption;
  final String outputTableFilesName = "supabase_table.gen.dart";
  final String outputViewFilesName = "supabase_view.gen.dart";
  final String outputEnums = "supabase_enums.gen.dart";
  final formatter = DartFormatter(pageWidth: 80, lineEnding: '\n');

  SupgenGenerator(
      {required this.pubspecFile, this.buildFile, required this.dbOption});

  Future<void> build({Config? config, FileWriter? writer}) async {
    config ??= loadPubspecConfigOrNull(pubspecFile, buildFile: buildFile);
    if (config == null) return;
    final output = config.pubspec.supGenOption.output;
    void defaultWriter(String contents, String path) {
      final file = File(path);
      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }
      file.writeAsStringSync(contents);
    }

    writer ??= defaultWriter;

    final absoluteOutput =
        Directory(normalize(join(pubspecFile.parent.path, output)));
    if (!absoluteOutput.existsSync()) {
      absoluteOutput.createSync(recursive: true);
    }

    final dbHelper = DatabaseHelper(option: dbOption);
    // get items from server
    final enumList = await dbHelper.retrieveEnumsFromServer();
    final tables = await dbHelper.retrieveTableFromServer();

    final enumPath =
        normalize(join(pubspecFile.parent.path, output, outputEnums));

    final enumGeneratedClass =
        generateEnums(enums: enumList, formatter: formatter);
    writer(enumGeneratedClass, enumPath);

    final tablePath =
        normalize(join(pubspecFile.parent.path, output, outputTableFilesName));
    final generated = generateTable(tableList: tables, formatter: formatter);

    writer(generated, tablePath);

    stdout.writeln('[PostgreGen] Finished generating.');
    return;
  }
}
