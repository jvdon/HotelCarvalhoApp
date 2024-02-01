// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:carvalho/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  Supabase supabase = await Supabase.initialize(
      url: 'https://ykyaeveulcnoqpfsmtzg.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlreWFldmV1bGNub3FwZnNtdHpnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDM4ODQzMDUsImV4cCI6MjAxOTQ2MDMwNX0.39wNANEJ3TRmmScLMLNNtbXw19X1we9n8N6wo6xl07g',
      authOptions:
          FlutterAuthClientOptions(authFlowType: AuthFlowType.implicit));

  await supabase.client.auth.signInWithPassword(
      email: 'carvalho.hotel@gmail.com', password: '35551441');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      title: "Hotel Carvalho",
      home: MainPage(),
    );
  }
}
