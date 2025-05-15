import 'package:flutter/material.dart';
import 'package:app_rutax/views/venta_de_contacto.dart';

/// Página principal de clientes
class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  // Controlador del campo de búsqueda
  final TextEditingController _searchController = TextEditingController();

  // Lista estática con todos los clientes
  final List<Map<String, dynamic>> _allClientes = [
    // Ejemplo de cliente
    {
      'clave': '001',
      'nombre': 'Cliente A',
      'telefono': '555-1001',
      'direccion': 'Calle 1 #123',
      'poblacion': 'Ciudad X',
      'colonia': 'Centro',
      'descuento': '10%',
      'tipoVenta': 'Contado',
      'saldo': '\$1,200',
      'limiteCredito': '\$5,000',
      'estado': 'No agendado',
    },
    // Otros clientes...
    {
      'clave': '002',
      'nombre': 'Cliente B',
      'telefono': '555-1002',
      'direccion': 'Calle 2 #456',
      'poblacion': 'Ciudad Y',
      'colonia': 'Norte',
      'descuento': '15%',
      'tipoVenta': 'Crédito',
      'saldo': '\$300',
      'limiteCredito': '\$3,000',
      'estado': 'Vendido',
    },
    {
      'clave': '003',
      'nombre': 'Cliente C',
      'telefono': '555-1003',
      'direccion': 'Calle 3 #789',
      'poblacion': 'Ciudad Z',
      'colonia': 'Sur',
      'descuento': '5%',
      'tipoVenta': 'Contado',
      'saldo': '\$0',
      'limiteCredito': '\$1,000',
      'estado': 'Agendado',
    },
  ];

  // Lista filtrada para mostrar resultados de búsqueda
  List<Map<String, dynamic>> _filteredClientes = [];

  @override
  void initState() {
    super.initState();
    // Inicializa la lista con todos los clientes
    _filteredClientes = _allClientes;
    // Añade un listener para detectar cambios en el campo de búsqueda
    _searchController.addListener(_filterClientes);
  }

  @override
  void dispose() {
    // Elimina el listener y libera el controlador
    _searchController.removeListener(_filterClientes);
    _searchController.dispose();
    super.dispose();
  }

  /// Filtra la lista de clientes según el texto del campo de búsqueda
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

  /// Devuelve los datos visuales asociados al estado del cliente
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

  /// Muestra un modal inferior con los detalles del cliente y opciones de acción
  void _mostrarDetalleCliente(Map<String, dynamic> cliente) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información del cliente
                Text("Clave: ${cliente['clave']}"),
                Text("Nombre: ${cliente['nombre']}"),
                Text("Teléfono: ${cliente['telefono']}"),
                Text("Dirección: ${cliente['direccion']}"),
                Text("Población: ${cliente['poblacion']}"),
                Text("Colonia: ${cliente['colonia']}"),
                Text("Descuento: ${cliente['descuento']}"),
                Text("Tipo de venta: ${cliente['tipoVenta']}"),
                Text("Saldo: ${cliente['saldo']}"),
                Text("Límite de crédito: ${cliente['limiteCredito']}"),
                const SizedBox(height: 16),

                // Opciones disponibles
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOpcion(
                      Icons.check_circle_outline,
                      'Venta de contacto',
                      () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => VentaDeContactoPage(cliente: cliente),
                          ),
                        );
                      },
                    ),
                    _buildOpcion(Icons.block, 'No venta', () {
                      Navigator.pop(context);
                      _showOption('No venta');
                    }),
                    _buildOpcion(Icons.alt_route, 'Ruta desde aquí', () {
                      Navigator.pop(context);
                      _showOption('Ruta desde aquí');
                    }),
                    _buildOpcion(Icons.location_on, 'Ubicación', () {
                      Navigator.pop(context);
                      _showOption('Ubicación del cliente');
                    }),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  /// Construye una opción con ícono y etiqueta para el modal inferior
  Widget _buildOpcion(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        IconButton(onPressed: onTap, icon: Icon(icon, size: 30)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  /// Muestra un snackbar con la opción seleccionada
  void _showOption(String option) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Seleccionaste: $option')));
  }

  /// Construcción visual de la página
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Campo de búsqueda
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
                    onTap: () => _mostrarDetalleCliente(cliente),
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
