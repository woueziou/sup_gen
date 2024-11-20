import 'package:copy_generator/configs/annotations.dart';

part 'example.g.dart';
part 'example.add.dart';

final name = 'John Doe';

@Multiplier(2)
final fortune = 95;

@Add(5)
final age = 95;

class Dog {
  const Dog(this.name, this.age);
  final String name;
  final int age;
}
