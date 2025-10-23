import 'package:flutter/material.dart';
import '../screens/shopping_cart_screen.dart';
import '../screens/search_results_screen.dart'; 
// Eliminamos el import de CustomSearchDelegate

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showSearch;

  const CustomAppBar({
    super.key,
    this.title = 'Search products...',
    this.showSearch = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: showSearch
          ? GestureDetector(
              onTap: () { // Eliminamos 'async' ya que no usamos showSearch()
                // CORRECCIÓN: Navegamos directamente a SearchResultsScreen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    // Usamos una consulta vacía, la pantalla de resultados se encargará del campo de texto
                    builder: (ctx) => const SearchResultsScreen(searchQuery: ''), 
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                  ],
                ),
              ),
            )
          : Text(title, style: const TextStyle(color: Colors.black)),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart, color: Colors.black),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const ShoppingCartScreen()));
          },
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}