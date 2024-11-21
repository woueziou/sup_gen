import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:sup_gen_runner/src/annotations/cls_gen.dart';

class ClassGenerator extends Generator {
  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    final output = StringBuffer();

    for (var annotatedElement
        in library.annotatedWith(TypeChecker.fromRuntime(ClsGen))) {
      final element = annotatedElement.element;
      if (element is ClassElement) {
        final className = element.name;
        output.writeln('class ${className}Generated {');
        output.writeln('  // Add generated content here');
        output.writeln('}');
      }
    }
  

    return output.toString();
  }
}
