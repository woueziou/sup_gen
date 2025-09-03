# SupGen - Supabase Dart Class Generator

## Project Architecture

SupGen is a Dart **build_runner** code generator that creates Dart classes from PostgreSQL/Supabase database schemas. The project uses **Melos** for monorepo management with these key components:

- `packages/sup_gen_runner/` - Core code generation package (build_runner builder)
- `apps/project_test/` - Flutter test application demonstrating usage
- Generated files: `supabase_tables.gen.dart`, `supabase_enums.gen.dart`, `supabase_view.gen.dart`

## Key Development Workflows

### Code Generation Process
```bash
# Generate code using melos (preferred for monorepo)
melos run gen:build_runner

# Or run directly in a specific package
dart run build_runner build --delete-conflicting-outputs
```

### Environment Setup
Projects using SupGen require:
1. `.env` file with Supabase/PostgreSQL credentials:
   ```
   SUPABASE_DB_USER=postgres
   SUPABASE_DB_HOST=localhost
   SUPABASE_DB_PORT=5432
   SUPABASE_DB_PASSWORD=password
   SUPABASE_DB=database_name
   SUPABASE_DB_SCHEMA=public
   ```

2. `pubspec.yaml` configuration:
   ```yaml
   sup_gen_option:
     output: lib/supabase_models
     enable: true
     schema: 'public'
     useSsl: false
   ```

## Critical Patterns & Conventions

### Builder Configuration (`build.yaml`)
- **Auto-apply**: Only applies to `root_package`, not dependencies
- **Runs before**: JsonSerializable and Freezed generators
- **Build extensions**: `{ '$package$': [] }` (generates multiple files from single trigger)

### Database Connection Pattern
All DB operations use `DatabaseHelper._getConnection()` which:
- Handles SSL configuration based on `useSsl` option
- Uses `postgres` package for direct PostgreSQL connections
- Connections are opened/closed per operation (no connection pooling)

### Code Generation Patterns
1. **Table Generation**: Creates classes with `fromJson()` factories and properties
2. **Enum Generation**: Creates Dart enums with `.name` getters that return database string values
3. **Naming Conventions**: 
   - Snake_case database names → PascalCase class names
   - Uses `hasValidName` validation before generating classes

### File Structure Conventions
```
lib/
  supabase_models/           # Generated output directory
    supabase_tables.gen.dart # Database tables as Dart classes  
    supabase_enums.gen.dart  # Database enums as Dart enums
    supabase_view.gen.dart   # Database views as Dart classes
```

## Development Commands

```bash
# Analyze all packages
melos run analyze

# Install dependencies across monorepo  
melos run get

# Run code generation across all packages
melos run gen:build_runner

# Work in specific package
cd packages/sup_gen_runner
dart pub get
dart run build_runner build --delete-conflicting-outputs
```

## Integration Points

- **PostgreSQL**: Direct connection via `postgres` package, queries `information_schema`
- **build_runner**: Standard Dart build system integration  
- **Melos**: Monorepo management for multi-package development
- **Generated Code**: Imports `dart:convert` for JSON handling, cross-references enums

## Common Issues & Debugging

1. **Generation Failures**: Check `.env` file exists and database credentials are correct
2. **Invalid Class Names**: Database table names must be valid Dart identifiers
3. **SSL Connection Issues**: Verify `useSsl` setting matches database configuration
4. **Build Conflicts**: Use `--delete-conflicting-outputs` flag when regenerating

## Testing Strategy
- Test app in `apps/project_test/` demonstrates real usage
- Generated files should compile without errors and handle null values appropriately
- Test both SSL and non-SSL database connections
