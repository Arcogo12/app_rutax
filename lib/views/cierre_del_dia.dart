import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CierrePage extends StatefulWidget {
  const CierrePage({super.key});

  @override
  State<CierrePage> createState() => _CierrePageState();
}

class _CierrePageState extends State<CierrePage> {
  final TextEditingController _totalEfectivoController =
      TextEditingController();

  double _sobrante = 0.0;
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String get formattedDate {
    return DateFormat('EEEE dd/MM/yyyy', 'es').format(_selectedDate);
  }

  void _calcularSobrante() {
    final efectivo = double.tryParse(_totalEfectivoController.text) ?? 0;
    setState(() {
      _sobrante = efectivo - 1000;
    });
  }

  void _showComprobanteOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.preview, color: Colors.blue),
                title: const Text('Visualizar'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Visualizando comprobante')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.green),
                title: const Text('WhatsApp'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enviando por WhatsApp')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.done, color: Colors.red),
                title: const Text('Terminar'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Proceso terminado')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: const Icon(
                          Icons.calendar_today,
                          size: 30,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Resumen del Día',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 8),
              _buildResumenTable(),

              const SizedBox(height: 24),

              const Text(
                'Total de Cierre',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 8),
              _buildTotalCierre(),

              const SizedBox(height: 24),

              _buildDocumentosPendientes(),

              const SizedBox(height: 72),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.orange,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        spacing: 12,
        tooltip: 'Opciones',
        children: [
          SpeedDialChild(
            child: const Icon(Icons.send, color: Colors.white),
            backgroundColor: Colors.green,
            label: 'Guardar',
            labelStyle: const TextStyle(fontSize: 16),
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Reporte enviado')));
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.receipt, color: Colors.white),
            backgroundColor: Colors.blue,
            label: 'Generar comprobante',
            labelStyle: const TextStyle(fontSize: 16),
            onTap: () {
              _showComprobanteOptions(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResumenTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Table(
        columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1)},
        border: TableBorder.symmetric(
          inside: const BorderSide(color: Colors.grey),
        ),
        children: [
          _buildTableRow('Total productos solicitados:', '0', isHeader: true),
          _buildTableRow('Entregas contado:', '\$0'),
          _buildTableRow('Entregas crédito:', '\$0'),
          _buildTableRow('Contado:', '\$0'),
          _buildTableRow('Colaborado:', '\$0'),
          _buildTableRow('Colaborado efectivo:', '\$0'),
          _buildTableRow('Devolución:', '-\$0', isNegative: true),
          _buildTableRow('Devolución contado:', '-\$0', isNegative: true),
          _buildTableRow('Devolución crédito:', '-\$0', isNegative: true),
          _buildTableRow('Gastos Operativos:', '-\$0', isNegative: true),
        ],
      ),
    );
  }

  Widget _buildTotalCierre() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total efectivo:', style: TextStyle(fontSize: 16)),
                SizedBox(
                  width: 120,
                  child: TextField(
                    controller: _totalEfectivoController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      hintText: '0.00',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (vmalue) => _calcularSobrante(),
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sobrante:', style: TextStyle(fontSize: 16)),
                Text(
                  '${_sobrante >= 0 ? '+' : ''}${_sobrante.toStringAsFixed(2)}\$',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _sobrante >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentosPendientes() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Documentos Pendientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '0',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(
    String label,
    String value, {
    bool isHeader = false,
    bool isNegative = false,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? Colors.blueGrey.shade50 : null,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isNegative ? Colors.red : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
