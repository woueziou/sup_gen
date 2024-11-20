import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import '../configs/annotations.dart';

class AddGenerator extends GeneratorForAnnotation<Add> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! TopLevelVariableElement || !element.type.isDartCoreInt) {
      throw InvalidGenerationSourceError(
        '@Add can only be applied on top level integer variable. Failing element: ${element.name}',
        element: element,
      );
    }

    final value = annotation.read("value").literalValue as num;
    return 'num ${element.name}addedValue() => ${element.name} * $value;';
  }
}
