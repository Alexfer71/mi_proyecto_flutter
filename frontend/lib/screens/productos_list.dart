import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'producto_form.dart';

const String apiUrl = "http://192.168.100.5/backend/productos.php"; // Cambia por tu IP

class ProductosList extends StatefulWidget {
  const ProductosList({super.key});
  @override
  State<ProductosList> createState() => _ProductosListState();
}

class _ProductosListState extends State<ProductosList> {
  List productos = [];
  bool cargando = true;
  String? error;

  Future<void> fetchProductos() async {
    setState(() => cargando = true);
    try {
      final res = await http.get(Uri.parse("$apiUrl/productos.php"));
      if (res.statusCode == 200) {
        setState(() {
          productos = json.decode(res.body);
          cargando = false;
        });
      } else {
        setState(() {
          error = "Error ${res.statusCode}";
          cargando = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "Error de conexión: $e";
        cargando = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos"),
        backgroundColor: Colors.blueAccent,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
              : productos.isEmpty
                  ? const Center(child: Text("No hay productos disponibles"))
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: productos.length,
                        itemBuilder: (context, i) {
                          final p = productos[i];
                          return Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: const Icon(Icons.shopping_bag, color: Colors.blue, size: 40),
                              title: Text(
                                p["nombre"],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Text(
                                "${p["descripcion"]}\nPrecio: \$${p["precio"]}\nCategoría: ${p["categoria"]}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              isThreeLine: true,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.orange),
                                    onPressed: () {
                                      // Navegar a formulario de edición
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      final id = p["id"];
                                      final res = await http.delete(
                                        Uri.parse("$apiUrl/productos.php?id=$id"),
                                      );
                                      if (res.statusCode == 200) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Producto eliminado")),
                                        );
                                        fetchProductos(); // refresca la lista
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductoForm()),
          ).then((_) => fetchProductos()); // refresca al volver
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
