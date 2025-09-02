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
Builder build(BuilderOptions options) => SupgenBuilder();

/// A custom builder that handles code generation for the sup_gen package.
///
/// This builder integrates with Dart's build system to automatically generate
/// code based on project configuration. It performs the following process:
///
/// 1. **Configuration Loading**: Reads configuration from pubspec.yaml and build.yaml
/// 2. **State Management**: Tracks changes using file digests to avoid unnecessary regeneration
/// 3. **Code Generation**: Uses SupgenGenerator to create output files
/// 4. **File Writing**: Writes generated content to specified output locations
///
/// The builder only regenerates code when relevant configuration files have changed,
/// making the build process efficient by skipping unchanged dependencies.
class SupgenBuilder extends Builder {
  /// Holds the current state of the builder, including file digests
  /// for change detection and optimization.
  _SupGenGenBuilderState? state;

  /// Helper method to create an AssetId for output files.
  ///
  /// [buildStep] The current build step context
  /// [path] The relative path where the output file should be created
  ///
  /// Returns an AssetId pointing to the output location in the same package.
  static AssetId _output(BuildStep buildStep, String path) {
    return AssetId(
      buildStep.inputId.package,
      path,
    );
  }

  /// The core generator instance configured with project files and database options.
  ///
  /// This generator is initialized with:
  /// - pubspec.yaml: For project configuration
  /// - build.yaml: For build-specific settings
  /// - .env file: For database connection options
  final generator = SupgenGenerator(
      pubspecFile: File('pubspec.yaml'),
      buildFile: File('build.yaml'),
      dbOption: loadDbOptionFromEnvFile(envFile: File(".env")));

  /// Configuration loaded from pubspec.yaml and build.yaml files.
  /// This contains all the settings needed for code generation.
  late final _config = loadPubspecConfigOrNull(
    generator.pubspecFile,
    buildFile: generator.buildFile,
  );

  /// Main build method that orchestrates the code generation process.
  ///
  /// This method follows these steps:
  /// 1. **Config Validation**: Checks if valid configuration exists
  /// 2. **State Creation**: Creates a new state with file digests for change detection
  /// 3. **Skip Check**: Determines if generation can be skipped (no changes detected)
  /// 4. **Code Generation**: Calls the generator to create output files
  /// 5. **File Writing**: Writes generated content to the build system
  ///
  /// [buildStep] The current build step context provided by the build system
  @override
  Future<void> build(BuildStep buildStep) async {
    // Step 1: Validate configuration exists
    if (_config == null) {
      return;
    }

    // Step 2: Create state with current file digests
    final state = await _createState(_config, buildStep);

    // Step 3: Check if we can skip generation (optimization)
    if (state.shouldSkipGenerate(this.state)) {
      return;
    }

    // Step 4: Update state and trigger generation
    this.state = state;
    await generator.build(
      config: _config,
      writer: (contents, path) async {
        // Step 5: Write generated files to the build system
        await buildStep.writeAsString(_output(buildStep, path), contents);
        stdout.writeln('[SUPGEN] Generated: $path');
      },
    );
    stdout.writeln('[SUPGEN] Finished generating.');
  }

  /// Defines which files this builder will generate and their output locations.
  ///
  /// This getter tells the build system what output files to expect, which helps
  /// with dependency tracking and incremental builds. The generated files include:
  /// - View files: Generated database view models
  /// - Table files: Generated database table models
  /// - Enum files: Generated enum definitions
  ///
  /// Returns a map where the key is the input pattern and the value is a list
  /// of output file paths relative to the package root.
  @override
  Map<String, List<String>> get buildExtensions {
    // Return empty map if no valid configuration
    if (_config == null) return {};

    // Get the configured output directory
    final output = _config.pubspec.supGenOption.output;

    // Define all output files that will be generated
    return {
      r'$package$': [
        for (final name in [
          generator.outputViewFilesName, // Database view models
          generator.outputTableFilesName, // Database table models
          generator.outputEnums, // Enum definitions
        ])
          join(output, name), // Combine output directory with filename
      ],
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
