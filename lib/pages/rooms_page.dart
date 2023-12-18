import 'package:carvalho/db/room_db.dart';
import 'package:carvalho/models/room.dart';
import 'package:carvalho/pages/room_add.dart';
import 'package:flutter/material.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

RoomDB db = RoomDB();
Future<List<Room>> rooms = db.quartos();

Map<RoomStatus, Color> colors = {
  RoomStatus.pronto: Colors.green[800]!,
  RoomStatus.usado: Colors.deepOrange[700]!,
  RoomStatus.ocupado: Colors.red[800]!,
};

class _RoomsPageState extends State<RoomsPage> {
  @override
  void initState() {
    super.initState();
    rooms = RoomDB().quartos();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Room>>(
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
            List<Room> quartos = snapshot.data!;

            return Scaffold(
              appBar: AppBar(
                title: Text(
                    "Disponíveis: ${quartos.where((element) => element.status == RoomStatus.pronto).toList().length}"),
                actions: [
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {
                        rooms = db.quartos();
                      });
                    },
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.plus_one),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const RoomAdd()));
                },
              ),
              body: ListView.builder(
                itemCount: quartos.length,
                itemBuilder: (context, index) {
                  Room room = quartos[index];

                  return ListTile(
                    title: Text(room.number.toString()),
                    subtitle: Row(
                      children: [Text("${room.size}x"), Icon(Icons.person)],
                    ),
                    leading: GestureDetector(
                      child: CircleAvatar(
                          backgroundColor: colors[room.status], radius: 15),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(room.status.name)));
                      },
                      onLongPress: () {
                        RoomDB().updateStatus(room.number, RoomStatus.pronto);
                        setState(() {
                          rooms = RoomDB().quartos();
                        });
                      },
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        RoomDB().deleteRoom(room.number);
                        setState(() {
                          rooms = RoomDB().quartos();
                        });
                      },
                    ),
                  );
                },
              ),
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
    );
  }
}
