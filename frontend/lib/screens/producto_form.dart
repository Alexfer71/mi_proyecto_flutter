import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// 👇 centralizamos la URL (puedes moverla a config.dart)
const String apiUrl = "http://192.168.100.5/backend/productos.php";

class ProductoForm extends StatelessWidget {
  const ProductoForm({super.key});

  Future<void> guardarProducto(
      String nombre, String descripcion, String precio, String categoriaId, BuildContext context) async {
    try {
      final body = {
        "nombre": nombre,
        "descripcion": descripcion,
        "precio": precio,
        "categoria_id": categoriaId
      };

      final res = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (res.statusCode == 200) {
        // Éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Producto guardado con éxito")),
        );
        Navigator.pop(context); // Vuelve a la lista
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error al guardar: ${res.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error de conexión: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final nombreCtrl = TextEditingController();
    final descripcionCtrl = TextEditingController();
    final precioCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Producto")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: descripcionCtrl,
              decoration: const InputDecoration(labelText: "Descripción"),
            ),
            TextField(
              controller: precioCtrl,
              decoration: const InputDecoration(labelText: "Precio"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nombreCtrl.text.isEmpty || precioCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("⚠️ Nombre y precio son obligatorios")),
                  );
                  return;
                }
                // Aquí fijo categoria_id=1 como ejemplo
                guardarProducto(
                  nombreCtrl.text,
                  descripcionCtrl.text,
                  precioCtrl.text,
                  "1", // después lo reemplazamos con Dropdown dinámico
                  context,
                );
              },
              child: const Text("Guardar"),
            )
          ],
        ),
      ),
    );
  }
}
