import 'dart:io';

import 'package:carvalho/models/room.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path_provider/path_provider.dart';

class RoomDB {
  Future<Database> _getDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, "quartos.db");

    String sql =
        "CREATE TABLE quartos(id INTEGER PRIMARY KEY,number INTEGER,status STRING NOT NULL DEFAULT \"pronto\", size INTEGER NOT NULL);";

    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(sql);
      },
      // onConfigure: (db) {
      //   print("Here!");
      //   return db.execute(
      //     "DROP TABLE quartos; $sql",
      //   );
      // },
      version: 1,
    );
  }

  Future<void> insertRoom(Room reserva) async {
    // Get a reference to the database.
    final db = await _getDatabase();

    await db.insert(
      'quartos',
      reserva.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Room>> quartos() async {
    // Get a reference to the database.
    final db = await _getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('quartos');

    return List.generate(maps.length, (i) => Room.fromMap(maps[i]));
  }

  Future<void> updateStatus(int number, RoomStatus status) async {
    final db = await _getDatabase();

    db.update('quartos', {'status': status.name}, where: 'number = $number');
  }

  Future<void> deleteRoom(int number) async {
    final db = await _getDatabase();
    db.delete('quartos', where: 'number = $number');
  }

  Future<Room> getByNumber(int number) async {
    final db = await _getDatabase();
    return Room.fromMap(
        (await db.query('quartos', where: 'number = $number', limit: 1))[0]);
  }

  Future<List<Room>> getAvailable() async {
    final db = await _getDatabase();

    final List<Map<String, dynamic>> maps =
        await db.query('quartos', where: "status = 'pronto'");

    return List.generate(maps.length, (i) {
      return Room.fromMap(maps[i]);
    });
  }
}