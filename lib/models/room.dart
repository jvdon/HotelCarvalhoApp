import 'dart:convert';

import 'package:carvalho/models/hospede.dart';
import 'package:intl/intl.dart';

class Room {
  // late int id = 0;
  late int number;
  late RoomStatus status = RoomStatus.pronto;

  Room({
    // this.id = 0,
    required this.number,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'number': number,
      'status': status.name,
    };
  }

  Room.fromMap(Map json) {
    Map<String, RoomStatus> statuses = {
      "pronto": RoomStatus.pronto,
      "usado": RoomStatus.usado,
      "ocupado": RoomStatus.ocupado,
    };

    // id = json['id'];
    number = json["number"];
    status = statuses[json["status"]]!;
  }

  @override
  String toString() {
    return "Room > { $number - ${status.name} }";
  }
}

enum RoomStatus { pronto, usado, ocupado }
