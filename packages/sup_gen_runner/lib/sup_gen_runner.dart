/// SupGen - Supabase/PostgreSQL Dart Class Generator
///
/// This library provides a build_runner-based code generator that automatically
/// creates Dart classes from PostgreSQL/Supabase database schemas.
///
/// ## Features
///
/// - **Database Table Models**: Generates Dart classes with proper type mappings
/// - **Enum Support**: Creates Dart enums from PostgreSQL enum types
/// - **View Support**: Generates classes for database views
/// - **Null Safety**: Full null-safety support with proper nullable types
/// - **JSON Serialization**: Includes `fromJson()` factories for easy deserialization
/// - **SSL Support**: Configurable SSL connections for secure database access
///
/// ## Usage
///
/// 1. Add SupGen to your `pubspec.yaml`:
/// ```yaml
/// dev_dependencies:
///   sup_gen_runner: ^1.0.0
///   build_runner: ^2.3.0
/// ```
///
/// 2. Configure your database connection in `.env`:
/// ```
/// SUPABASE_DB_USER=postgres
/// SUPABASE_DB_HOST=localhost
/// SUPABASE_DB_PORT=5432
/// SUPABASE_DB_PASSWORD=password
/// SUPABASE_DB=database_name
/// SUPABASE_DB_SCHEMA=public
/// ```
///
/// 3. Configure generation options in `pubspec.yaml`:
/// ```yaml
/// sup_gen_option:
///   output: lib/supabase_models
///   enable: true
///   schema: 'public'
///   useSsl: false
/// ```
///
/// 4. Run code generation:
/// ```bash
/// dart run build_runner build --delete-conflicting-outputs
/// ```
///
/// ## Generated Files
///
/// - `supabase_tables.gen.dart` - Database table models
/// - `supabase_enums.gen.dart` - Database enum definitions
/// - `supabase_view.gen.dart` - Database view models
///
/// ## Database Support
///
/// Currently supports PostgreSQL databases including:
/// - Supabase hosted PostgreSQL
/// - Self-hosted PostgreSQL instances
/// - Local PostgreSQL development databases
library sup_gen_runner;

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

/// A code generator builder that creates Dart classes from PostgreSQL/Supabase database schemas.
///
/// This builder integrates with the Dart build system to automatically generate:
/// - Database table models as Dart classes
/// - Database enums as Dart enums
/// - Database views as Dart classes
///
/// The builder reads database configuration from `.env` files and pubspec.yaml
/// configuration to connect to PostgreSQL/Supabase databases and generate
/// corresponding Dart code.
///
/// ## Usage
///
/// Configure your `pubspec.yaml`:
/// ```yaml
/// sup_gen_option:
///   output: lib/supabase_models
///   enable: true
///   schema: 'public'
///   useSsl: false
/// ```
///
/// And your `.env` file:
/// ```
/// SUPABASE_DB_USER=postgres
/// SUPABASE_DB_HOST=localhost
/// SUPABASE_DB_PORT=5432
/// SUPABASE_DB_PASSWORD=password
/// SUPABASE_DB=database_name
/// SUPABASE_DB_SCHEMA=public
/// ```
class SupgenBuilder extends Builder {
  /// Build options passed from the build system.
  final BuilderOptions options;

  /// Creates a new [SupgenBuilder] instance.
  ///
  /// [options] Configuration options from the build system containing
  /// user-defined settings and build context information.
  SupgenBuilder({required this.options});

  /// Creates an [AssetId] for the output file at the given [path].
  ///
  /// [buildStep] The current build step containing package information.
  /// [path] The relative path for the generated file.
  ///
  /// Returns an [AssetId] pointing to the output file location.
  static AssetId _output(BuildStep buildStep, String path) {
    return AssetId(
      buildStep.inputId.package,
      path,
    );
  }

  /// The core generator that handles database introspection and code generation.
  ///
  /// Configured with:
  /// - `pubspec.yaml` for build configuration
  /// - `build.yaml` for builder-specific settings
  /// - `.env` file for database connection parameters
  final generator = SupgenGenerator(
      pubspecFile: File('pubspec.yaml'),
      buildFile: File('build.yaml'),
      dbOption: loadDbOptionFromEnvFile(envFile: File(".env")));

  /// Configuration loaded from pubspec.yaml and build.yaml files.
  ///
  /// Contains user-specified options like output directory, schema name,
  /// SSL settings, and other generation preferences. Will be null if
  /// configuration is invalid or missing.
  late final _config = loadPubspecConfigOrNull(
    generator.pubspecFile,
    buildFile: generator.buildFile,
  );

  /// Executes the code generation process.
  ///
  /// This method is called by the Dart build system when code generation is needed.
  /// It performs the following steps:
  ///
  /// 1. Validates that configuration exists and is valid
  /// 2. Connects to the configured database
  /// 3. Introspects database schema (tables, enums, views)
  /// 4. Generates corresponding Dart code files
  /// 5. Writes the generated files to the specified output directory
  ///
  /// The method generates multiple files:
  /// - `supabase_tables.gen.dart` - Database table models
  /// - `supabase_enums.gen.dart` - Database enum definitions
  /// - `supabase_view.gen.dart` - Database view models
  ///
  /// [buildStep] The build context provided by the build system, containing
  /// input information and methods to write output files.
  ///
  /// Returns a [Future] that completes when code generation is finished.
  /// Will return early if configuration is invalid.
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

  /// Defines the mapping of input files to output files for the build system.
  ///
  /// This getter tells the Dart build system which files will be generated
  /// and where they will be placed. The build system uses this information
  /// for dependency tracking and incremental builds.
  ///
  /// The mapping uses `r'$package$'` as a special key that means "this applies
  /// to the root package". The values are the relative paths of files that
  /// will be generated in the configured output directory.
  ///
  /// Generated files include:
  /// - Database table models (`supabase_tables.gen.dart`)
  /// - Database enum definitions (`supabase_enums.gen.dart`)
  /// - Database view models (`supabase_view.gen.dart`)
  ///
  /// Returns an empty map if configuration is invalid, which effectively
  /// disables the builder.
  ///
  /// Returns a [Map] where keys are input file patterns and values are
  /// lists of output file paths that will be generated.
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
