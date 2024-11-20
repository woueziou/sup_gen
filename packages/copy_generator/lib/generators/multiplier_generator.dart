import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:copy_generator/configs/annotations.dart';
import 'package:source_gen/source_gen.dart';

class MultiplierGenerator extends GeneratorForAnnotation<Multiplier> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! TopLevelVariableElement || !element.type.isDartCoreInt) {
      throw InvalidGenerationSourceError(
        '@Multiplier can only be applied on top level integer variable. Failing element: ${element.name}',
        element: element,
      );
    }

    final numValue = annotation.read('value').literalValue as num;

    return 'num ${element.name}Multiplied() => ${element.name} * $numValue;';
  }
}
