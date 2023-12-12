import 'dart:convert';
import 'dart:io';

import 'package:carvalho/models/hospede.dart';
import 'package:carvalho/models/reserva.dart';
import 'package:carvalho/models/room.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class RoomDB {
  Future<Database> _getDatabase() async {
    String path = join(await getDatabasesPath(), 'quartos.db');
    print(File.fromUri(Uri.parse(path)).exists());
    print(path);

    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE quartos(id INTEGER PRIMARY KEY,number INTEGER,status STRING NOT NULL DEFAULT \"pronto\")",
        );
      },
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

    return List.generate(maps.length, (i) {
      Map<String, RoomStatus> statuses = {
        "pronto": RoomStatus.pronto,
        "usado": RoomStatus.usado,
        "ocupado": RoomStatus.ocupado,
      };

      return Room.fromMap(maps[i]);
    });
  }

  Future<void> updateStatus(int number, RoomStatus status) async {
    final db = await _getDatabase();

    db.update('quartos', {'status': status.name}, where: 'number = $number');
  }

  Future<Room> getByNumber(int number) async {
    final db = await _getDatabase();
    return Room.fromMap(
        (await db.query('quartos', where: 'number = $number', limit: 1))[0]);
  }
}
