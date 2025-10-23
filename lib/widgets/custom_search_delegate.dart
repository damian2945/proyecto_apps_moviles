  // lib/widgets/custom_search_delegate.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import '../screens/search_results_screen.dart'; // Asegúrate de tener esta importación

class CustomSearchDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Search products, brands, stores...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // CORRECCIÓN: Usamos WidgetsBinding para asegurarnos de que el contexto esté disponible antes de cerrar.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Navega a la pantalla de resultados con la consulta.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsScreen(searchQuery: query),
        ),
      );
    });
    // Cerramos la búsqueda con una cadena vacía para evitar errores de duplicación.
    close(context, '');
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Asegúrate de usar listen: false dentro del delegate para evitar problemas de rebuild.
    // El error 'searchProducts was called on null' se resuelve asegurando que ProductProvider
    // esté inicializado en main.dart y disponible para este contexto (como te expliqué antes).
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final List<Product> suggestionList = productProvider.searchProducts(query);

    if (suggestionList.isEmpty && query.isNotEmpty) {
      // [El código de sugerencias está correcto]
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No products found for "$query"',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final product = suggestionList[index];
        return ListTile(
          // [El código de ListTile está correcto]
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              product.image,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 40,
                  height: 40,
                  color: Colors.grey[300],
                  child: Icon(Icons.image, color: Colors.grey[600]),
                );
              },
            ),
          ),
          title: Text(
            product.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            product.category,
            style: TextStyle(color: Colors.grey[600]),
          ),
          trailing: Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            close(context, product.title);
          },
        );
      },
    );
  }
}