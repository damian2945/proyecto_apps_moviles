
  
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(product.image, height: 300, fit: BoxFit.contain),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, color: Colors.green)),
                  const SizedBox(height: 10),
                  const Text('Customer Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  // Aquí iría el widget de Rating
                  Text('${product.rating.rate} stars (${product.rating.count} reviews)'),
                  const SizedBox(height: 10),
                  const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(product.description),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para añadir al carrito
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: const Text('Add to Cart'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para comprar ahora
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Buy Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}