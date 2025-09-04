# SupGen (Supabase Dart Class Generator)

A Dart build_runner package for generating classes, enums, and views directly from a Supabase PostgreSQL server. Simplify the process of integrating your database schema into your Dart/Flutter projects.

## Features

- 🚀 Automatically generate Dart classes from PostgreSQL tables
- 🔧 Generate enum types and views from your database schema
- ⚙️ Easy configuration through `pubspec.yaml`
- 🔒 Support for both SSL and non-SSL database connections
- 📁 Customizable output directory
- 🌊 Seamless integration with `build_runner` workflow

## Installation

### 1. Add the package to your project

Add the following to your `pubspec.yaml` file:

```yaml
dev_dependencies:
  build_runner: ^2.4.6
  sup_gen_runner: <latest>
```

> **Note**: `sup_gen_runner` should be added to `dev_dependencies` as it's a code generation tool.

Run the following command to fetch the package:
```bash
flutter pub get
# or
dart pub get
```

### 2. Configure your project

#### Add configuration to `pubspec.yaml`

Add the SupGen configuration section to your `pubspec.yaml`:

```yaml
sup_gen_option:
  output: lib/supabase_models    # The desired output folder 
  enable: true                   # Enable or disable the package 
  schema: 'public'               # The database schema to use
  useSsl: false                  # Whether SSL is required for database connection
```

#### Create a `.env` file

Create a `.env` file in your project root with your Supabase/PostgreSQL database credentials:

```env
# .env file
SUPABASE_DB_USER=postgres
SUPABASE_DB_HOST=your-db-host
SUPABASE_DB_PORT=5432
SUPABASE_DB_PASSWORD=your-db-password
SUPABASE_DB_SCHEMA=public
SUPABASE_DB=your-database-name
```

⚠️ **Important**: Keep your `.env` file secure. Add it to your `.gitignore` to prevent committing sensitive credentials to version control.


### 3. Generate classes

Run the build_runner command to generate your Dart classes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

> **Tip**: Use the `--delete-conflicting-outputs` flag to automatically resolve any file conflicts during code generation.

### 4. Generated Files

After running the build command, you'll find the following generated files in your specified output directory (default: `lib/supabase_models`):

- 📋 `supabase_tables.gen.dart` - Database tables as Dart classes
- 🏷️ `supabase_enums.gen.dart` - Database enums as Dart enums  
- 👁️ `supabase_view.gen.dart` - Database views as Dart classes

## Example Usage

Here's a basic example of how to use the generated classes:

```dart
import 'lib/supabase_models/supabase_tables.gen.dart';
import 'lib/supabase_models/supabase_enums.gen.dart';

// Use generated table classes
final user = User.fromJson(jsonData);
print(user.name);

// Use generated enums
final status = UserStatus.active;
print(status.name); // Returns the database string value
```




## Development Workflow

For development in the SupGen monorepo, use [Melos](https://melos.invertase.dev/) commands:

```bash
# Install dependencies across all packages
melos run get

# Run code generation across all packages  
melos run gen:build_runner

# Analyze all packages
melos run analyze
```

## Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `output` | String | `lib/supabase_models` | Output directory for generated files |
| `enable` | Boolean | `true` | Enable/disable code generation |
| `schema` | String | `'public'` | Database schema to process |
| `useSsl` | Boolean | `false` | Use SSL for database connection |

## Roadmap

- [x] Setup project 
- [x] Write SQL Queries
- [x] Write Column type adapters 
- [x] Handle Table mapping
- [x] Handle Enums mapping
- [x] Handle views mapping
- [x] Handle Enum reverse target: get enum value string name
- [ ] Handle Edge functions mapping
- [ ] Setup test cases
- [ ] Handle RPC mapping
- [ ] Add [freezed](https://pub.dev/packages/freezed) support to classes
- [ ] Add json_annotation support
## License

MIT License

Copyright (c) 2024 Taas Ekpaye

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

