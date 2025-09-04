
/// Converts a snake_case string to PascalCase.
///
/// Takes a string with underscores and converts it to PascalCase by:
/// 1. Splitting on underscores
/// 2. Capitalizing the first letter of each word
/// 3. Making the rest of each word lowercase
/// 4. Joining all words together
///
/// Examples:
/// ```dart
/// snakeToPascalCase('user_profile') // Returns 'UserProfile'
/// snakeToPascalCase('first_name') // Returns 'FirstName'
/// snakeToPascalCase('id') // Returns 'Id'
/// snakeToPascalCase('') // Returns ''
/// ```
///
/// [text] The snake_case string to convert
/// Returns the converted PascalCase string
String snakeToPascalCase(String text) {
  if (text.isEmpty) return text;
  return text
      .split('_')
      .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join();
}

/// Validates whether a string can be converted to a valid Dart class name.
///
/// Checks if the string, when converted to PascalCase, follows Dart's
/// class naming conventions:
/// - Must start with an uppercase letter
/// - Can only contain letters and numbers
/// - No special characters or underscores
///
/// Examples:
/// ```dart
/// isValidDartClassName('user_profile') // Returns true ('UserProfile')
/// isValidDartClassName('first_name') // Returns true ('FirstName')
/// isValidDartClassName('123_invalid') // Returns false (starts with number)
/// isValidDartClassName('user-profile') // Returns false (contains hyphen)
/// ```
///
/// [text] The string to validate (typically a database table name)
/// Returns `true` if the string can become a valid Dart class name
bool isValidDartClassName(String text) {
  final validClassNameRegExp = RegExp(r'^[A-Z][A-Za-z0-9]*$');
  final snakeText = snakeToPascalCase(text);
  return validClassNameRegExp.hasMatch(snakeText);
}

/// Converts a snake_case string to camelCase.
///
/// Similar to [snakeToPascalCase] but makes the first letter lowercase
/// to follow Dart property naming conventions.
///
/// Examples:
/// ```dart
/// snakeToCamelCase('user_id') // Returns 'userId'
/// snakeToCamelCase('first_name') // Returns 'firstName'
/// snakeToCamelCase('created_at') // Returns 'createdAt'
/// ```
///
/// [text] The snake_case string to convert
/// Returns the converted camelCase string
String snakeToCamelCase(String text) {
  final pascalCase = snakeToPascalCase(text);
  return pascalCase[0].toLowerCase() + pascalCase.substring(1);
}
