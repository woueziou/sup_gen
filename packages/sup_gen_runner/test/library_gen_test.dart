import 'package:sup_gen_runner/extensions/string_extension.dart';
import 'package:sup_gen_runner/models/database_option.dart';
import 'package:sup_gen_runner/models/enum_model.dart';
import 'package:sup_gen_runner/models/table_model.dart';
import 'package:test/test.dart';

void main() {
  group('String Extension Tests', () {
    test('snakeToPascalCase converts correctly', () {
      expect(snakeToPascalCase('user_profile'), equals('UserProfile'));
      expect(snakeToPascalCase('first_name'), equals('FirstName'));
      expect(snakeToPascalCase('id'), equals('Id'));
      expect(snakeToPascalCase(''), equals(''));
    });

    test('snakeToCamelCase converts correctly', () {
      expect(snakeToCamelCase('user_id'), equals('userId'));
      expect(snakeToCamelCase('first_name'), equals('firstName'));
      expect(snakeToCamelCase('created_at'), equals('createdAt'));
    });

    test('isValidDartClassName validates correctly', () {
      expect(isValidDartClassName('user_profile'), isTrue);
      expect(isValidDartClassName('first_name'), isTrue);
      expect(isValidDartClassName('123_invalid'), isFalse);
    });
  });

  group('DatabaseOption Tests', () {
    test('DatabaseOption creates correctly', () {
      final option = DatabaseOption(
        userName: 'postgres',
        schema: 'public',
        password: 'password',
        host: 'localhost',
        port: 5432,
        db: 'testdb',
        useSSL: false,
      );

      expect(option.userName, equals('postgres'));
      expect(option.schema, equals('public'));
      expect(option.host, equals('localhost'));
      expect(option.port, equals(5432));
      expect(option.useSSL, isFalse);
    });
  });

  group('EnumModel Tests', () {
    test('EnumModel generates correct enum name', () {
      final enumModel = EnumModel(
        name: 'user_status',
        values: ['active', 'inactive', 'pending'],
      );

      expect(enumModel.enumName, equals('UserStatus'));
      expect(enumModel.values, hasLength(3));
      expect(enumModel.mappedData, isA<Map<String, String>>());
    });
  });

  group('TableModel Tests', () {
    test('TableModel generates correct class name', () {
      final tableModel = TableModel(
        name: 'user_profiles',
        properties: [],
      );

      expect(tableModel.className, equals('UserProfiles'));
      expect(tableModel.hasValidName, isTrue);
    });

    test('TableProperty handles different types correctly', () {
      final property = TableProperty(
        name: 'user_id',
        type: 'int4',
        isNullable: false,
        isPrimaryKey: true,
        isAutoIncrement: false,
      );

      expect(property.dartName, equals('userId'));
      expect(property.dartType, equals('int'));
      expect(property.field, equals('final int userId;'));
    });

    test('TableProperty handles nullable types', () {
      final property = TableProperty(
        name: 'email',
        type: 'varchar',
        isNullable: true,
        isPrimaryKey: false,
        isAutoIncrement: false,
      );

      expect(property.dartName, equals('email'));
      expect(property.dartType, equals('String'));
      expect(property.field, equals('final String? email;'));
    });
  });
}
