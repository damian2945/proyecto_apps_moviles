import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // ✅ CORRECTO: Sin el prefijo /api
  static const String baseUrl = 'http://localhost:3000/productos';

  // GET - Obtener todos los productos
  Future<List<Product>> fetchAllProducts() async {
    try {
      final url = '$baseUrl';
      print('🔍 Conectando a: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
      );

      print('📡 Status: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        if (jsonResponse['success'] == true) {
          List<dynamic> productsJson = jsonResponse['data'];
          print('✅ ${productsJson.length} productos cargados');
          return productsJson.map((json) => Product.fromJson(json)).toList();
        } else {
          throw Exception('Error: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Error: $e');
      rethrow;
    }
  }

  // GET - Obtener un producto por ID
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

  // POST - Crear un nuevo producto
  Future<Product> createProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/productos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJsonWithoutId()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        if (jsonResponse['success'] == true) {
          return Product.fromJson(jsonResponse['data']);
        } else {
          throw Exception('Error al crear producto');
        }
      } else {
        throw Exception('Error al crear producto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // PUT - Actualizar un producto
  Future<Product> updateProduct(int id, Product product) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/productos/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJsonWithoutId()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        if (jsonResponse['success'] == true) {
          return Product.fromJson(jsonResponse['data']);
        } else {
          throw Exception('Error al actualizar producto');
        }
      } else {
        throw Exception('Error al actualizar producto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // DELETE - Eliminar un producto
  Future<bool> deleteProduct(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/productos/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['success'] == true;
      } else {
        throw Exception('Error al eliminar producto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // GET - Buscar productos por nombre
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
}