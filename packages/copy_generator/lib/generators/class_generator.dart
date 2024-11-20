import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:copy_generator/examples/example.dart';
import 'package:source_gen/source_gen.dart';

class ClassNameGenerator extends Generator {
  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    var output = StringBuffer();
    for (var annotatedElement
        in library.annotatedWith(TypeChecker.fromRuntime(Dog))) {
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
