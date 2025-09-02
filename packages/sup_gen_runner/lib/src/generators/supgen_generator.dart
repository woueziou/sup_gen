import 'dart:io';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart';
import 'package:sup_gen_runner/models/database_option.dart';
import 'package:sup_gen_runner/src/database_helper/database_helper.dart';
import 'package:sup_gen_runner/src/generators/functions/table_generator.dart';
import 'package:sup_gen_runner/src/helpers/config.dart';
import 'package:sup_gen_runner/src/helpers/utils.dart';

import 'functions/enum_generator.dart';

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
  
  Future<void> _defaultWriter(String contents, String path) async {
    final file = File(path);
    if (!(await file.exists())) {
      await file.create(recursive: true);
    }
    await file.writeAsString(contents);
  }

  Future<void> build({Config? config, required FileWriter writer}) async {
    try {
      config ??= loadPubspecConfigOrNull(pubspecFile, buildFile: buildFile);
      if (config == null) return;
      final output = config.pubspec.supGenOption.output;

      // writer ??= _defaultWriter;

      final absoluteOutput =
          Directory(normalize(join(pubspecFile.parent.path, output)));
      if (!(await absoluteOutput.exists())) {
        await absoluteOutput.create(recursive: true);
      }

      final dbHelper = DatabaseHelper(option: dbOption);
      // Get enums definitions from the database
      final enumList = await dbHelper.retrieveEnumsFromServer();

      // Get tables and views definitions from the database
      final tablesResult = await dbHelper.retrieveTableFromServer();
      final views = await dbHelper.retrieveViewsFromServer();

      tablesResult.addAll(views);
      // final tablesAndViews

      final enumPath =
          normalize(join(pubspecFile.parent.path, output, outputEnums));

      final enumGeneratedClass =
          generateEnums(enums: enumList, formatter: formatter);

      final tablePath = normalize(
          join(pubspecFile.parent.path, output, outputTableFilesName));

      final tableGenerated = generateTable(
        tableList: tablesResult,
        formatter: formatter,
      );
      await Future.wait([
        writer(enumGeneratedClass, enumPath),
        writer(tableGenerated, tablePath),
      ]);
      stdout.writeln('[ClassGen]: Finished generating.');
      return;
    } catch (e) {
      stderr.writeln('[ClassGen]: Error: $e');
      exit(1);
    }
  }
}
