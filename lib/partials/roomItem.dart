// ignore_for_file: must_be_immutable

import 'package:carvalho/models/hospede.dart';
import 'package:carvalho/models/room.dart';
import 'package:carvalho/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RoomItem extends StatefulWidget {
  Room room;
  RoomItem({super.key, required this.room});

  @override
  State<RoomItem> createState() => _RoomItemState();
}

class _RoomItemState extends State<RoomItem> {


  Map<RoomStatus, Color> colors = {
    RoomStatus.pronto: Colors.green[800]!,
    RoomStatus.usado: Colors.deepOrange[700]!,
    RoomStatus.ocupado: Colors.red[800]!,
  };
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Column(
        children: [
          const Icon(Icons.hotel),
          Text(widget.room.number.toString(),
              style: GoogleFonts.openSans(fontSize: 16)),
        ],
      ),
      trailing: GestureDetector(
        child: CircleAvatar(
            backgroundColor: colors[widget.room.status], radius: 15),
        onLongPress: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(widget.room.status.name)));
        },
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
                    return Divider(color: Colors.deepPurple,);
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
