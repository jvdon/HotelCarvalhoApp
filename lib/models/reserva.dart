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
  late int preco = 60;
  late int valor;
  late ReservaStatus status;

  Reserva(
      {this.id = 0,
      required this.checkin,
      required this.checkout,
      required this.hospedes,
      required this.quarto,
      this.preco = 60,
      required this.status}) {
    valor = (checkout.difference(checkin).inDays) * hospedes.length * preco;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quarto': jsonEncode(quarto.toMap()),
      'checkin': DateFormat('yyyy/MM/dd').format(checkin),
      'checkout': DateFormat('yyyy/MM/dd').format(checkout),
      'hospedes': jsonEncode(hospedes.map((e) => e.toMap()).toList()),
      'preco': preco,
      'valor': valor,
      'status': status.name
    };
  }

  Reserva.fromJSON(Map json) {
    Map<String, ReservaStatus> statuses = {
      "ATIVA": ReservaStatus.ATIVA,
      "FECHADA": ReservaStatus.FECHADA,
      "PAGA": ReservaStatus.PAGA
    };

    id = json['id'];
    quarto = Room.fromMap(jsonDecode(json['quarto']));
    checkin = DateTime.parse(json["checkin"]);
    checkout = DateTime.parse(json["checkout"]);
    hospedes = (jsonDecode(json['hospedes']) as List)
        .map((e) => Hospede.fromMap(e))
        .toList();
    status = statuses[json["status"]]!;
    preco = json['preco'] as int;
    valor = (checkout.difference(checkin).inDays) * hospedes.length * preco;
  }
}

enum ReservaStatus { ATIVA, FECHADA, PAGA }
