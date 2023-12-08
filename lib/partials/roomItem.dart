// ignore_for_file: must_be_immutable

import 'package:carvalho/db/reserva_db.dart';
import 'package:carvalho/models/hospede.dart';
import 'package:carvalho/models/reserva.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RoomItem extends StatefulWidget {
  Reserva room;
  RoomItem({super.key, required this.room});

  @override
  State<RoomItem> createState() => _RoomItemState();
}

class _RoomItemState extends State<RoomItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Column(
        children: [
          const Icon(Icons.hotel),
          Text(widget.room.quarto.number.toString(),
              style: GoogleFonts.openSans(fontSize: 16)),
        ],
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total: R\$ ${widget.room.valor}"),
          Row(
            children: [
              Text("${widget.room.hospedes.length}x"),
              const Icon(Icons.person),
              const SizedBox(width: 10),
              Text("PPN R\$ ${widget.room.preco.toString()}")
            ],
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today),
              Text(DateFormat('dd/MM/yyyy').format(widget.room.checkin))
            ],
          ),
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined),
              Text(DateFormat('dd/MM/yyyy').format(widget.room.checkout))
            ],
          )
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await ReservaDB().deleteReserva(widget.room);
          setState(() {
          });
        },
      ),
      onTap: () {
        List<Hospede> hospedes = widget.room.hospedes;
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Container(
                height: 500,
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: Colors.deepPurple,
                    );
                  },
                  itemCount: hospedes.length,
                  itemBuilder: (context, index) {
                    Hospede hospede = hospedes[index];
                    return ListTile(
                      leading: Icon(Icons.person),
                      title: Text(hospede.nome),
                      subtitle: Text(hospede.cpf),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
