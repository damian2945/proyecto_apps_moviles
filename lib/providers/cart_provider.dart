import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  void addItem(Product product) {
    int index = _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      // Si el producto ya existe, aumenta la cantidad
      _items[index].quantity++;
    } else {
      // Si el producto no existe, añádelo
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  static of(BuildContext context) {}
}