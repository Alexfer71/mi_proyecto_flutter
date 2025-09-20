import 'package:flutter/material.dart';
import 'screens/productos_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tienda',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProductosList(),
    );
  }
}
