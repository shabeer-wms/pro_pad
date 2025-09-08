import 'package:isar/isar.dart';
import 'package:pro_pad/app/data/models/pad.dart';
import 'package:pro_pad/app/data/models/palette.dart';
import 'package:pro_pad/app/services/storage_service.dart';

class PaletteRepository {
  final Isar _db = StorageService.isar;

  Future<List<Palette>> fetchPalettes() async {
    return _db.palettes.where().findAll();
  }

  Future<Palette?> getFirstPalette() async {
    return _db.palettes.where().findFirst();
  }

  Future<Palette> createPalette(
    String name, {
    int rows = 6,
    int cols = 5,
  }) async {
    final pal = Palette()
      ..name = name
      ..rows = rows
      ..cols = cols;
    await _db.writeTxn(() async {
      await _db.palettes.put(pal);
    });
    return pal;
  }

  Future<void> addPadToPalette(Palette palette, Pad pad) async {
    await _db.writeTxn(() async {
      await _db.pads.put(pad);
      palette.pads.add(pad);
      await palette.pads.save();
    });
  }

  Future<Palette?> loadPaletteWithPads(int id) async {
    final pal = await _db.palettes.get(id);
    if (pal != null) {
      await pal.pads.load();
    }
    return pal;
  }

  Future<void> removePad(Palette palette, Pad pad) async {
    await _db.writeTxn(() async {
      palette.pads.remove(pad);
      await palette.pads.save();
      await _db.pads.delete(pad.id);
    });
  }

  /// Persist changes to an existing pad.
  Future<void> updatePad(Pad pad) async {
    await _db.writeTxn(() async {
      await _db.pads.put(pad);
    });
  }

  Future<void> updatePaletteGrid(Palette palette, int rows, int cols) async {
    await _db.writeTxn(() async {
      palette.rows = rows;
      palette.cols = cols;
      await _db.palettes.put(palette);
    });
  }
}
