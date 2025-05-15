import 'package:flutter/material.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  // Controlador para la barra de búsqueda
  final TextEditingController _searchController = TextEditingController();
  // Lista original de clientes
  final List<Map<String, dynamic>> _allClientes = [
    {'nombre': 'Cliente A', 'estado': 'No agendado', 'telefono': '555-1001'},
    {'nombre': 'Cliente B', 'estado': 'Vendido', 'telefono': '555-1002'},
    {'nombre': 'Cliente C', 'estado': 'Agendado', 'telefono': '555-1003'},
    {'nombre': 'Cliente D', 'estado': 'No agendado', 'telefono': '555-1004'},
    {'nombre': 'Cliente E', 'estado': 'Vendido', 'telefono': '555-1005'},
    {'nombre': 'Cliente F', 'estado': 'Agendado', 'telefono': '555-1006'},
  ];
  // Lista filtrada que se mostrará
  List<Map<String, dynamic>> _filteredClientes = [];

  @override
  void initState() {
    super.initState();
    _filteredClientes = _allClientes;
    _searchController.addListener(_filterClientes);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterClientes);
    _searchController.dispose();
    super.dispose();
  }

  // Método para filtrar clientes según el texto de búsqueda
  void _filterClientes() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredClientes =
          _allClientes.where((cliente) {
            final nombre = cliente['nombre'].toString().toLowerCase();
            return nombre.contains(query);
          }).toList();
    });
  }

  // Método para obtener los datos visuales según el estado
  Map<String, dynamic> _getEstadoData(String estado) {
    switch (estado) {
      case 'No agendado':
        return {
          'icon': Icons.cancel_outlined,
          'color': Colors.red.shade700,
          'bgColor': Colors.red.shade50,
        };
      case 'Vendido':
        return {
          'icon': Icons.check_circle_outlined,
          'color': Colors.green.shade700,
          'bgColor': Colors.green.shade50,
        };
      case 'Agendado':
        return {
          'icon': Icons.calendar_today_outlined,
          'color': Colors.blue.shade700,
          'bgColor': Colors.blue.shade50,
        };
      default:
        return {
          'icon': Icons.help_outline,
          'color': Colors.grey.shade700,
          'bgColor': Colors.grey.shade50,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          // Lista de clientes
          Expanded(
            child: ListView.builder(
              itemCount: _filteredClientes.length,
              itemBuilder: (context, index) {
                final cliente = _filteredClientes[index];
                final estadoData = _getEstadoData(cliente['estado']);

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: estadoData['bgColor'],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        estadoData['icon'],
                        color: estadoData['color'],
                      ),
                    ),
                    title: Text(
                      cliente['nombre'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(cliente['telefono']),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: estadoData['bgColor'],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        cliente['estado'],
                        style: TextStyle(
                          color: estadoData['color'],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
