import 'package:carvalho/db/room_db.dart';
import 'package:carvalho/models/hospede.dart';
import 'package:carvalho/models/room.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CheckinPage extends StatefulWidget {
  const CheckinPage({super.key});

  @override
  State<CheckinPage> createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  GlobalKey _key = GlobalKey();
  RoomDB db = RoomDB();

  TextEditingController roomNumber = TextEditingController();
  DateTime? checkin;
  DateTime? checkout;
  RoomStatus status = RoomStatus.ocupado;
  List<Hospede> hospedes = [];
  TextEditingController preco = TextEditingController(text: "50");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hotel Carvalho - Check-in"),
      ),
      body: Form(
        key: _key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              controller: roomNumber,
              decoration: const InputDecoration(
                  label: Text("Numero do quarto"),
                  border: OutlineInputBorder()),
              validator: (value) {
                return (value == null || value.isEmpty)
                    ? 'Campo Obrigatório'
                    : null;
              },
            ),
            _buildCheckIn(),
            _buildCheckOut(),
            Container(
              width: double.infinity,
              height: 130,
              child: ListView.builder(
                itemCount: hospedes.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  Hospede hospede = hospedes[index];
                  return Container(
                    width: 150,
                    height: 130,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.black12),
                      shape: BoxShape.rectangle,
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.person),
                        Text(hospede.nome),
                        Text(hospede.idade.toString()),
                        Text(hospede.cpf),
                        IconButton(
                          onPressed: () {
                            setState(
                              () {
                                hospedes.remove(hospede);
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_reaction_sharp),
              iconSize: 64,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return _hospedeForm();
                  },
                );
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [],
              controller: preco,
              decoration: const InputDecoration(
                  label: Text("Preço por pessoa/noite"),
                  border: OutlineInputBorder()),
              validator: (value) {
                return (value == null || value.isEmpty)
                    ? 'Campo Obrigatório'
                    : null;
              },
            ),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(color: Colors.deepPurple[700]!),
              child: IconButton(
                icon: const Icon(Icons.add),
                iconSize: 64,
                onPressed: () {
                  FormState state = _key.currentState as FormState;
                  if (state.validate() &&
                      checkin != null &&
                      checkout != null &&
                      hospedes.isNotEmpty) {
                    db.reservas().then((value) {
                      Room room = Room(
                          id: value.length + 1,
                          number: int.parse(roomNumber.text),
                          checkin: checkin!,
                          checkout: checkout!,
                          status: status,
                          hospedes: hospedes);

                      db.insertRoom(room);
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Preencha todos os campos!")));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCheckIn() {
    return ListTile(
      leading: const Icon(Icons.calendar_month, size: 48),
      title: const Text("Check-In"),
      subtitle: Text((checkin != null)
          ? DateFormat('dd/MM/yyyy').format(checkin!)
          : "Data de Check-In"),
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 60)),
          confirmText: "Confirmar",
          helpText: "Data de check-in",
        ).then((value) {
          setState(() {
            if (value != null) {
              checkin = value;
            }
          });
        });
      },
    );
  }

  Widget _buildCheckOut() {
    return ListTile(
      leading: const Icon(Icons.calendar_month, size: 48),
      title: const Text("Check-Out"),
      subtitle: Text((checkout != null)
          ? DateFormat('dd/MM/yyyy').format(checkout!)
          : "Data de Check-In"),
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 60)),
          confirmText: "Confirmar",
          helpText: "Data de check-in",
        ).then((value) {
          setState(() {
            if (value != null) {
              checkout = value;
            }
          });
        });
      },
    );
  }

  Widget _hospedeForm() {
    GlobalKey _key = GlobalKey();
    TextEditingController nome = TextEditingController();
    TextEditingController cpf = TextEditingController();
    TextEditingController idade = TextEditingController();

    final maskCpf = MaskTextInputFormatter(
        mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});

    return Dialog(
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        side: BorderSide(color: Colors.deepPurple),
      ),
      child: Container(
        width: 500,
        height: 400,
        child: Form(
          key: _key,
          child: Column(
            children: [
              const SizedBox(height: 15),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: nome,
                decoration: const InputDecoration(
                    label: Text("Nome do Hospede"),
                    border: OutlineInputBorder()),
                validator: (value) {
                  return (value == null || value.isEmpty)
                      ? 'Campo Obrigatório'
                      : null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: idade,
                decoration: const InputDecoration(
                    label: Text("Idade do Hospede"),
                    border: OutlineInputBorder()),
                validator: (value) {
                  return (value == null || value.isEmpty)
                      ? 'Campo Obrigatório'
                      : null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [maskCpf],
                controller: cpf,
                decoration: const InputDecoration(
                    label: Text("CPF do Hospede"),
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value != null) {
                    String cpfRegex =
                        r"[0-9]{3}\.?[0-9]{3}\.?[0-9]{3}\-?[0-9]{2}";
                    if (!RegExp(cpfRegex).hasMatch(value)) {
                      return "CPF invalido";
                    } else {
                      return null;
                    }
                  } else {
                    return "Campo Obriatorio";
                  }
                },
              ),
              IconButton(
                icon: const Column(
                  children: [
                    Icon(Icons.add),
                    Text("Cadastrar"),
                  ],
                ),
                onPressed: () {
                  FormState state = _key.currentState! as FormState;
                  if (state.validate()) {
                    setState(() {
                      hospedes.add(
                        Hospede(
                          nome: nome.text,
                          cpf: cpf.text,
                          idade: int.tryParse(idade.text) ?? -1,
                        ),
                      );
                      Navigator.of(this.context).pop();
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
