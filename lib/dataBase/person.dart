import 'package:hive/hive.dart';

part 'person.g.dart';

@HiveType(typeId: 1)
class B_Person {
  B_Person({
    required this.name,
  });

  @HiveField(0)
  String name;
}
