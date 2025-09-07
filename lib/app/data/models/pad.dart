import 'package:isar/isar.dart';
part 'pad.g.dart';

@collection
class Pad {
  Id id = Isar.autoIncrement;

  late String title;
  late String uri;             // file path (or asset path if you add assets)
  int color = 0xFF3B82F6;      // ARGB (default blue)
  double volume = 1.0;
  bool loop = false;

  int fadeInMs = 10;
  int fadeOutMs = 20;

  double? trimStart;           // seconds
  double? trimEnd;             // seconds

  String? hotkey;              // desktop only
}
