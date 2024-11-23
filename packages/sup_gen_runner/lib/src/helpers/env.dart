import 'dart:io';

import 'package:sup_gen_model/database_option.dart';


DatabaseOption loadDbOptionFromEnvFile({required File envFile}) {
  if (!envFile.existsSync()) {
    throw Exception('The .env file does not exist');
  }

  final envContent = envFile.readAsStringSync();

  final lines = envContent.split('\n');
  final envMap = <String, String>{};
  for (var line in lines) {
    if (line.trim().isEmpty || line.trim().startsWith('#')) continue;
    final parts = line.split('=');
    if (parts.length != 2) continue;
    final key = parts[0].trim();
    final value = parts[1].trim();
    envMap[key] = value;
  }
  // stdout.writeln('[SupGen] Loaded .env file');

  final keys = {
    "SUPABASE_DB_USER",
    "SUPABASE_DB_HOST",
    "SUPABASE_DB_PORT",
    "SUPABASE_DB_PASSWORD",
    "SUPABASE_DB_SCHEMA"
  };
  // check if the required keys are present

  for (var element in keys) {
    if (!envMap.containsKey(element)) {
      stdout.writeln("[SupGen] The $element key is required in the .env file");
      throw Exception('The $element key is required in the .env file');
    }
  }

  return DatabaseOption(
    userName: envMap['SUPABASE_DB_USER']!,
    password: envMap['SUPABASE_DB_PASSWORD']!,
    host: envMap['SUPABASE_DB_HOST']!,
    schema: envMap['SUPABASE_DB_SCHEMA'] ?? 'public',
    port: int.parse(envMap['SUPABASE_DB_PORT']!),
  );
}
