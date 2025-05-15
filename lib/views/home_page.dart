import 'package:flutter/material.dart';
// Importación de todas las vistas disponibles
import 'package:app_rutax/views/clientes.dart';
import 'package:app_rutax/views/productos.dart';
import 'package:app_rutax/views/reportes.dart';
import 'package:app_rutax/views/cierre_del_dia.dart';
import 'package:app_rutax/views/gestos_operativos.dart';
import 'package:app_rutax/views/sincronizar.dart';

// Página principal que sirve de base para cambiar entre vistas con un menú lateral
class HomePage extends StatefulWidget {
  final String initialTitle;
  final Widget initialBody;

  // Puedes personalizar la vista inicial que se muestra
  const HomePage({
    super.key,
    this.initialTitle = 'Clientes',
    this.initialBody = const Center(child: Text('Vista de Clientes')),
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _currentTitle; // Título actual mostrado en la AppBar
  late Widget _currentBody; // Contenido actual mostrado en el cuerpo de la app

  @override
  void initState() {
    super.initState();
    // Inicializa con la vista que fue pasada al constructor
    _currentTitle = widget.initialTitle;
    _currentBody = widget.initialBody;
  }

  // Función que permite cambiar el contenido de la vista
  void _changeView(String title, Widget body) {
    setState(() {
      _currentTitle = title;
      _currentBody = body;
    });
    Navigator.pop(context); // Cierra el Drawer al seleccionar una opción
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior de la aplicación con el título dinámico
      appBar: AppBar(
        title: Text(
          _currentTitle,
          style: const TextStyle(
            color: Colors.white,
          ), // Todos los títulos en blanco
        ),
        backgroundColor: const Color(0xFFFF8622),
        // Cambiar el color del icono de hamburguesa a blanco
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Menú lateral (Drawer) con opciones de navegación
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Encabezado del menú con perfil de usuario
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFFF8622)),

              // Nombre del usuario en blanco
              accountName: const Text(
                'Nombre del Usuario',
                style: TextStyle(color: Colors.white),
              ),
              // Elimina el campo del correo electrónico
              accountEmail: null,
              // Ícono de perfil
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.orange),
              ),
            ),

            // Elementos del menú para cambiar de vista
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Clientes'),
              onTap: () => _changeView('Clientes', const ClientesPage()),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Productos'),
              onTap: () => _changeView('Productos', const ProductosPage()),
            ),
            ListTile(
              leading: const Icon(Icons.insert_chart),
              title: const Text('Reportes'),
              onTap: () => _changeView('Reportes', const ReportesPage()),
            ),
            ListTile(
              leading: const Icon(Icons.event_available),
              title: const Text('Cierre del día'),
              onTap: () => _changeView('Cierre del día', const CierrePage()),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Gestos operativos'),
              onTap: () => _changeView('Gestos operativos', const GestosPage()),
            ),
            ListTile(
              leading: const Icon(Icons.sync),
              title: const Text('Sincronizar'),
              onTap: () => _changeView('Sincronizar', const SincronizarPage()),
            ),

            // Opción para cerrar sesión (navega hacia atrás dos veces)
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () {
                Navigator.pop(context); // Cierra Drawer
                Navigator.pop(context); // Regresa al Login
              },
            ),
          ],
        ),
      ),

      // Vista que se actualiza dinámicamente según lo seleccionado en el menú
      body: _currentBody,
    );
  }
}
