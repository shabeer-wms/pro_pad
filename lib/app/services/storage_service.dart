import 'dart:io';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../data/models/pad.dart';
import '../data/models/palette.dart';

class StorageService {
  static Isar? _isar;

  static Isar get isar {
    final db = _isar;
    if (db == null) {
      throw StateError(
        'Isar not initialized. Call StorageService.init() first.',
      );
    }
    return db;
  }

  static Future<void> init() async {
    if (_isar != null) return;
    Directory dir = await getApplicationSupportDirectory();
    _isar = await Isar.open(
      [PadSchema, PaletteSchema],
      directory: dir.path,
      name: 'pro_pad',
    );

    // Seed a default palette if none
    final count = await _isar!.palettes.count();
    if (count == 0) {
      await _isar!.writeTxn(() async {
        final p = Palette()
          ..name = 'Default'
          ..rows = 3
          ..cols = 4;
        await _isar!.palettes.put(p);
      });
    }
  }
}
