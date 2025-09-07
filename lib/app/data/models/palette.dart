import 'package:isar/isar.dart';
import 'pad.dart';
part 'palette.g.dart';

@collection
class Palette {
  Id id = Isar.autoIncrement;

  late String name;
  int rows = 3;
  int cols = 4;

  // Relationship: a palette has many pads
  final pads = IsarLinks<Pad>();
}
