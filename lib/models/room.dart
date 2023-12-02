import 'dart:convert';

import 'package:carvalho/models/hospede.dart';
import 'package:intl/intl.dart';

class Room {
  late int id = 0;
  late int number;
  late DateTime checkin;
  late DateTime checkout;
  late RoomStatus status = RoomStatus.pronto;
  late List<Hospede> hospedes = [];
  late int preco = 50;
  late int valor;

  Room({
    this.id = 0,
    required this.number,
    required this.checkin,
    required this.checkout,
    required this.status,
    required this.hospedes,
    this.preco = 50,
  }) {
    if(DateTime.now().isAfter(checkout)){
      status = RoomStatus.usado;
    }
    valor = (checkout.difference(checkin).inDays) * hospedes.length * preco;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'checkin': DateFormat('dd/MM/yyyy').format(checkin),
      'checkout': DateFormat('dd/MM/yyyy').format(checkout),
      'status': status.name,
      'hospedes': jsonEncode(hospedes.map((e) => e.toMap()).toList()),
      'preco': preco,
      'valor': valor
    };
  }
}

enum RoomStatus { pronto, usado, ocupado }
