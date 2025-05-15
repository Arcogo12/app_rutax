import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportesPage extends StatefulWidget {
  const ReportesPage({super.key});

  @override
  State<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {
  DateTime _selectedDate = DateTime.now();
  int _selectedTab = 0; // 0 = Ventas, 1 = Precargas

  // Valores de ejemplo para los campos
  final int total = 120; // Total
  final int clientesPendientesCoords = 50; // Clientes pendientes coords
  final int clientesNuevosPendientes = 30; // Clientes nuevos pendientes

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
                      Navigator.of(context).pop();
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

  String get formattedDate {
    return DateFormat('dd/MM/yyyy').format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Pestañas centradas arriba
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTabItem('Ventas', 0),
                const SizedBox(width: 24),
                _buildTabItem('Precargas', 1),
              ],
            ),
          ),
        ),

        // Icono de calendario arriba a la derecha
        Positioned(
          top: 8,
          right: 16,
          child: IconButton(
            icon: const Icon(Icons.calendar_today, size: 28),
            tooltip: 'Seleccionar fecha',
            onPressed: () => _showCustomCalendarModal(context),
          ),
        ),

        // Fecha debajo de las pestañas
        Positioned(
          top: 70,
          left: 0,
          right: 0,
          child: Center(
            child: Text(formattedDate, style: const TextStyle(fontSize: 20)),
          ),
        ),

        // Campos debajo de la fecha
        Positioned(
          top: 120, // Posiciona los campos debajo de la fecha
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

        // Icono de enviar abajo a la izquierda
        Positioned(
          bottom: 16,
          right: 16,
          child: ElevatedButton.icon(
            onPressed: () {
              // Acción al presionar el botón de enviar
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Reporte enviado')));
            },
            label: const Text('Enviar'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              backgroundColor: Colors.orange, // Puedes cambiar el color
              foregroundColor: Colors.white, // Color del texto e ícono
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

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

  // Widget para construir cada campo con su título y valor
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
