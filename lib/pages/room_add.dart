import 'package:carvalho/db/room_db.dart';
import 'package:carvalho/models/room.dart';
import 'package:flutter/material.dart';

class RoomAdd extends StatefulWidget {
  const RoomAdd({super.key});

  @override
  State<RoomAdd> createState() => _RoomAddState();
}

class _RoomAddState extends State<RoomAdd> {
  @override
  Widget build(BuildContext context) {
    TextEditingController roomNumber = TextEditingController();
    RoomStatus status = RoomStatus.pronto;
    GlobalKey formKey = GlobalKey();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Room registration page"),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              controller: roomNumber,
              decoration: const InputDecoration(
                  label: Text("Numero do quarto"),
                  border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }
                return null;
              },
            ),
            DropdownMenu(
              width: MediaQuery.of(context).size.width,
              menuStyle: MenuStyle(alignment: Alignment.center),
              onSelected: (value) {
                if (value != null) {
                  status = value;
                }
              },
              dropdownMenuEntries: RoomStatus.values
                  .map((e) => DropdownMenuEntry(value: e, label: e.name))
                  .toList(),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                FormState state = formKey.currentState as FormState;
                if (state.validate()) {
                  List rooms = await RoomDB().quartos();

                  RoomDB().insertRoom(Room(
                      // id: rooms.length + 1,
                      number: int.parse(roomNumber.text),
                      status: status));
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
