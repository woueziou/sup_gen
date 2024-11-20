import 'dart:async';

import 'package:build/build.dart';

class CopyBuilder implements Builder {
  final BuilderOptions options;

  CopyBuilder({required this.options});

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    AssetId inputId = buildStep.inputId;

    // var copyAssetId = inputId.changeExtension('.copy.txt');
    // final path = options.config['output'] as String;
    final asset = inputId.changeExtension('.copy.txt');

    var contents = await buildStep.readAsString(inputId);
    print(options.config['author']);
    contents = '''
This is a copy by  ${options.config['author']}:
----------------
$contents
''';

    await buildStep.writeAsString(asset, contents);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        '.txt': ['.copy.txt'],
      };
}
