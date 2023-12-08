import 'dart:convert';

import 'package:carvalho/models/hospede.dart';
import 'package:carvalho/models/room.dart';
import 'package:intl/intl.dart';

class Reserva {
  late int id = 0;
  late Room quarto;
  late DateTime checkin;
  late DateTime checkout;
  late List<Hospede> hospedes = [];
  late int preco = 50;
  late int valor;

  Reserva({
    this.id = 0,
    required this.checkin,
    required this.checkout,
    required this.hospedes,
    required this.quarto,
    this.preco = 50,
  }) {
    valor = (checkout.difference(checkin).inDays) * hospedes.length * preco;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quarto': jsonEncode(quarto.toMap()),
      'checkin': DateFormat('dd/MM/yyyy').format(checkin),
      'checkout': DateFormat('dd/MM/yyyy').format(checkout),
      'hospedes': jsonEncode(hospedes.map((e) => e.toMap()).toList()),
      'preco': preco,
      'valor': valor
    };
  }

  Reserva.fromJSON(Map json) {
    List checkinS = (json['checkin'] as String)
        .split("/")
        .map((e) => int.parse(e))
        .toList();
    List checkoutS = (json['checkout'] as String)
        .split("/")
        .map((e) => int.parse(e))
        .toList();

    id = json['id'];
    quarto = Room.fromMap(jsonDecode(json['quarto']));
    checkin = DateTime(checkinS.last, checkinS[1], checkinS.first);
    checkout = DateTime(checkoutS.last, checkoutS[1], checkoutS.first);
    hospedes = (jsonDecode(json['hospedes']) as List)
        .map((e) => Hospede.fromMap(e))
        .toList();
    preco = json['preco'] as int;
    valor = (checkout.difference(checkin).inDays) * hospedes.length * preco;
  }
}
