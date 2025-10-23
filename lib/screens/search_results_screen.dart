import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ← IMPORTANTE: Agregar este import
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class SearchResultsScreen extends StatelessWidget {
  final String searchQuery;
  
  const SearchResultsScreen({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    // CORRECCIÓN: Usar Provider.of en lugar de ProductProvider.of
    final productProvider = Provider.of<ProductProvider>(context, listen: true);
    
    // Filtramos los productos usando la función del provider
    final results = productProvider.searchProducts(searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Results for "$searchQuery"', 
          style: const TextStyle(color: Colors.black)
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: results.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sentiment_dissatisfied, size: 50, color: Colors.grey),
                    const SizedBox(height: 10),
                    Text(
                      'No products found for "$searchQuery".',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Try adjusting your search terms or checking your spelling.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: results.length,
              itemBuilder: (context, index) {
                return ProductCard(product: results[index]);
              },
            ),
    );
  }
}