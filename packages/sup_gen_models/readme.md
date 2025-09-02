# sup_gen_models

`sup_gen_models` is a Dart package providing core model definitions and utilities for the [sup_gen](https://github.com/woueziou/sup_gen) code generation ecosystem. It is designed to be used by related packages such as `sup_gen_runner` and `sup_gen_sqler`, and can be integrated into your own Dart/Flutter projects for database modeling, code generation, and more.

## Features

- **Table Modeling:** Define database tables and their properties using Dart classes.
- **Enum Modeling:** Create and manage enums for your models.
- **Code Generation Utilities:** Generate Dart classes and serialization logic from model definitions.
- **Extensions:** Includes string manipulation helpers for converting between naming conventions.

## Folder Structure

- `lib/objects/`: Contains model classes like `TableModel`, `TableProperty`, and `EnumModel`.
- `lib/extensions/`: Utility extensions, e.g., for string case conversion.
- `lib/pubspec/`: Pubspec-related utilities.
- `lib/main.dart`: Example usage and entry point.
- `build.yaml`, `pubspec.yaml`: Build and dependency configuration.

## Getting Started

### 1. Install Dependencies

Navigate to the package directory and run:

```sh
dart pub get
```

### 2. Usage Example

You can use the models in your Dart code as follows:

```dart
import 'package:sup_gen_model/objects/table_model.dart';

void main() {
	final table = TableModel(name: "user", properties: [
		TableProperty(
			name: "id",
			type: "int",
			isNullable: false,
			isPrimaryKey: true,
			isAutoIncrement: true,
		),
		TableProperty(
			name: "name",
			type: "String",
			isNullable: false,
			isPrimaryKey: false,
			isAutoIncrement: false,
		),
	]);

	print(table.createClass());
}
```

### 3. Code Generation

If you use code generation (e.g., with `build_runner`), run:

```sh
dart run build_runner build
```

### 4. Testing

To run tests:

```sh
dart test
```

## Contributing

Feel free to open issues or submit pull requests on [GitHub](https://github.com/woueziou/sup_gen).

## License

See the [LICENSE](LICENSE) file for details.
