import 'package:flutter/material.dart';
import 'main_navigation.dart';
import 'admin_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  // Base de datos de usuarios locales
  final Map<String, Map<String, String>> _localUsers = {
    'admin': {
      'password': 'admin123',
      'nombre': 'Administrador',
      'telefono': '+52 312 000 0000',
      'direccion': 'Tienda Principal',
      'role': 'admin',
    },
    'damian@gmail.com': {
      'password': '1234',
      'nombre': 'Damián',
      'telefono': '+52 312 456 7890',
      'direccion': 'Colima, México',
      'role': 'customer',
    },
    'alberto@gmail.com': {
      'password': '123456',
      'nombre': 'Alberto',
      'telefono': '+52 312 123 4567',
      'direccion': 'Guadalajara, México',
      'role': 'customer',
    },
    'jesus@gmail.com': {
      'password': '123456789',
      'nombre': 'Jesús',
      'telefono': '+52 312 987 6543',
      'direccion': 'Monterrey, México',
      'role': 'customer',
    },
  };

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Simular delay de autenticación
      Future.delayed(const Duration(seconds: 1), () {
        if (_localUsers.containsKey(email) &&
            _localUsers[email]!['password'] == password) {
          // Login exitoso
          if (!mounted) return;

          final userData = {
            'email': email,
            'nombre': _localUsers[email]!['nombre']!,
            'telefono': _localUsers[email]!['telefono']!,
            'direccion': _localUsers[email]!['direccion']!,
            'role': _localUsers[email]!['role']!,
          };

          // Redirigir según el rol
          if (userData['role'] == 'admin') {
            // Navegar al panel de administrador
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminNavigation(currentUser: userData),
              ),
            );
          } else {
            // Navegar a la app de comprador
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainNavigation(currentUser: userData),
              ),
            );
          }
        } else {
          // Login fallido
          if (!mounted) return;
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Correo o contraseña incorrectos'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo o icono
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shopping_bag,
                            size: 60,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Bienvenido',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Inicia sesión en tu cuenta',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Campo de correo/usuario
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Usuario / Correo electrónico',
                            hintText: 'admin o correo@ejemplo.com',
                            prefixIcon: const Icon(Icons.person_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu usuario o correo';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Campo de contraseña
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            hintText: '••••••••',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu contraseña';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Botón de login
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Iniciar Sesión',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Link de olvidé mi contraseña
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Función próximamente'),
                              ),
                            );
                          },
                          child: const Text('¿Olvidaste tu contraseña?'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}