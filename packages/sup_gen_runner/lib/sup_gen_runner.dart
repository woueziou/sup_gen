import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:crypto/crypto.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart';
import 'package:sup_gen_runner/src/generators/supgen_generator.dart';
import 'package:sup_gen_runner/src/helpers/config.dart';
import 'package:sup_gen_runner/src/helpers/env.dart';

Builder build(BuilderOptions options) => SupgenBuilder();

class SupgenBuilder extends Builder {
  _SupGenGenBuilderState? _state;
  static AssetId _output(BuildStep buildStep, String path) {
    return AssetId(
      buildStep.inputId.package,
      path,
    );
  }

  late final _config = loadPubspecConfigOrNull(
    generator.pubspecFile,
    buildFile: generator.buildFile,
  );

  final generator = SupgenGenerator(
      pubspecFile: File('pubspec.yaml'),
      buildFile: File('build.yaml'),
      dbOption: loadDbOptionFromEnvFile(envFile: File(".env")));

  @override
  Future<void> build(BuildStep buildStep) async {
    if (_config == null) {
      return;
    }
    final state = await _createState(_config, buildStep);
    if (state.shouldSkipGenerate(_state)) {
      return;
    }
    _state = state;
    await generator.build(
      config: _config,
      writer: (contents, path) async {
        await buildStep.writeAsString(_output(buildStep, path), contents);
      },
    );
  }

  @override
  Map<String, List<String>> get buildExtensions {
    if (_config == null) return {};
    final ouput = _config.pubspec.supGenOption.output;
    return {
      r'$package$': [
        for (final name in [
          generator.outputViewFilesName,
          generator.outputTableFilesName,
          generator.outputEnums,
        ])
          join(ouput, name),
      ],
    };
  }

  Future<_SupGenGenBuilderState> _createState(
      Config config, BuildStep buildStep) async {
    final pubspecAsset =
        await buildStep.findAssets(Glob(config.pubspecFile.path)).single;
    final pubspecDigest = await buildStep.digest(pubspecAsset);
    if (config.pubspec.supGenOption.enable) {}
    return _SupGenGenBuilderState(pubspecDigest: pubspecDigest);
  }
}

class _SupGenGenBuilderState {
  const _SupGenGenBuilderState({
    required this.pubspecDigest,
  });

  final Digest pubspecDigest;

  bool shouldSkipGenerate(_SupGenGenBuilderState? previous) {
    if (previous == null) return false;
    return pubspecDigest == previous.pubspecDigest;
  }
}
