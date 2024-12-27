import 'dart:developer';
import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart';
import 'package:sup_gen_model/database_option.dart';
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

  Future<void> build({Config? config, FileWriter? writer}) async {
    try {
      config ??= loadPubspecConfigOrNull(pubspecFile, buildFile: buildFile);
      if (config == null) return;
      final output = config.pubspec.supGenOption.output;
      Future<void> defaultWriter(String contents, String path) async {
        final file = File(path);
        if (!(await file.exists())) {
          await file.create(recursive: true);
        }
        await file.writeAsString(contents);
      }

      writer ??= defaultWriter;

      final absoluteOutput =
          Directory(normalize(join(pubspecFile.parent.path, output)));
      if (!(await absoluteOutput.exists())) {
        await absoluteOutput.create(recursive: true);
      }

      final dbHelper = DatabaseHelper(option: dbOption);
      // get items from server
      final enumList = await dbHelper.retrieveEnumsFromServer();
      for (var element in enumList) {
        log("$element");
        log(element.name);
      }
      final tables = await dbHelper.retrieveTableFromServer();
      final views = await dbHelper.retrieveViewsFromServer();

      tables.addAll(views);

      final enumPath =
          normalize(join(pubspecFile.parent.path, output, outputEnums));

      final enumGeneratedClass =
          generateEnums(enums: enumList, formatter: formatter);

      final tablePath = normalize(
          join(pubspecFile.parent.path, output, outputTableFilesName));

      final tableGenerated = generateTable(
        tableList: tables,
        formatter: formatter,
      );
      await Future.wait([
        writer(enumGeneratedClass, enumPath),
        writer(tableGenerated, tablePath),
      ]);

      // stdout.write("${result.length} files generated\n");
      // await writer(enumGeneratedClass, enumPath);
      // await writer(tableGenerated, tablePath);

      stdout.writeln('[PostgreGen] Finished generating.');
      // exit(0);
      return;

    } catch (e) {
      stderr.writeln('[PostgreGen] Error: $e');
      exit(1);
    }
  }
}
