import 'package:flutter/material.dart';

// Pantalla de gestión de rubros (combustibles, aditivos, etc.)
class GestosPage extends StatefulWidget {
  const GestosPage({super.key});

  @override
  State<GestosPage> createState() => _RubrosPageState();
}

class _RubrosPageState extends State<GestosPage> {
  // ------------------ VARIABLES ------------------

  // Rubro seleccionado actualmente en el formulario
  String? _rubroSeleccionado;

  // Controladores para los campos de cantidad de dinero y litros
  final TextEditingController _cantidadDineroController =
      TextEditingController();
  final TextEditingController _cantidadLitrosController =
      TextEditingController();

  // Lista fija de opciones de rubros
  final List<String> _rubros = [
    'Gasolina Regular',
    'Gasolina Premium',
    'Diesel',
    'Gas Licuado',
    'Gas Natural',
    'Aditivos',
    'Lubricantes',
  ];

  // Lista de rubros agregados dinámicamente por el usuario
  final List<Map<String, dynamic>> _rubrosAgregados = [];

  // ------------------ UI PRINCIPAL ------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ----------- FORMULARIO DE INGRESO DE RUBROS -----------
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Dropdown para seleccionar un rubro
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

                    // Campo de cantidad en dinero
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

                    // Botones para agregar y eliminar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _agregarRubro,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                          ),
                          child: const Icon(Icons.add),
                        ),

                        ElevatedButton(
                          onPressed: _eliminarUltimo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                          ),
                          child: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ----------- LISTA DE RUBROS AGREGADOS -----------
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

            // ----------- BOTONES INFERIORES -----------
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _enviarDatos,
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

  // ------------------ FUNCIONES DE LÓGICA ------------------

  // Agrega el rubro a la lista si todos los campos están completos
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

      // Limpiar campos después de agregar
      _cantidadDineroController.clear();
      _cantidadLitrosController.clear();
      _rubroSeleccionado = null;
    });
  }

  // Elimina el último rubro de la lista
  void _eliminarUltimo() {
    if (_rubrosAgregados.isEmpty) return;

    setState(() {
      _rubrosAgregados.removeLast();
    });
  }

  // Elimina un rubro específico de la lista
  void _eliminarRubro(int index) {
    setState(() {
      _rubrosAgregados.removeAt(index);
    });
  }

  // Simula el envío de datos
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

    // Aquí podría ir una petición HTTP, etc.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Enviando ${_rubrosAgregados.length} rubros...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Simula descarga de los rubros (PDF, Excel, etc.)
  void _descargarRubros() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Descargando lista de rubros...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Liberar controladores al destruir la pantalla
  @override
  void dispose() {
    _cantidadDineroController.dispose();
    _cantidadLitrosController.dispose();
    super.dispose();
  }
}
