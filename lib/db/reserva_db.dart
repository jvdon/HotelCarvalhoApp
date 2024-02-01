import 'dart:io';

import 'package:carvalho/db/room_db.dart';
import 'package:carvalho/models/reserva.dart';
import 'package:carvalho/models/room.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReservaDB {
  Future<SupabaseClient> _getDatabase() async {
    return Supabase.instance.client;
  }

  Future<void> insertReserva(Reserva reserva) async {
    // Get a reference to the database.
    final db = await _getDatabase();

    await db.from('reservas').insert(
      reserva.toMap(),
    );

    RoomDB().updateStatus(reserva.quarto.number, RoomStatus.ocupado);
  }

  Future<void> deleteReserva(Reserva reserva) async {
    final db = await _getDatabase();
    RoomDB().updateStatus(reserva.quarto.number, RoomStatus.pronto);
    db.from('reservas').delete().eq('id', reserva.id);
  }

  Future<List<Reserva>> reservas() async {
    // Get a reference to the database.
    final db = await _getDatabase();

    final List<Map<String, dynamic>> maps = await db.from('reservas').select();

    return List.generate(
      maps.length,
      (i) {
        return Reserva.fromJSON(maps[i]);
      },
    );
  }

  Future<void> updateStatus(Reserva reserva, ReservaStatus status) async {
    print(reserva.id);
    final db = await _getDatabase();
    if (status == ReservaStatus.FECHADA || status == ReservaStatus.PAGA) {
      RoomDB().updateStatus(reserva.quarto.number, RoomStatus.usado);
    }

    db.from('reservas').update({'status': status.name}).match({'id': reserva.id});
  }
}
