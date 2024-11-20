// TODO: Put public facing types in this file.

import 'package:build/build.dart';
import 'package:copy_generator/generators/multiplier_generator.dart';
import 'package:source_gen/source_gen.dart';

import '../generators/add_generator.dart';
import '../generators/copy_generator.dart';
import '../generators/top_level_generator.dart';

/// Checks if you are awesome. Spoiler: you are.
class Awesome {
  bool get isAwesome => true;
}

Builder copyBuilder(BuilderOptions options) => CopyBuilder(options: options);

Builder topLevelNamesBuilder(BuilderOptions options) => SharedPartBuilder(
      [TopLevelNamesGenerator()],
      'topLevelNames',
    );

Builder multiplierBuilder(BuilderOptions options) => SharedPartBuilder(
      [MultiplierGenerator()],
      'multiplier',
    );

Builder addBuilder(BuilderOptions options) => PartBuilder(
      [AddGenerator()],
      '.add.dart',
      options: options,
    );
