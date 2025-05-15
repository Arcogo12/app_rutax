import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app_rutax/views/home_page.dart';
import 'package:app_rutax/views/sincronizar.dart';

void main() {
  runApp(const MyApp()); // Punto de entrada de la app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rutax App',
      debugShowCheckedModeBanner: false,

      // Tema general de la aplicación
      theme: ThemeData(
        primarySwatch: Colors.orange,
        colorScheme: ColorScheme.light(
          primary: Colors.orange.shade700,
          secondary: Colors.amber.shade600,
        ),

        // Estilo global de campos de texto
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.95),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(color: Colors.grey.shade800, fontSize: 16),
        ),

        // Estilo global de botones elevados
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            elevation: 3,
          ),
        ),
      ),

      // Soporte para idioma español
      locale: const Locale('es', 'ES'),
      supportedLocales: const [Locale('es', 'ES')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Pantalla principal al iniciar la app
      home: const LoginPage(),
    );
  }
}

// Pantalla de Login (inicio de sesión)
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  // Función para validar y procesar el login
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    final user = _userController.text;
    final password = _passwordController.text;

    // Validación simple de usuario/contraseña
    if (user == 'Admin' && password == 'admin') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => const HomePage(
                initialTitle: 'Sincronizar',
                initialBody: SincronizarPage(),
              ),
        ),
      );
    } else {
      // Mostrar error si las credenciales son incorrectas
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Usuario o contraseña incorrectos'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(20),
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        // Fondo con degradado naranja
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF8622), Color(0xFFFF8622)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ícono representativo
                const SizedBox(height: 20),

                // Título de la app
                const Text(
                  '',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),

                // Subtítulo
                const Text(
                  'Sistema de Gestión de Transporte',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 40),

                // Formulario de acceso
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: size.width > 400 ? 400 : size.width * 0.9,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Campo de usuario
                        TextFormField(
                          controller: _userController,
                          decoration: const InputDecoration(
                            labelText: 'Usuario',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.grey,
                            ),
                            alignLabelWithHint: true,
                          ),
                          style: TextStyle(color: Colors.grey.shade800),
                          validator:
                              (value) =>
                                  value?.isEmpty ?? true
                                      ? 'Ingresa tu usuario'
                                      : null,
                        ),
                        const SizedBox(height: 20),

                        // Campo de contraseña con botón para mostrar/ocultar
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Colors.grey,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey.shade600,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            alignLabelWithHint: true,
                          ),
                          style: TextStyle(color: Colors.grey.shade800),
                          validator:
                              (value) =>
                                  value?.isEmpty ?? true
                                      ? 'Ingresa tu contraseña'
                                      : null,
                        ),
                        const SizedBox(height: 30),

                        // Botón para ingresar
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.orange.shade700,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 3,
                            ),
                            child:
                                _isLoading
                                    ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: Colors.orange,
                                      ),
                                    )
                                    : const Text(
                                      'INICAR SESIÓN',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
