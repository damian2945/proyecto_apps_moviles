import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Importa tu modelo Product
import '../models/product.dart';

// =========================================================================
// PROVIDER PRINCIPAL: ProductProvider
// =========================================================================

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Constructor: Al crear el provider, automáticamente carga los productos
  ProductProvider() {
    fetchProducts();
  }

  // -------------------------------------------------------------------------
  // MÉTODO PRINCIPAL: Obtener productos desde la API
  // -------------------------------------------------------------------------
  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Usando la API gratuita de FakeStore
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> productJson = json.decode(response.body);
        _products = productJson.map((json) => Product.fromJson(json)).toList();
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to load products. Status code: ${response.statusCode}';
        _products = [];
      }
    } catch (error) {
      _errorMessage = 'Error loading products: $error';
      _products = [];
      print('Error fetching products: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -------------------------------------------------------------------------
  // MÉTODO DE BÚSQUEDA: Filtrar productos por query
  // -------------------------------------------------------------------------
  List<Product> searchProducts(String query) {
    if (query.isEmpty) {
      return _products;
    }

    final String lowerQuery = query.toLowerCase();
    return _products.where((product) {
      return product.title.toLowerCase().contains(lowerQuery) ||
          product.category.toLowerCase().contains(lowerQuery) ||
          product.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // -------------------------------------------------------------------------
  // MÉTODO AUXILIAR: Obtener producto por ID
  // -------------------------------------------------------------------------
  Product? getProductById(int id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // -------------------------------------------------------------------------
  // MÉTODO AUXILIAR: Obtener productos por categoría
  // -------------------------------------------------------------------------
  List<Product> getProductsByCategory(String category) {
    if (category.isEmpty) {
      return _products;
    }
    
    return _products
        .where((product) => 
            product.category.toLowerCase() == category.toLowerCase())
        .toList();
  }
}