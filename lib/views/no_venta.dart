import 'package:flutter/material.dart';

class NoVentaPage extends StatefulWidget {
  const NoVentaPage({Key? key}) : super(key: key);

  @override
  State<NoVentaPage> createState() => _NoVentaPageState();
}

class _NoVentaPageState extends State<NoVentaPage> {
  final TextEditingController folioController = TextEditingController();
  final TextEditingController clienteController = TextEditingController();
  final TextEditingController comentarioController = TextEditingController();

  final List<String> causas = [
    'No tiene dinero',
    'Se cambió de domicilio',
    'No quiere producto hoy',
    'Todavía tiene existencias',
  ];

  String? causaSeleccionada;

  @override
  void dispose() {
    folioController.dispose();
    clienteController.dispose();
    comentarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('No Venta'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      // <- AQUÍ estaba el error
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: folioController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Folio',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        prefixIcon: const Icon(Icons.numbers),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: clienteController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Cliente',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Causa de no venta',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.info),
                      ),
                      value: causaSeleccionada,
                      items:
                          causas
                              .map(
                                (causa) => DropdownMenuItem(
                                  value: causa,
                                  child: Text(
                                    causa,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          causaSeleccionada = value;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      elevation: 4,
                      isExpanded: true,
                      hint: const Text(
                        'Selecciona una causa',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: comentarioController,
                      decoration: InputDecoration(
                        labelText: 'Observaciones adicionales',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 4,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                onPressed: () {
                  if (causaSeleccionada == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Por favor, selecciona una causa antes de enviar.',
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    );
                    return;
                  }

                  final folio = folioController.text.trim();
                  final cliente = clienteController.text.trim();
                  final comentario = comentarioController.text.trim();

                  debugPrint('Folio: $folio');
                  debugPrint('Cliente: $cliente');
                  debugPrint('Causa: $causaSeleccionada');
                  debugPrint('Comentario: $comentario');

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Formulario enviado correctamente'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Enviar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
