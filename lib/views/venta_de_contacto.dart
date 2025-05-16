import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
  final TextEditingController _cantidadController = TextEditingController(
    text: '1',
  );
  final TextEditingController _comentarioController = TextEditingController();

  final List<Map<String, dynamic>> _allProductos = [
    {
      'clave': 'P001',
      'producto': 'Producto 1',
      'precio': 100.0,
      'existencia': 10,
    },
    {
      'clave': 'P002',
      'producto': 'Sabritas de papas con cl 2',
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

  List<Map<String, dynamic>> _productosFiltrados = [];
  Map<String, dynamic>? _productoSeleccionado;
  String _tipoMovimiento = 'Venta';
  double _cantidad = 1.0;
  List<Map<String, dynamic>> _productosAgregados = [];
  String _comentario = '';

  @override
  void initState() {
    super.initState();
    _productoSearchController.addListener(_buscarProducto);
  }

  @override
  void dispose() {
    _productoSearchController.removeListener(_buscarProducto);
    _productoSearchController.dispose();
    _cantidadController.dispose();
    _comentarioController.dispose();
    super.dispose();
  }

  void _buscarProducto() {
    final query = _productoSearchController.text.toLowerCase();
    setState(() {
      _productosFiltrados =
          query.isEmpty
              ? []
              : _allProductos.where((producto) {
                return producto['clave'].toString().toLowerCase().contains(
                      query,
                    ) ||
                    producto['producto'].toString().toLowerCase().contains(
                      query,
                    );
              }).toList();
    });
  }

  void _agregarProducto() {
    if (_productoSeleccionado == null || _cantidad <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona un producto y una cantidad válida'),
        ),
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
      _productoSearchController.clear();
      _productoSeleccionado = null;
      _productosFiltrados = [];
      _cantidad = 1.0;
      _cantidadController.text = '1';
      _tipoMovimiento = 'Venta';
    });
  }

  double _calcularTotal() {
    return _productosAgregados.fold(0.0, (total, p) {
      final subtotal = p['precio'] * p['cantidad'];
      return total + (p['tipoMovimiento'] == 'Venta' ? subtotal : -subtotal);
    });
  }

  double _calcularTotalPorTipo(String tipo) {
    return _productosAgregados
        .where((p) => p['tipoMovimiento'] == tipo)
        .fold(0.0, (total, p) => total + (p['precio'] * p['cantidad']));
  }

  Widget _buildResumenRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(value.toString()),
        ],
      ),
    );
  }

  void _mostrarConfirmacionVenta({String? comentario}) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar venta'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cliente: ${widget.cliente['nombre']}'),
                const SizedBox(height: 10),
                Text('Total: \$${_calcularTotal().toStringAsFixed(2)}'),
                const SizedBox(height: 10),
                Text('Productos: ${_productosAgregados.length}'),
                if (comentario != null && comentario.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text('Comentario: $comentario'),
                    ],
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        comentario != null && comentario.isNotEmpty
                            ? 'Venta registrada con comentario'
                            : 'Venta registrada exitosamente',
                      ),
                    ),
                  );
                  // Aquí iría tu lógica para guardar la venta con el comentario
                },
                child: const Text('Confirmar'),
              ),
            ],
          ),
    );
  }

  Future<void> _mostrarDialogoComentario() async {
    _comentarioController.text = _comentario;

    final comentario = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Agregar comentario'),
            content: TextField(
              controller: _comentarioController,
              decoration: const InputDecoration(
                hintText: 'Ej: Venta con descuento especial...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, _comentarioController.text);
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
    );

    if (comentario != null) {
      setState(() {
        _comentario = comentario;
      });
      if (comentario.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Comentario guardado')));
      }
    }
  }

  void _mostrarDetallesProducto(Map<String, dynamic> producto) {
    final double total = producto['precio'] * producto['cantidad'];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(producto['producto']),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Movimiento', producto['tipoMovimiento']),
                _buildInfoRow('Clave', producto['clave']),
                _buildInfoRow('Cantidad', producto['cantidad']),
                _buildInfoRow(
                  'Precio',
                  '\$${producto['precio'].toStringAsFixed(2)}',
                ),
                _buildInfoRow('Descuento', '\$0.00'),
                _buildInfoRow('Total', '\$${total.toStringAsFixed(2)}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cliente = widget.cliente;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Venta de contado - ${cliente['nombre']}'),
        backgroundColor: Colors.orange, // Esto pone el fondo naranja
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información del cliente
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Folio: 001',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow('Clave', cliente['clave']),
                      _buildInfoRow('Cliente', cliente['nombre']),
                      _buildInfoRow('Límite C.', cliente['limiteCredito']),
                      _buildInfoRow('Saldo', cliente['saldo']),
                      _buildInfoRow('Tipo venta', cliente['tipo venta']),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Buscador
              Text('Buscar producto', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _productoSearchController,
                decoration: InputDecoration(
                  labelText: 'Clave o nombre del producto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              if (_productosFiltrados.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _productosFiltrados.length,
                  itemBuilder: (context, index) {
                    final producto = _productosFiltrados[index];
                    return ListTile(
                      title: Text(producto['producto']),
                      subtitle: Text(
                        'Clave: ${producto['clave']} - \$${producto['precio']}',
                      ),
                      trailing: const Icon(Icons.add),
                      onTap: () {
                        setState(() {
                          _productoSeleccionado = producto;
                          _productosFiltrados = [];
                          _productoSearchController.text = producto['producto'];
                        });
                      },
                    );
                  },
                ),

              if (_productoSeleccionado != null) ...[
                const SizedBox(height: 12),
                Text('Tipo de movimiento', style: theme.textTheme.titleSmall),
                DropdownButton<String>(
                  value: _tipoMovimiento,
                  isExpanded: true,
                  items:
                      ['Venta', 'Devolución', 'Cambio']
                          .map(
                            (tipo) => DropdownMenuItem(
                              value: tipo,
                              child: Text(tipo),
                            ),
                          )
                          .toList(),
                  onChanged:
                      (value) => setState(() => _tipoMovimiento = value!),
                ),
                const SizedBox(height: 8),
                Text('Cantidad', style: theme.textTheme.titleSmall),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cantidadController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Cantidad',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _cantidad =
                                double.tryParse(value.replaceAll(',', '.')) ??
                                1.0;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _agregarProducto,
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar'),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 20),

              // Resumen
              Card(
                color: Colors.grey[100],
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildResumenRow(
                        'Total venta',
                        '\$${_calcularTotal().toStringAsFixed(2)}',
                        theme,
                      ),
                      _buildResumenRow(
                        'Total productos',
                        '${_productosAgregados.length}',
                        theme,
                      ),
                      _buildResumenRow(
                        'Total devolución',
                        '\$${_calcularTotalPorTipo("Devolución").toStringAsFixed(2)}',
                        theme,
                      ),
                      _buildResumenRow('Descuento', '\$0.00', theme),
                      if (_comentario.isNotEmpty)
                        _buildResumenRow('Comentario', _comentario, theme),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              if (_productosAgregados.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Productos agregados',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _productosAgregados.length,
                      itemBuilder: (context, index) {
                        final producto = _productosAgregados[index];
                        return Card(
                          child: ListTile(
                            title: Text(producto['producto']),
                            subtitle: const Text('Toca para ver detalles'),
                            onTap: () => _mostrarDetallesProducto(producto),
                          ),
                        );
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        backgroundColor: theme.primaryColor,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.send, color: Colors.white),
            backgroundColor:
                Colors.green, // cambiar el color del icono de enviar
            label: 'Enviar',
            onTap: () {
              if (_productosAgregados.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Agrega productos primero')),
                );
                return;
              }
              _mostrarConfirmacionVenta(comentario: _comentario);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.comment, color: Colors.white),
            backgroundColor:
                Colors.blue, // cambiar el color del icono de comentario
            label: 'Agregar comentario',
            onTap: _mostrarDialogoComentario,
          ),
        ],
      ),
    );
  }
}
