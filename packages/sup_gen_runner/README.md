# SupGen (Supabase Dart Class Generator)

A Dart package for generating classes, enums, and views directly from a Supabase PostgreSQL server. Simplify the process of integrating your database schema into your Dart/Flutter projects.

## Features

- Automatically generate Dart classes from PostgreSQL tables.
- Replicate enum types and views from the `public` schema or a specified schema.
- Easy configuration and seamless integration.

## Installation

### 1. Add the package to your project

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  supabase_dart_generator: ^<latest_version>
dev_dependencies:
  build_runner: ^2.3.3
```

Replace **<latest_version>** with the latest version of the package.

Run the following command to fetch the pacakge
```bash
flutter pub get
# or
dart pub get
```

### 2. Configure your project
##### Add configration to pubspec.yml
#
```yaml
sup_gen_option:
  output: lib/supabase_models #the desired output folder 
  enable: true # Enable or disable the package 
  schema: 'public' #The schema that will be used
  useSsl: false # control if the ssl is required for the server or no
```
##### Add .env file
#
include you Supabase database credential

```env
# .env file
SUPABASE_DB_USER=postgres
SUPABASE_DB_HOST=DB_HOST
SUPABASE_DB_PORT=DB_PORT
SUPABASE_DB_PASSWORD=YOUR_DB_PASSWORD
SUPABASE_DB_SCHEMA=public
```
⚠️ Important: Keep your .env file secure. Do not commit it to version control. You don't want to give the key of you home to the world


### 3. Generate classes

```bash
dart run build_runner build
```
You will see in your output folder some files:
-  supabase_enums.gen.dart  // for enums
-  supabase_tables.gen.dart // for tables




## Roadmap

- Additional browser support

- Add more integrations

[x] Setup project 

[x] Write SQL Queries

[x] Write Colum type adapters 

[ ] handle Enums mapping

[ ] handle Table mapping

[ ] Handle views mapping

[ ] handle Enum reverse target : get enum value string name

[ ] Setup test cases

[ ] Handle Edge functions mapping

[ ] Handle RPC mapping

[ ]  Add  [freezed](https://pub.dev/packages/freezed) support to classes

[ ] Add json_annotation
## License

MIT License

Copyright (c) 2024 Taas Ekpaye

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

