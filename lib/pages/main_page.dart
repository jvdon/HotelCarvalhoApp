import 'package:carvalho/pages/reservas_page.dart';
import 'package:carvalho/pages/rooms_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currId = 0;
  List<Widget> pages = [ReservasPage(), RoomsPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hotel Carvalho - Management",
            textAlign: TextAlign.center),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            currId = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Reservas"),
          BottomNavigationBarItem(icon: Icon(Icons.bed), label: "Quartos"),
        ],
      ),
      body: pages[currId],
    );
  }
}
