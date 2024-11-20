import 'dart:io';

import 'package:path/path.dart';
import 'package:sup_gen_model/pubspec.dart';
import 'package:yaml/yaml.dart';

import 'utils.dart';

class Config {
  const Config._({required this.pubspec, required this.pubspecFile});

  final Pubspec pubspec;
  final File pubspecFile;
}

Config loadPubspecConfig(File pubspecFile, {File? buildFile}) {
  final pubspecLocaleHint = normalize(
    join(basename(pubspecFile.parent.path), basename(pubspecFile.path)),
  );

  // stdout.writeln('[FlutterGen] v$packageVersion Loading ...');

  // final defaultMap = loadYaml(configDefaultYamlContent) as Map?;
  final defaultMap = {};
  final pubspecContent = pubspecFile.readAsStringSync();
  final pubspecMap = loadYaml(pubspecContent) as Map?;

  var mergedMap = mergeMap([defaultMap, pubspecMap]);
  stdout.writeln(
    '[SupGen] Reading options from $pubspecLocaleHint',
  );

  if (buildFile != null) {
    if (buildFile.existsSync()) {
      final buildContent = buildFile.readAsStringSync();
      final rawMap = loadYaml(buildContent) as Map?;
      final builders = rawMap?['targets']?[r'$default']?['builders'];
      final optionBuildMap = (builders?['sup_gen_runner'] ??
          builders?['flutter_gen'])?['options'];
      if (optionBuildMap is YamlMap && optionBuildMap.isNotEmpty) {
        final buildMap = {'sup_gen': optionBuildMap};
        mergedMap = mergeMap([mergedMap, buildMap]);
        final buildLocaleHint = normalize(
          join(basename(buildFile.parent.path), basename(buildFile.path)),
        );
        stdout.writeln(
          '[SupabaseGen] Reading options from $buildLocaleHint',
        );
      } else {
        stderr.writeln(
          '[SupabaseGen] Specified ${buildFile.path} as input but the file '
          'does not contain valid options, ignoring...',
        );
      }
    } else {
      stderr.writeln(
        '[SupabaseGen] Specified ${buildFile.path} as input but the file '
        'does not exists.',
      );
    }
  }

  final pubspec = Pubspec.fromJson(mergedMap);
  return Config._(pubspec: pubspec, pubspecFile: pubspecFile);
}

Config? loadPubspecConfigOrNull(File pubspecFile, {File? buildFile}) {
  try {
    return loadPubspecConfig(pubspecFile, buildFile: buildFile);
  } on FileSystemException catch (e) {
    stderr.writeln(e.message);
  }
  return null;
}
