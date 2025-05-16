import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Pantalla principal de reportes con selección de fecha,
/// pestañas (Ventas y Precargas) y resumen de datos.
class ReportesPage extends StatefulWidget {
  const ReportesPage({super.key});

  @override
  State<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {
  // Fecha seleccionada en el calendario, por defecto es la actual
  DateTime _selectedDate = DateTime.now();

  // Índice de la pestaña seleccionada: 0 = Ventas, 1 = Precargas
  int _selectedTab = 0;

  // Datos de ejemplo que se mostrarán en los campos
  final int total = 120;
  final int clientesPendientesCoords = 50;
  final int clientesNuevosPendientes = 30;

  /// Muestra un diálogo modal personalizado con un selector de fecha (calendario)
  void _showCustomCalendarModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Material(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CalendarDatePicker(
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    onDateChanged: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                      Navigator.of(context).pop(); // Cierra el modal
                    },
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Devuelve la fecha seleccionada en formato dd/MM/yyyy
  String get formattedDate => DateFormat('dd/MM/yyyy').format(_selectedDate);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            tooltip: 'Seleccionar fecha',
            onPressed: () => _showCustomCalendarModal(context),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Pestañas de selección
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabItem('Ventas', 0),
                const SizedBox(width: 24),
                _buildTabItem('Precargas', 1),
              ],
            ),
            const SizedBox(height: 12),

            // Muestra la fecha seleccionada
            Text(formattedDate, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 24),

            // Campos de datos
            _buildField('Total', total.toString()),
            _buildField(
              'Clientes pendientes coords',
              clientesPendientesCoords.toString(),
            ),
            _buildField(
              'Clientes nuevos pendientes',
              clientesNuevosPendientes.toString(),
            ),
          ],
        ),
      ),

      // Botón flotante de acción (enviar reporte)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Reporte enviado')));
        },
        icon: const Icon(Icons.send),
        label: const Text('Enviar'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  /// Construye un ítem de pestaña con estilo seleccionado/deseleccionado
  Widget _buildTabItem(String title, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 60,
            color: isSelected ? Colors.blue : Colors.transparent,
          ),
        ],
      ),
    );
  }

  /// Construye un campo con título y valor alineados horizontalmente
  Widget _buildField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
