import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class TopLevelNamesGenerator extends Generator {
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    var joinedVariableName = library.allElements
        .whereType<TopLevelVariableElement>()
        .map((e) => e.name)
        .join(',');
        
    var joinedClassName = library.allElements
        .whereType<ClassElement>()
        .map((e) => e.name)
        .join(',');

    return '''
// Source library: ${library.element.source.uri}  
const topLevelVariableNames = '$joinedVariableName';  
const classNames = '$joinedClassName';  
''';
  }
}
