String snakeToPascalCase(String text) {
  if (text.isEmpty) return text;
  return text
      .split('_')
      .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join();
}

bool isValidDartClassName(String text) {
  final validClassNameRegExp = RegExp(r'^[A-Z][A-Za-z0-9]*$');
  final snakeText = snakeToPascalCase(text);
  return validClassNameRegExp.hasMatch(snakeText);
}

String snakeToCamelCase(String text) {
  final pascalCase = snakeToPascalCase(text);
  return pascalCase[0].toLowerCase() + pascalCase.substring(1);
}
