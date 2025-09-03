import 'dart:developer';
import 'dart:io';

import 'package:sup_gen_runner/extensions/string_extension.dart';

/// Represents a database table for Dart code generation.
///
/// This class models a PostgreSQL table and provides utilities for generating
/// the corresponding Dart class code. It handles table structure analysis,
/// property mapping, and code generation for database-to-Dart object conversion.
///
/// ## Example
///
/// For a PostgreSQL table like:
/// ```sql
/// CREATE TABLE users (
///   id SERIAL PRIMARY KEY,
///   name VARCHAR(100) NOT NULL,
///   email VARCHAR(255),
///   created_at TIMESTAMP DEFAULT NOW()
/// );
/// ```
///
/// A [TableModel] would generate Dart code like:
/// ```dart
/// class User {
///   User({
///     required this.id,
///     required this.name,
///     this.email,
///     this.createdAt,
///   });
///
///   final int id;
///   final String name;
///   final String? email;
///   final String? createdAt;
///
///   factory User.fromJson(Map<String, dynamic> json) {
///     return User(
///       id: json['id'],
///       name: json['name'],
///       email: json['email'],
///       createdAt: json['created_at'],
///     );
///   }
/// }
/// ```
class TableModel {
  /// The original database table name (e.g., 'user_profiles').
  final String name;

  /// The list of table columns/properties.
  final List<TableProperty> properties;

  /// Creates a new [TableModel] instance.
  ///
  /// [name] The database table name
  /// [properties] The list of table columns with their metadata
  TableModel({required this.name, required this.properties});

  /// Whether the table name can be converted to a valid Dart class name.
  ///
  /// Returns `true` if the table name follows valid Dart identifier rules
  /// after snake_case to PascalCase conversion.
  bool get hasValidName => isValidDartClassName(name);

  /// The generated Dart class name in PascalCase.
  ///
  /// Converts snake_case table names to PascalCase class names.
  /// For example: 'user_profiles' becomes 'UserProfile'.
  String get className => snakeToPascalCase(name);

  /// Generates the `fromJson` factory constructor code.
  ///
  /// Creates a factory constructor that can deserialize JSON data into
  /// the Dart class instance. Handles special cases like JSON/JSONB columns
  /// which require `jsonDecode` parsing.
  ///
  /// Returns the complete factory constructor code as a string.
  String get fromJsonFunction {
    final buffer = StringBuffer();
    buffer.writeln("factory $className.fromJson(Map<String, dynamic> json) {");
    buffer.writeln("return $className(");
    for (var element in properties) {
      if (element.type == 'json' || element.type == 'jsonb') {
        final command = '''
jsonDecode(json['${element.name}'].toString()) as Map<String, dynamic>
''';
        buffer.writeln(
            "${element.dartName}: json['${element.name}'] != null ? $command: null,");
      } else {
        buffer.writeln("${element.dartName}: json['${element.name}'],");
      }
    }
    buffer.writeln(");");
    buffer.writeln("}");
    return buffer.toString();
  }

  /// Generates the complete Dart class code.
  ///
  /// Creates a full Dart class with:
  /// - Constructor with required/optional parameters
  /// - Property declarations with proper types and nullability
  /// - `fromJson` factory constructor for JSON deserialization
  ///
  /// Returns the complete class code as a string, or empty string if the
  /// table name is invalid for Dart class generation.
  String createClass() {
    final buffer = StringBuffer();
    if (hasValidName) {
      buffer.writeln('class $className {');

      // Generate constructors
      buffer.writeln('  $className({');
      for (final prop in properties) {
        buffer.writeln(
            ' ${prop.isNullable ? "" : "required"}   this.${prop.dartName},');
      }
      buffer.writeln('});');

      // Genereate properties
      for (final prop in properties) {
        buffer.writeln(prop.field);
      }

      buffer.writeln(fromJsonFunction);
      buffer.writeln('}');
      buffer.writeCharCode("\n".codeUnitAt(0));
    }
    return buffer.toString();
  }
}

/// Represents a database table column/property for code generation.
///
/// This class models a PostgreSQL table column and provides utilities for
/// mapping database types to Dart types, handling nullability, and generating
/// appropriate Dart field declarations.
///
/// ## Type Mapping
///
/// The following PostgreSQL types are supported:
/// - **Numeric**: `int4`, `int8`, `serial`, `bigserial` → `int`
/// - **Floating**: `float4`, `float8`, `double precision` → `double`
/// - **Text**: `text`, `varchar`, `uuid`, `timestamp` → `String`
/// - **Boolean**: `boolean`, `bool` → `bool`
/// - **JSON**: `json`, `jsonb` → `Map<String, dynamic>`
/// - **Arrays**: `_text` → `List<String>`, `_numeric` → `List<num>`
///
/// ## Example
///
/// For a PostgreSQL column:
/// ```sql
/// email VARCHAR(255) NULL
/// ```
///
/// A [TableProperty] would be:
/// ```dart
/// TableProperty(
///   name: 'email',
///   type: 'character varying',
///   isNullable: true,
///   isPrimaryKey: false,
///   isAutoIncrement: false,
/// )
/// ```
///
/// Which generates the Dart field:
/// ```dart
/// final String? email;
/// ```
class TableProperty {
  /// The original database column name (e.g., 'created_at').
  final String name;

  /// The PostgreSQL data type of the column (e.g., 'varchar', 'int4').
  final String type;

  /// Whether the column allows NULL values.
  final bool isNullable;

  /// Whether this column is part of the primary key.
  final bool isPrimaryKey;

  /// Whether this column auto-increments (e.g., SERIAL, AUTO_INCREMENT).
  final bool isAutoIncrement;

  /// Creates a new [TableProperty] instance.
  ///
  /// [name] The database column name
  /// [type] The PostgreSQL data type
  /// [isNullable] Whether the column accepts NULL values
  /// [isPrimaryKey] Whether this is a primary key column
  /// [isAutoIncrement] Whether the column auto-increments
  TableProperty({
    required this.name,
    required this.type,
    required this.isNullable,
    required this.isPrimaryKey,
    required this.isAutoIncrement,
  });

  /// The property name in Dart camelCase convention.
  ///
  /// Converts snake_case database column names to camelCase property names.
  /// For example: 'created_at' becomes 'createdAt'.
  String get dartName => snakeToCamelCase(name);

  /// The corresponding Dart type for this database column.
  ///
  /// Uses the internal [_dartType] mapping to convert PostgreSQL types
  /// to their appropriate Dart equivalents.
  String get dartType => _dartType;
  /// Maps PostgreSQL data types to their corresponding Dart types.
  ///
  /// This method handles the conversion from PostgreSQL column types to
  /// appropriate Dart types for code generation. It supports:
  ///
  /// - **Integer types**: `int4`, `int8`, `serial`, `bigserial` → `int`
  /// - **Floating types**: `float4`, `float8`, `double precision` → `double`
  /// - **Numeric**: `numeric` → `num`
  /// - **Boolean**: `boolean`, `bool` → `bool`
  /// - **Text types**: `text`, `varchar`, `uuid`, timestamps → `String`
  /// - **JSON types**: `json`, `jsonb` → `Map<String, dynamic>`
  /// - **Array types**: `_text` → `List<String>`, `_numeric` → `List<num>`
  ///
  /// For unknown types, it attempts to convert the type name to PascalCase,
  /// assuming it might be a custom enum or composite type.
  ///
  /// Returns the Dart type name as a string.
  String get _dartType {
    switch (type) {
      case "float4" || "real" || "float8" || "double precision":
        return 'double';
      case 'integer' ||
            'int4' ||
            'int' ||
            'int2' ||
            'int8' ||
            'bigint' ||
            'smallint' ||
            'serial' ||
            'bigserial':
        return 'int';

      case 'numeric':
        return 'num';
      case 'boolean' || 'bool':
        return 'bool';
      case '_numeric':
        return 'List<num>';
      case '_text':
        return 'List<String>';
      case 'text' ||
            'uuid' ||
            'character varying' ||
            'varchar' ||
            'timestamp' ||
            'timestamptz' ||
            'date':
        return 'String';
      case 'json':
        return 'Map<String, dynamic>';
      case 'jsonb':
        return 'Map<String, dynamic>';
      default:
        log(type);
        stdout.writeln('Unknown type: $type');
        return snakeToPascalCase(type);
    }
  }

  /// Generates the Dart field declaration code.
  ///
  /// Creates a properly formatted Dart field declaration with:
  /// - `final` modifier for immutability
  /// - Correct type with nullability marker (`?`) if needed
  /// - Property name in camelCase
  ///
  /// Examples:
  /// - `final int id;` (non-nullable)
  /// - `final String? email;` (nullable)
  /// - `final Map<String, dynamic>? metadata;` (nullable JSON)
  ///
  /// Returns the complete field declaration as a string.
  String get field {
    return "final $dartType${isNullable ? "?" : ""} $dartName;";
  }
}
