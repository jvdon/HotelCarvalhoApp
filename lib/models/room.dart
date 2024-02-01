class Room {
  // late int id = 0;
  late int number;
  late RoomStatus status = RoomStatus.pronto;
  late int size;

  Room({
    // this.id = 0,
    required this.number,
    required this.size,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'number': number,
      'size': size,
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
    size = json['size'] ?? -1;
  }

  @override
  String toString() {
    return "Room > { $number - ${status.name} - ${size}x💂‍♂️}";
  }
}

enum RoomStatus { pronto, usado, ocupado }