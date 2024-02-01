import 'dart:io';

import 'package:carvalho/db/room_db.dart';
import 'package:carvalho/models/reserva.dart';
import 'package:carvalho/models/room.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ReservaDB {
  Future<Database> _getDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, "reservas.db");

    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE reservas(id INTEGER PRIMARY KEY AUTOINCREMENT,quarto STRING,checkin DATETIME NOT NULL,checkout DATETIME NOT NULL,hospedes STRING DEFAULT \"[]\",preco INTEGER DEFAULT 50,valor INTEGER NOT NULL, status STRING NOT NULL DEFAULT 'ATIVA');");
      },
      version: 1,
    );
  }

  Future<void> insertReserva(Reserva reserva) async {
    // Get a reference to the database.
    final db = await _getDatabase();

    await db.insert(
      'reservas',
      reserva.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    RoomDB().updateStatus(reserva.quarto.number, RoomStatus.ocupado);
  }

  Future<void> deleteReserva(Reserva reserva) async {
    final db = await _getDatabase();
    RoomDB().updateStatus(reserva.quarto.number, RoomStatus.pronto);
    db.delete('reservas', where: 'id = ${reserva.id}');
  }

  Future<List<Reserva>> reservas() async {
    // Get a reference to the database.
    final db = await _getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('reservas');

    return List.generate(
      maps.length,
      (i) {
        return Reserva.fromJSON(maps[i]);
      },
    );
  }

  Future<void> updateStatus(Reserva reserva, ReservaStatus status) async {
    final db = await _getDatabase();
    if (status == ReservaStatus.FECHADA || status == ReservaStatus.PAGA) {
      RoomDB().updateStatus(reserva.quarto.number, RoomStatus.usado);
    }

    db.update('reservas', {'status': status.name}, where: 'id = ${reserva.id}');
  }
}