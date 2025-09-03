/// Example demonstrating how to use SupGen for code generation.
///
/// This example shows the basic setup and configuration needed to
/// generate Dart classes from a PostgreSQL/Supabase database schema.
///
/// ## Setup Required
///
/// 1. Create a `.env` file with your database credentials:
/// ```
/// SUPABASE_DB_USER=postgres
/// SUPABASE_DB_HOST=localhost
/// SUPABASE_DB_PORT=5432
/// SUPABASE_DB_PASSWORD=your_password
/// SUPABASE_DB=your_database
/// SUPABASE_DB_SCHEMA=public
/// ```
///
/// 2. Add configuration to `pubspec.yaml`:
/// ```yaml
/// sup_gen_option:
///   output: lib/generated
///   enable: true
///   schema: 'public'
///   useSsl: false
/// ```
///
/// 3. Run code generation:
/// ```bash
/// dart run build_runner build --delete-conflicting-outputs
/// ```
void main() {
  print('SupGen Example');
  print('==============');
  print('');
  print('This package generates Dart classes from PostgreSQL schemas.');
  print('Please refer to the README.md for complete setup instructions.');
  print('');
  print('Generated files will include:');
  print('- supabase_tables.gen.dart (table models)');
  print('- supabase_enums.gen.dart (enum definitions)');
  print('- supabase_view.gen.dart (view models)');
}
