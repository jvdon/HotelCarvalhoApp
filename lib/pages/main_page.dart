import 'dart:async';

import 'package:carvalho/db/room_db.dart';
import 'package:carvalho/models/room.dart';
import 'package:carvalho/pages/checkin_page.dart';
import 'package:carvalho/partials/roomItem.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

RoomDB db = RoomDB();
Future<List<Room>> rooms = db.reservas();
int valorTotal = 0;

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rooms = db.reservas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text("Hotel Carvalho"),
          subtitle: Text("Valor Total: $valorTotal"),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                rooms = db.reservas();
                valorTotal = 0;
                rooms.then((value) {
                  value.forEach((element) {
                    valorTotal += element.valor;
                  });
                });
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.plus_one),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CheckinPage()));
        },
      ),
      body: FutureBuilder<List<Room>>(
        future: rooms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Column(
                children: [
                  Icon(Icons.error_outline_outlined),
                  Text("Error fetching data"),
                ],
              );
            } else {
              List<Room> rooms = snapshot.data!;
              valorTotal = 0;

              return ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  Room room = rooms[index];

                  valorTotal += room.valor;

                  return RoomItem(room: room);
                },
              );
            }
          } else {
            return const Column(
              children: [
                Icon(Icons.question_mark),
                Text("Unknown State"),
              ],
            );
          }
        },
      ),
    );
  }
}
