import 'dart:convert';

import 'package:carvalho/models/hospede.dart';
import 'package:carvalho/models/room.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class RoomDB {
  Future<Database> _getDatabase() async {
    return openDatabase(
      join('assets', 'cities.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE reservas(id INTEGER PRIMARY KEY AUTOINCREMENT,number INTEGER NOT NULL,checkin DATETIME NOT NULL,checkout DATETIME NOT NULL,status STRING NOT NULL DEFAULT \"pronto\",hospedes STRING DEFAULT \"[]\",preco INTEGER DEFAULT 50,valor INTEGER NOT NULL)");
      },
      version: 1,
    );
  }

  Future<void> insertRoom(Room reserva) async {
    // Get a reference to the database.
    final db = await _getDatabase();

    await db.insert(
      'reservas',
      reserva.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Room>> reservas() async {
    // Get a reference to the database.
    final db = await _getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('reservas');

    return List.generate(maps.length, (i) {
      List<int> checkin = (maps[i]['checkin'] as String)
          .split("/")
          .map((e) => int.parse(e))
          .toList();
      List<int> checkout = (maps[i]['checkout'] as String)
          .split("/")
          .map((e) => int.parse(e))
          .toList();

      Map<String, RoomStatus> statuses = {
        "pronto": RoomStatus.pronto,
        "usado": RoomStatus.usado,
        "ocupado": RoomStatus.ocupado,
      };

      return Room(
          id: maps[i]['id'] as int,
          number: maps[i]['number'] as int,
          checkin: DateTime(checkin.last, checkin[1], checkin.first),
          checkout: DateTime(checkout.last, checkout[1], checkout.first),
          status: statuses[maps[i]['status'] as String]!,
          hospedes: (jsonDecode(maps[i]['hospedes']) as List)
              .map((e) => Hospede.fromMap(e))
              .toList(),
          preco: maps[i]['preco'] as int);
    });
  }

  Future<void> updateStatus(int id, RoomStatus status) async {
    final db = await _getDatabase();

    db.update('reservas', {'status': status.name}, where: 'id = $id');
  }
}
