import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importaciones de archivos externos
import '../providers/product_provider.dart';
import '../models/product.dart';
import 'search_results_screen.dart';
import 'shopping_cart_screen.dart';
import 'profile_screen.dart';
import '../widgets/product_card.dart';

// =========================================================================
// WIDGET PRINCIPAL: HomeScreen
// =========================================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeContent(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0 ? _buildAppBar(context) : null,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: GestureDetector(
        onTap: () async {
          // CORRECCIÓN: Eliminamos la navegación manual aquí. 
          // showSearch() llama a CustomSearchDelegate.buildResults()
          // que ahora gestionará la navegación.
          await showSearch(
            context: context,
            delegate: CustomSearchDelegate(),
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
              Text('Search products...', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShoppingCartScreen()),
              );
            }
          },
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}

// -------------------------------------------------------------------------

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  // selectedCategory es null cuando "All" está seleccionado.
  String? selectedCategory;

  void _navigateToAllProducts() {
    // CORRECCIÓN: Si selectedCategory es null, enviamos una cadena vacía
    // o el string 'All' (dependiendo de cómo maneje SearchResultsScreen
    // el caso de "todos"). Aquí usaremos la categoría, y si es null, la dejamos vacía.
    final String query = selectedCategory ?? '';
    
    // Navegación a la pantalla de resultados
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
          // Si es null (All), SearchResultsScreen debe mostrar todos.
          searchQuery: query, 
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    if (productProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (productProvider.products.isEmpty) {
      return const Center(child: Text('No products available.'));
    }

    // Filtrar productos por categoría si hay una seleccionada
    List<Product> displayProducts = selectedCategory != null
        ? productProvider.products
            .where((product) => product.category.toLowerCase() == selectedCategory!.toLowerCase())
            .toList()
        : productProvider.products;

    // Mostrar hasta 12 productos para llenar más la pantalla
    final featuredProducts = displayProducts.take(12).toList();

    return RefreshIndicator(
      onRefresh: () async {
        await productProvider.fetchProducts();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Sección de Categorías ---
            const Text(
              'Featured Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryPill('All', Icons.apps, null), // null significa "All"
                  _buildCategoryPill('Jewelery', Icons.diamond, 'jewelery'),
                  _buildCategoryPill('Electronics', Icons.devices, 'electronics'),
                  _buildCategoryPill('Men\'s', Icons.man, 'men\'s clothing'),
                  _buildCategoryPill('Women\'s', Icons.woman, 'women\'s clothing'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- Título de productos con contador ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedCategory != null
                      ? _formatCategoryName(selectedCategory!)
                      : 'Featured Products',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    '${featuredProducts.length} items',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // --- Grid de Productos ---
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: GridView.builder(
                key: ValueKey(selectedCategory),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemCount: featuredProducts.length,
                itemBuilder: (context, index) {
                  final product = featuredProducts[index];
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300 + (index * 50)),
                    child: ProductCard(product: product),
                  );
                },
              ),
            ),

            // Mensaje si no hay productos en la categoría
            if (featuredProducts.isEmpty)
              Container(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.inbox, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No products found in this category',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),

            // Botón View All Products - Se muestra si hay más productos que los destacados (12)
            if (displayProducts.length > featuredProducts.length || selectedCategory != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: TextButton(
                    onPressed: _navigateToAllProducts,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'View All Products',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Espacio al final
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _formatCategoryName(String category) {
    switch (category) {
      case 'men\'s clothing':
        return 'Men\'s Clothing';
      case 'women\'s clothing':
        return 'Women\'s Clothing';
      case 'jewelery':
        return 'Jewelery';
      case 'electronics':
        return 'Electronics';
      default:
        // Capitaliza la primera letra para un mejor display
        return category[0].toUpperCase() + category.substring(1); 
    }
  }

  Widget _buildCategoryPill(String name, IconData icon, String? categoryFilter) {
    final isSelected = selectedCategory == categoryFilter;

    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = categoryFilter;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isSelected ? Colors.green : Colors.grey.shade200,
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.black87,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.green : Colors.black87,
            ),
            child: Text(name),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------------

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
    // CORRECCIÓN: Manejo de navegación para evitar problemas de contexto.
    if (query.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 1. Cerramos el delegado de búsqueda, devolviendo el query
        close(context, query);
        
        // 2. Navegamos a la pantalla de resultados después de cerrar la búsqueda
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultsScreen(searchQuery: query),
          ),
        );
      });
    } else {
      // Si el query está vacío, solo cerramos
      close(context, '');
    }
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final List<Product> suggestionList = productProvider.searchProducts(query);

    if (suggestionList.isEmpty && query.isNotEmpty) {
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
            // Cuando se toca una sugerencia, forzamos el resultado de la búsqueda
            // al título del producto, lo que dispara buildResults()
            query = product.title;
            showResults(context); 
          },
        );
      },
    );
  }
}