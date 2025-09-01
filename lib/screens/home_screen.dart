import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/deep_link_handler.dart';
import '../widgets/product_card.dart';
import '../models/product.dart';
import 'product_detail_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  
  final List<String> _categories = ['All', 'iPhone', 'Samsung', 'Google', 'OnePlus'];
  
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'iPhone 15 Pro',
      price: 999,
      installmentPrice: 41.63,
      image: 'assets/iphone-15-pro.png',
      category: 'iPhone',
      description: 'Latest iPhone with titanium design',
    ),
    Product(
      id: '2',
      name: 'Samsung Galaxy S24',
      price: 799,
      installmentPrice: 33.29,
      image: 'assets/samsung-s24.png',
      category: 'Samsung',
      description: 'Flagship Samsung with AI features',
    ),
    Product(
      id: '3',
      name: 'Google Pixel 8',
      price: 699,
      installmentPrice: 29.13,
      image: 'assets/pixel-8.png',
      category: 'Google',
      description: 'Pure Android experience with great camera',
    ),
  ];

  List<Product> get _filteredProducts {
    List<Product> filtered = _selectedCategory == 'All' 
        ? _products 
        : _products.where((p) => p.category == _selectedCategory).toList();
    
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((p) => 
        p.name.toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.pets,
                size: 20,
                color: AppColors.brown,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'SHIBA phone',
              style: TextStyle(
                color: AppColors.brown,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          // Debug button to test deep link (remove in production)
          IconButton(
            icon: const Icon(Icons.link, color: AppColors.teal),
            onPressed: () {
              DeepLinkHandler().simulateDeepLinkEntry(context);
            },
            tooltip: 'Test Deep Link',
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search phones...',
                prefixIcon: const Icon(Icons.search, color: AppColors.darkGray),
                filled: true,
                fillColor: AppColors.lightGray,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          // Categories
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: AppColors.mainPink,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.darkGray,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Products Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}