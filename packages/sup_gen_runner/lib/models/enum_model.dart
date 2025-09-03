import 'package:sup_gen_runner/extensions/string_extension.dart';

/// Represents a PostgreSQL enum type for code generation.
///
/// This class models a database enum and provides utilities for generating
/// the corresponding Dart enum code. It handles name transformations and
/// value mappings required for proper Dart enum generation.
///
/// ## Example
///
/// For a PostgreSQL enum like:
/// ```sql
/// CREATE TYPE user_status AS ENUM ('active', 'inactive', 'pending');
/// ```
///
/// An [EnumModel] would be created with:
/// ```dart
/// final enumModel = EnumModel(
///   name: 'user_status',
///   values: ['active', 'inactive', 'pending'],
/// );
/// ```
///
/// This generates Dart code like:
/// ```dart
/// enum UserStatus {
///   active,
///   inactive,
///   pending;
///
///   String get name {
///     switch (this) {
///       case UserStatus.active: return 'active';
///       case UserStatus.inactive: return 'inactive';
///       case UserStatus.pending: return 'pending';
///     }
///   }
/// }
/// ```
class EnumModel {
  /// The original database enum name (e.g., 'user_status').
  final String name;

  /// The list of enum values from the database.
  final List<String> values;

  /// Creates a new [EnumModel] instance.
  ///
  /// [name] The database enum type name
  /// [values] The list of possible enum values
  EnumModel({required this.name, required this.values});

  /// The generated Dart enum name in PascalCase.
  ///
  /// Converts snake_case database names to PascalCase Dart enum names.
  /// For example: 'user_status' becomes 'UserStatus'.
  String get enumName {
    final pascalCase =
        snakeToPascalCase(name.replaceAll('"', '').replaceAll(" ", "_"));
    return pascalCase[0].toUpperCase() + pascalCase.substring(1);
  }

  /// Maps Dart enum property names to their corresponding database string values.
  ///
  /// This creates a mapping where keys are valid Dart identifiers and values
  /// are the original database enum strings. This is used for generating the
  /// `.name` getter that returns the database string value.
  ///
  /// Example:
  /// ```dart
  /// {'active': 'active', 'pending': 'pending'}
  /// ```
  Map<String, String> get mappedData {
    final result = <String, String>{};
    for (var element in values) {
      final data = _formatEnumProperty(element);
      result[data] = element;
    }

    return result;
  }

  /// Converts a database enum value to a valid Dart identifier.
  ///
  /// Handles sanitization and case conversion:
  /// - Removes quotes and spaces
  /// - Replaces hyphens with underscores
  /// - Converts to camelCase
  ///
  /// [value] The raw database enum value
  /// Returns a valid Dart identifier for the enum property
  String _formatEnumProperty(String value) {
    String sanitizedValue =
        value.replaceAll('"', '').replaceAll(" ", "_").replaceAll("-", "_");
    final result = snakeToPascalCase(sanitizedValue);
    return result;
  }
}
