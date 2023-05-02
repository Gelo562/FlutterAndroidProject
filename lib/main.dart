import 'package:flutter/material.dart';
import 'package:projekt2/list_of_phones_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ListOfPhonesPage(),
    );
  }
}
