import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:crypto/crypto.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart';
import 'package:sup_gen_runner/src/generators/supgen_generator.dart';
import 'package:sup_gen_runner/src/helpers/config.dart';
import 'package:sup_gen_runner/src/helpers/env.dart';

/// Entry point for the build system to create a SupgenBuilder instance.
/// This function is called by the Dart build system when code generation is triggered.
Builder build(BuilderOptions options) => SupgenBuilder(options: options);

class SupgenBuilder extends Builder {
  final BuilderOptions options;
  SupgenBuilder({required this.options});
  static AssetId _output(BuildStep buildStep, String path) {
    return AssetId(
      buildStep.inputId.package,
      path,
    );
  }

  final generator = SupgenGenerator(
      pubspecFile: File('pubspec.yaml'),
      buildFile: File('build.yaml'),
      dbOption: loadDbOptionFromEnvFile(envFile: File(".env")));
  late final _config = loadPubspecConfigOrNull(
    generator.pubspecFile,
    buildFile: generator.buildFile,
  );

  @override
  Future<void> build(BuildStep buildStep) async {
    // Step 1: Validate configuration exists
    if (_config == null) {
      return;
    }

    stdout.writeln(
        '[SUPGEN] Starting generating... ${options.config["output"]} ');

    final result = await generator.build(
      config: _config,
    );
    // final id = _output(buildStep, "supabase_models");
    for (final file in result) {
      try {
        final path = file['path'] as String;
        final contents = file['content'] as String;

        stdout.writeln('[SUPGEN] Generated: $path');
        buildStep.writeAsString(_output(buildStep, path), contents);
      } catch (e) {
        print("An error occured");
      } finally {
        stdout.writeln("Finally block executed");
      }
    }
    stdout.writeln('[SUPGEN] Generated: ${result.length} files');
    stdout.writeln('[SUPGEN] Finished generating.');
  }

  @override
  Map<String, List<String>> get buildExtensions {
    // Return empty map if no valid configuration
    if (_config == null) return {};

    // Get the configured output directory
    final output = _config.pubspec.supGenOption.output;

    // Define all output files that will be generated
    return {
      r'$package$': [
        generator.outputTableFilesName, // Database table models
        generator.outputEnums, // Enum definitions
      ].map((ou) {
        return join(output, ou);
      }).toList(),
    };
  }

  /// Creates a new builder state for change detection and optimization.
  ///
  /// This method generates a digest (hash) of the pubspec.yaml file to detect
  /// when configuration has changed. This enables the builder to skip regeneration
  /// when nothing has changed, significantly improving build performance.
  ///
  /// [config] The loaded configuration object
  /// [buildStep] The current build step context
  ///
  /// Returns a new state object containing file digests for comparison.
  Future<_SupGenGenBuilderState> _createState(
      Config config, BuildStep buildStep) async {
    // Find and read the pubspec.yaml file
    final pubspecAsset =
        await buildStep.findAssets(Glob(config.pubspecFile.path)).single;

    // Generate a digest (hash) of the pubspec file content
    final pubspecDigest = await buildStep.digest(pubspecAsset);

    // Return new state with the current file digest
    return _SupGenGenBuilderState(pubspecDigest: pubspecDigest);
  }
}

/// Internal state class that tracks file changes for build optimization.
///
/// This class stores digests (hashes) of important configuration files to detect
/// when they change. By comparing digests between builds, the system can skip
/// expensive code generation when nothing has changed, making builds much faster.
///
/// The state-based approach ensures that code is only regenerated when necessary,
/// such as when:
/// - Configuration files are modified
/// - Database schema changes
/// - Generator settings are updated
class _SupGenGenBuilderState {
  /// Creates a new builder state with the specified file digest.
  ///
  /// [pubspecDigest] A cryptographic hash of the pubspec.yaml file content
  const _SupGenGenBuilderState({
    required this.pubspecDigest,
  });

  /// Cryptographic digest (hash) of the pubspec.yaml file.
  ///
  /// This digest is used to detect when the configuration file changes.
  /// When the content changes, the digest will be different, triggering
  /// code regeneration.
  final Digest pubspecDigest;

  /// Determines whether code generation can be skipped for this build.
  ///
  /// This method implements the core optimization logic by comparing the current
  /// state with the previous build state. Code generation is skipped when:
  /// - The pubspec.yaml file hasn't changed (same digest)
  /// - No other relevant configuration has been modified
  ///
  /// [previous] The state from the previous build, or null for first build
  ///
  /// Returns true if generation can be skipped, false if regeneration is needed.
  bool shouldSkipGenerate(_SupGenGenBuilderState? previous) {
    // Always generate on first build (no previous state)
    if (previous == null) return false;

    // Skip generation if pubspec.yaml hasn't changed
    return pubspecDigest == previous.pubspecDigest;
  }
}
