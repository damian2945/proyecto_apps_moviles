import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required Map<String, String> currentUser}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Simulación de datos de usuario activo
  // En producción, estos datos vendrían de un servicio de autenticación
  final Map<String, String> _currentUser = {
    'email': 'damian@gmail.com',
    'password': '1234', // En producción NUNCA mostrar la contraseña
    'nombre': 'Damián',
    'telefono': '+52 312 456 7890',
    'direccion': 'Colima, México',
  };

  // Lista de usuarios locales (como en tu captura)
  final Map<String, String> _localUsers = {
    'damian@gmail.com': '1234',
    'alberto@gmail.com': '123456',
    'jesus@gmail.com': '123456789',
  };

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: Text('¿Estás seguro de cerrar sesión como ${_currentUser['nombre']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sesión cerrada: ${_currentUser['email']}'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con foto de perfil y datos principales
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blue.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      _currentUser['nombre']![0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _currentUser['nombre']!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currentUser['email']!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Sesión activa',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Información de la cuenta
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información de la cuenta',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildProfileItem(
                    icon: Icons.person_outline,
                    title: 'Nombre completo',
                    value: _currentUser['nombre']!,
                    onTap: () {
                      _showEditDialog(context, 'Nombre', _currentUser['nombre']!);
                    },
                  ),
                  _buildProfileItem(
                    icon: Icons.email_outlined,
                    title: 'Correo electrónico',
                    value: _currentUser['email']!,
                    onTap: () {
                      _showEditDialog(context, 'Email', _currentUser['email']!);
                    },
                  ),
                  _buildProfileItem(
                    icon: Icons.phone_outlined,
                    title: 'Teléfono',
                    value: _currentUser['telefono']!,
                    onTap: () {
                      _showEditDialog(context, 'Teléfono', _currentUser['telefono']!);
                    },
                  ),
                  _buildProfileItem(
                    icon: Icons.location_on_outlined,
                    title: 'Dirección',
                    value: _currentUser['direccion']!,
                    onTap: () {
                      _showEditDialog(context, 'Dirección', _currentUser['direccion']!);
                    },
                  ),

                  const SizedBox(height: 24),

                  // Información de sesión
                  const Text(
                    'Información de sesión',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.login, color: Colors.blue),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Usuario activo',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      _currentUser['email']!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            children: [
                              const Icon(Icons.people_outline, color: Colors.blue),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Usuarios registrados',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '${_localUsers.length} cuentas locales',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  _showLocalUsers(context);
                                },
                                child: const Text('Ver'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Configuración',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildProfileItem(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Mis pedidos',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Función próximamente')),
                      );
                    },
                  ),
                  _buildProfileItem(
                    icon: Icons.favorite_outline,
                    title: 'Favoritos',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Función próximamente')),
                      );
                    },
                  ),
                  _buildProfileItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notificaciones',
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                    ),
                    onTap: null,
                  ),
                  _buildProfileItem(
                    icon: Icons.lock_outline,
                    title: 'Cambiar contraseña',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showChangePasswordDialog(context);
                    },
                  ),
                  _buildProfileItem(
                    icon: Icons.help_outline,
                    title: 'Ayuda y soporte',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Función próximamente')),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    String? value,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: value != null ? Text(value) : null,
        trailing: trailing ?? (onTap != null ? const Icon(Icons.arrow_forward_ios, size: 16) : null),
        onTap: onTap,
      ),
    );
  }

  void _showEditDialog(BuildContext context, String field, String currentValue) {
    final TextEditingController controller = TextEditingController(text: currentValue);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar $field'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: field,
            border: const OutlineInputBorder(),
          ),
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
                  content: Text('$field actualizado: ${controller.text}'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showLocalUsers(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Usuarios registrados localmente'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _localUsers.length,
            itemBuilder: (context, index) {
              final email = _localUsers.keys.elementAt(index);
              final isActive = email == _currentUser['email'];
              
              return Card(
                color: isActive ? Colors.blue.shade50 : null,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isActive ? Colors.blue : Colors.grey,
                    child: Text(
                      email[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    email,
                    style: TextStyle(
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    isActive ? 'Sesión activa' : 'Cuenta local',
                    style: TextStyle(
                      color: isActive ? Colors.green : Colors.grey,
                    ),
                  ),
                  trailing: isActive
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                ),
              );
            },
          ),
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

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña actual',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nueva contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar contraseña',
                border: OutlineInputBorder(),
              ),
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
              if (newPasswordController.text == confirmPasswordController.text) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Contraseña actualizada correctamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Las contraseñas no coinciden'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Cambiar'),
          ),
        ],
      ),
    );
  }
}