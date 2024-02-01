import 'package:carvalho/models/room.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomDB {
  String tableName = 'quarto';
  Future<SupabaseClient> _getDatabase() async {
    return Supabase.instance.client;
  }

  Future<void> insertRoom(Room reserva) async {
    // Get a reference to the database.
    final db = await _getDatabase();

    await db.from('quarto').insert(
          reserva.toMap(),
        );
  }

  Future<List<Room>> quartos() async {
    // Get a reference to the database.
    final db = await _getDatabase();

    try {
      final List<Map<String, dynamic>> maps = await db.from(tableName).select();

      return List.generate(maps.length, (i) => Room.fromMap(maps[i]));
    } catch (e) {
      print("Error:\n${e}");
      return [];
    }
  }

  Future<void> updateStatus(int number, RoomStatus status) async {
    final db = await _getDatabase();

    db.from('quarto').update({'status': status.name}).match({'number': number});
  }

  Future<void> deleteRoom(int number) async {
    final db = await _getDatabase();
    db.from(tableName).delete().match({'number': number});
  }

  Future<Room> getByNumber(int number) async {
    final db = await _getDatabase();
    List values =
        await db.from(tableName).select().eq('number', number).limit(1);
    return Room.fromMap(values[0]);
  }

  Future<List<Room>> getAvailable() async {
    final db = await _getDatabase();

    final List<Map<String, dynamic>> maps =
        await db.from(tableName).select().eq('status', 'pronto');

    return List.generate(maps.length, (i) {
      return Room.fromMap(maps[i]);
    });
  }
}
