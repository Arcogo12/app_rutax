import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

/// Pantalla para realizar una venta de contado a un cliente específico.
/// Permite buscar productos, seleccionar tipo de movimiento, cantidad y agregar al carrito.
class VentaDeContactoPage extends StatefulWidget {
  final Map<String, dynamic> cliente;

  const VentaDeContactoPage({Key? key, required this.cliente})
    : super(key: key);

  @override
  State<VentaDeContactoPage> createState() => _VentaDeContactoPageState();
}

class _VentaDeContactoPageState extends State<VentaDeContactoPage> {
  final TextEditingController _productoSearchController =
      TextEditingController();

  // Lista de productos disponibles (simulación de inventario)
  final List<Map<String, dynamic>> _allProductos = [
    {
      'clave': 'P001',
      'producto': 'Producto 1',
      'precio': 100.0,
      'existencia': 10,
    },
    {
      'clave': 'P002',
      'producto': 'Producto 2',
      'precio': 200.0,
      'existencia': 5,
    },
    {
      'clave': 'P003',
      'producto': 'Producto 3',
      'precio': 150.0,
      'existencia': 0,
    },
  ];

  Map<String, dynamic>?
  _productoSeleccionado; // Producto actualmente buscado/seleccionado
  String _tipoMovimiento = 'Venta'; // Puede ser: Venta, Devolución, Cambio
  int _cantidad = 1;

  List<Map<String, dynamic>> _productosAgregados =
      []; // Lista de productos en el "carrito"

  @override
  void initState() {
    super.initState();
    _productoSearchController.addListener(_buscarProducto);
  }

  @override
  void dispose() {
    _productoSearchController.removeListener(_buscarProducto);
    _productoSearchController.dispose();
    super.dispose();
  }

  /// Busca un producto por clave o nombre según lo que se escribe en el buscador
  void _buscarProducto() {
    final query = _productoSearchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _productoSeleccionado = null;
      } else {
        _productoSeleccionado = _allProductos.firstWhere(
          (producto) =>
              producto['clave'].toString().toLowerCase().contains(query) ||
              producto['producto'].toString().toLowerCase().contains(query),
          orElse: () => {},
        );
        // Si no se encuentra ningún producto
        if (_productoSeleccionado!.isEmpty) {
          _productoSeleccionado = null;
        }
      }
    });
  }

  /// Agrega el producto seleccionado a la lista de productos agregados (carrito)
  void _agregarProducto() {
    if (_productoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un producto primero')),
      );
      return;
    }
    if (_cantidad <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cantidad debe ser mayor a 0')),
      );
      return;
    }

    final nuevoProducto = {
      'clave': _productoSeleccionado!['clave'],
      'producto': _productoSeleccionado!['producto'],
      'precio': _productoSeleccionado!['precio'],
      'existencia': _productoSeleccionado!['existencia'],
      'tipoMovimiento': _tipoMovimiento,
      'cantidad': _cantidad,
    };

    setState(() {
      _productosAgregados.add(nuevoProducto);
      // Resetear valores tras agregar
      _productoSearchController.clear();
      _productoSeleccionado = null;
      _cantidad = 1;
      _tipoMovimiento = 'Venta';
    });
  }

  @override
  Widget build(BuildContext context) {
    final cliente = widget.cliente;

    return Scaffold(
      appBar: AppBar(title: Text('Venta de contado - ${cliente['nombre']}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información básica del cliente
              Text(
                'Folio: 001',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Clave: ${cliente['clave']}'),
              Text('Cliente: ${cliente['nombre']}'),
              Text('Límite C.: ${cliente['limiteCredito']}'),
              Text('Saldo: ${cliente['saldo']}'),
              Text('Tipo de venta: ${cliente['tipoVenta']}'),
              const SizedBox(height: 20),

              // Campo de búsqueda por clave o nombre del producto
              TextField(
                controller: _productoSearchController,
                decoration: const InputDecoration(
                  labelText: 'Buscar por Clave/Producto',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),

              const SizedBox(height: 20),

              // Mostrar información del producto seleccionado
              if (_productoSeleccionado != null) ...[
                Text(
                  'Clave: ${_productoSeleccionado!['clave']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Producto: ${_productoSeleccionado!['producto']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Precio: \$${_productoSeleccionado!['precio']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Existencia: ${_productoSeleccionado!['existencia']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Dropdown para seleccionar tipo de movimiento
                DropdownButton<String>(
                  value: _tipoMovimiento,
                  items: const [
                    DropdownMenuItem(value: 'Venta', child: Text('Venta')),
                    DropdownMenuItem(
                      value: 'Devolución',
                      child: Text('Devolución'),
                    ),
                    DropdownMenuItem(value: 'Cambio', child: Text('Cambio')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _tipoMovimiento = value;
                      });
                    }
                  },
                ),

                const SizedBox(height: 12),

                // Campo para ingresar la cantidad
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    initialValue: _cantidad.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _cantidad = int.tryParse(val) ?? 1;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Botón para agregar producto a la lista
                ElevatedButton.icon(
                  onPressed: _agregarProducto,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar Producto'),
                ),
              ] else
                const SizedBox(height: 20),

              const Divider(height: 40),

              // Lista de productos ya agregados
              Text(
                'Productos agregados:',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              if (_productosAgregados.isEmpty)
                const Text('No hay productos agregados')
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _productosAgregados.length,
                  itemBuilder: (context, index) {
                    final p = _productosAgregados[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text('${p['producto']} (${p['clave']})'),
                        subtitle: Text(
                          'Precio: \$${p['precio']} - Cantidad: ${p['cantidad']} - Tipo: ${p['tipoMovimiento']}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _productosAgregados.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),

      // Botón flotante con acciones rápidas (SpeedDial)
      floatingActionButton: SpeedDial(
        icon: Icons.more_vert,
        activeIcon: Icons.close,
        backgroundColor: Colors.blue,
        activeBackgroundColor: Colors.redAccent,
        spacing: 12,
        spaceBetweenChildren: 12,
        children: [
          // Opción: Enviar
          SpeedDialChild(
            child: const Icon(Icons.send, color: Colors.white),
            backgroundColor: Colors.green,
            label: 'Enviar',
            labelStyle: const TextStyle(fontSize: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opción Enviar seleccionada')),
              );
              // Lógica para enviar el reporte aquí
            },
          ),
          // Opción: Comentario
          SpeedDialChild(
            child: const Icon(Icons.comment, color: Colors.white),
            backgroundColor: Colors.orange,
            label: 'Comentario',
            labelStyle: const TextStyle(fontSize: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opción Comentario seleccionada')),
              );
              // Lógica para comentario aquí
            },
          ),
        ],
      ),
    );
  }
}
