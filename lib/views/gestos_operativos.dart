import 'package:flutter/material.dart';

class GestosPage extends StatefulWidget {
  const GestosPage({super.key});

  @override
  State<GestosPage> createState() => _RubrosPageState();
}

class _RubrosPageState extends State<GestosPage> {
  // Variables para el formulario
  String? _rubroSeleccionado;
  final TextEditingController _cantidadDineroController =
      TextEditingController();
  final TextEditingController _cantidadLitrosController =
      TextEditingController();

  // Lista de rubros de ejemplo
  final List<String> _rubros = [
    'Gasolina Regular',
    'Gasolina Premium',
    'Diesel',
    'Gas Licuado',
    'Gas Natural',
    'Aditivos',
    'Lubricantes',
  ];

  // Lista para almacenar los rubros agregados
  final List<Map<String, dynamic>> _rubrosAgregados = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Formulario para agregar rubros
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Selector de Rubro
                    DropdownButtonFormField<String>(
                      value: _rubroSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Rubro',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      items:
                          _rubros.map((String rubro) {
                            return DropdownMenuItem<String>(
                              value: rubro,
                              child: Text(rubro),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _rubroSeleccionado = newValue;
                        });
                      },
                      hint: const Text('Seleccione un rubro'),
                    ),
                    const SizedBox(height: 16),

                    // Cantidad en dinero
                    TextFormField(
                      controller: _cantidadDineroController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad (\$)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Cantidad en litros
                    TextFormField(
                      controller: _cantidadLitrosController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad (Litros)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.water_drop),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Botones de acción
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _agregarRubro,
                          icon: const Icon(Icons.add),
                          label: const Text('Agregar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _eliminarUltimo,
                          icon: const Icon(Icons.delete),
                          label: const Text('Eliminar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Lista de rubros agregados
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      _rubrosAgregados.isEmpty
                          ? const Center(
                            child: Text(
                              'No hay rubros agregados',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                          : ListView.builder(
                            itemCount: _rubrosAgregados.length,
                            itemBuilder: (context, index) {
                              final rubro = _rubrosAgregados[index];
                              return ListTile(
                                leading: const Icon(Icons.local_gas_station),
                                title: Text(rubro['nombre']),
                                subtitle: Text(
                                  '\$${rubro['dinero']} - ${rubro['litros']} L',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _eliminarRubro(index),
                                ),
                              );
                            },
                          ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Botones inferiores
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _enviarDatos,
                    icon: const Icon(Icons.send),
                    label: const Text('Enviar'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _descargarRubros,
                    icon: const Icon(Icons.download),
                    label: const Text('Descargar Rubros'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _agregarRubro() {
    if (_rubroSeleccionado == null ||
        _cantidadDineroController.text.isEmpty ||
        _cantidadLitrosController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor complete todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _rubrosAgregados.add({
        'nombre': _rubroSeleccionado!,
        'dinero': _cantidadDineroController.text,
        'litros': _cantidadLitrosController.text,
      });

      // Limpiar los campos después de agregar
      _cantidadDineroController.clear();
      _cantidadLitrosController.clear();
      _rubroSeleccionado = null;
    });
  }

  void _eliminarUltimo() {
    if (_rubrosAgregados.isEmpty) return;

    setState(() {
      _rubrosAgregados.removeLast();
    });
  }

  void _eliminarRubro(int index) {
    setState(() {
      _rubrosAgregados.removeAt(index);
    });
  }

  void _enviarDatos() {
    if (_rubrosAgregados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay rubros para enviar'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Aquí iría la lógica para enviar los datos
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Enviando ${_rubrosAgregados.length} rubros...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _descargarRubros() {
    // Aquí iría la lógica para descargar rubros
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Descargando lista de rubros...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  void dispose() {
    _cantidadDineroController.dispose();
    _cantidadLitrosController.dispose();
    super.dispose();
  }
}
