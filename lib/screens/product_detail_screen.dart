import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/purchases_provider.dart';
import '../providers/favorites_provider.dart';
import '../models/purchase.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final Map<String, String> currentUser;

  const ProductDetailScreen({
    super.key, // ✅ CORRECCIÓN 1: Cambiar Key? key por super.key
    required this.product,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favorites, child) {
              final isFavorite = favorites.isFavorite(product.id);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  favorites.toggleFavorite(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite
                            ? '${product.nombre} eliminado de favoritos'
                            : '${product.nombre} agregado a favoritos',
                      ),
                      duration: const Duration(seconds: 2),
                      backgroundColor: isFavorite ? Colors.orange : Colors.green,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'product-${product.id}',
              child: Container(
                width: double.infinity,
                height: 400,
                color: Colors.grey[200],
                child: Image.network(
                  product.imagen,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 100,
                        color: Colors.grey,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.nombre,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.attach_money, color: Colors.green, size: 28),
                        Text(
                          product.precio.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.tag, size: 20, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'ID: ${product.id}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  if (product.creadoEn != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'Creado: ${product.creadoEn}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),
                  const Text(
                    'Información del producto',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.inventory_2, 'Disponible', 'En stock'),
                  _buildInfoRow(Icons.local_shipping, 'Envío', 'Gratis'),
                  _buildInfoRow(Icons.verified_user, 'Garantía', '12 meses'),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3), // ✅ CORRECCIÓN 2: withValues
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Consumer<CartProvider>(
            builder: (context, cart, child) {
              final isInCart = cart.isInCart(product.id);
              final quantity = cart.getProductQuantity(product.id);
              
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isInCart) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Ya tienes $quantity ${quantity == 1 ? "unidad" : "unidades"} en el carrito',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            cart.addItem(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.check_circle, color: Colors.white),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        '${product.nombre} agregado al carrito',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                action: SnackBarAction(
                                  label: 'Ver Carrito',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text(
                            'Agregar al Carrito',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final purchasesProvider = Provider.of<PurchasesProvider>(context, listen: false);
                            
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Comprar ahora'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Producto: ${product.nombre}'),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Total: \$${product.precio.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.green,
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
                                      final purchaseId = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
                                      
                                      // ✅ CORRECCIÓN 3: product.id.toString()
                                      final purchase = Purchase(
                                        id: purchaseId,
                                        fecha: DateTime.now(),
                                        total: product.precio,
                                        items: [
                                          PurchaseItem(
                                            productId: product.id.toString(),
                                            nombre: product.nombre,
                                            precio: product.precio,
                                            cantidad: 1,
                                            imagen: product.imagen,
                                          ),
                                        ],
                                        estado: 'Procesando',
                                        clienteEmail: currentUser['email'] ?? 'desconocido@ejemplo.com', // ✅ CORRECCIÓN 4: Agregar ??
                                        clienteNombre: currentUser['nombre'] ?? 'Cliente', // ✅ CORRECCIÓN 4: Agregar ??
                                      );
                                      
                                      purchasesProvider.addPurchase(purchase);
                                      
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                '¡Compra realizada con éxito!',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              Text('Pedido #$purchaseId'),
                                            ],
                                          ),
                                          backgroundColor: Colors.green,
                                          duration: const Duration(seconds: 3),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    child: const Text('Confirmar'),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Colors.blue, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.shopping_bag),
                          label: const Text(
                            'Comprar',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blue),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}