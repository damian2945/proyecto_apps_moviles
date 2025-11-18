import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/product.dart';

class ApiService {
  // IP de tu laptop
  static const String _localIp = '192.168.1.5';
  static const int _port = 3000;

  static String get baseUrl {
    if (kIsWeb) {
      // Chrome Web - También usa la IP local
      return 'http://$_localIp:$_port';
    } else if (Platform.isAndroid) {
      // Dispositivo físico Android
      return 'http://$_localIp:$_port';
    } else if (Platform.isIOS) {
      // Dispositivo físico iOS
      return 'http://$_localIp:$_port';
    } else {
      // Por defecto
      return 'http://$_localIp:$_port';
    }
  }

  Future<List<Product>> fetchAllProducts() async {
    try {
      print('════════════════════════════════════════');
      print('🔍 INTENTANDO CONECTAR');
      print('📱 Plataforma: ${_getPlatformName()}');
      print('🌐 URL: $baseUrl/productos');
      print('🔧 IP configurada: $_localIp:$_port');
      print('════════════════════════════════════════');
      
      final response = await http.get(
        Uri.parse('$baseUrl/productos'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          print('💥 TIMEOUT: El servidor no respondió en 15 segundos');
          throw TimeoutException('El servidor no responde');
        },
      );

      print('📡 RESPUESTA RECIBIDA - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        if (jsonResponse['success'] == true) {
          List<dynamic> productsJson = jsonResponse['data'];
          print('✅ ÉXITO: ${productsJson.length} productos cargados');
          print('════════════════════════════════════════');
          return productsJson.map((json) => Product.fromJson(json)).toList();
        } else {
          throw Exception('Error en la respuesta: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Código de estado: ${response.statusCode}');
      }
    } on SocketException {
      print('═══════════════════════════════════════════════════════');
      print('💥 ERROR DE CONEXIÓN - No se puede conectar al servidor');
      print('═══════════════════════════════════════════════════════');
      print('Verifica:');
      print('1. ¿El servidor está corriendo? (node server.js)');
      print('2. ¿MySQL está activo en XAMPP?');
      print('3. ¿La IP es correcta? ($_localIp)');
      print('4. ¿El firewall permite conexiones al puerto $_port?');
      print('═══════════════════════════════════════════════════════');
      throw Exception('No se puede conectar al servidor');
    } on TimeoutException {
      print('💥 TIMEOUT: El servidor tardó demasiado');
      throw Exception('El servidor no responde');
    } catch (e) {
      print('💥 ERROR: $e');
      rethrow;
    }
  }

  Future<Product> fetchProductById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/productos/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        if (jsonResponse['success'] == true) {
          return Product.fromJson(jsonResponse['data']);
        } else {
          throw Exception('Producto no encontrado');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Producto no encontrado');
      } else {
        throw Exception('Error al cargar producto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Product> createProduct(Product product) async {
    try {
      print('📤 Creando producto: ${product.nombre}');
      
      final response = await http.post(
        Uri.parse('$baseUrl/productos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJsonWithoutId()),
      );

      print('📡 Status: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        if (jsonResponse['success'] == true) {
          print('✅ Producto creado exitosamente');
          return Product.fromJson(jsonResponse['data']);
        } else {
          throw Exception('Error al crear producto: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Error al crear producto: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Error: $e');
      throw Exception('Error: $e');
    }
  }

  Future<Product> updateProduct(int id, Product product) async {
    try {
      print('📤 Actualizando producto ID: $id');
      
      final response = await http.put(
        Uri.parse('$baseUrl/productos/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJsonWithoutId()),
      );

      print('📡 Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        if (jsonResponse['success'] == true) {
          print('✅ Producto actualizado exitosamente');
          return Product.fromJson(jsonResponse['data']);
        } else {
          throw Exception('Error al actualizar producto');
        }
      } else {
        throw Exception('Error al actualizar producto: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Error: $e');
      throw Exception('Error: $e');
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      print('🗑️ Eliminando producto ID: $id');
      
      final response = await http.delete(
        Uri.parse('$baseUrl/productos/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      print('📡 Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('✅ Producto eliminado exitosamente');
        return jsonResponse['success'] == true;
      } else {
        throw Exception('Error al eliminar producto: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Error: $e');
      throw Exception('Error: $e');
    }
  }

  Future<List<Product>> searchProducts(String nombre) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/productos/buscar?nombre=$nombre'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        if (jsonResponse['success'] == true) {
          List<dynamic> productsJson = jsonResponse['data'];
          return productsJson.map((json) => Product.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Error al buscar productos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  String _getPlatformName() {
    if (kIsWeb) {
      return 'Web (Chrome)';
    } else if (Platform.isAndroid) {
      return 'Android (Dispositivo Físico)';
    } else if (Platform.isIOS) {
      return 'iOS (Dispositivo Físico)';
    } else if (Platform.isWindows) {
      return 'Windows';
    } else if (Platform.isMacOS) {
      return 'macOS';
    } else if (Platform.isLinux) {
      return 'Linux';
    } else {
      return 'Unknown';
    }
  }
}