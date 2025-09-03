import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
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
 
}
