import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Product.dart';
import 'ProductController.dart';
import 'cart_controller.dart';


class ProductListView extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 105,
              height: 44,
            ),
            SizedBox(width: 10),
            Flexible(
              child: Text(
                "Produits",
                style: TextStyle(
                  color: Colors.blue[800],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue[800]),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: Colors.blue[800]),  // History icon
            onPressed: () => Get.toNamed('/orders'),  // Navigate to orders screen
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.blue[800]),
            onPressed: () => Get.toNamed('/cart'),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.blue[800]),
            onPressed: () => controller.fetchProducts(),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Search and filter section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Rechercher',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.blue[800]),
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  onChanged: (val) => controller.filterByCategory(val),
                ),
                SizedBox(height: 10),
                Obx(() {
                  final categories = controller.productList
                      .map((p) => p.category.type)
                      .toSet()
                      .toList();
                  categories.insert(0, 'Toutes les catégories');

                  return DropdownButtonFormField<String>(
                    value: 'Toutes les catégories',
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == 'Toutes les catégories') {
                        controller.filterByCategory('');
                      } else {
                        controller.filterByCategory(value!);
                      }
                    },
                  );
                }),
              ],
            ),
          ),

          // Product grid
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (controller.filteredProducts.isEmpty) {
                return Center(
                  child: Text(
                    'Aucun produit trouvé',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                );
              }

              return GridView.builder(
                padding: EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: controller.filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = controller.filteredProducts[index];
                  return ProductCard(
                    product: product,
                    onImageTap: () => _showProductDetails(context, product),
                    onAddToCart: product.canBePurchased ? () {
                      cartController.addToCart(product);
                      Get.snackbar(
                        'Succès',
                        '${product.name} ajouté au panier',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: Duration(seconds: 1),
                      );
                    } : null,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showProductDetails(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.blue[800]),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                if (product.storagePath.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.network(
                        'http://10.0.2.2:3000/${product.storagePath.first.replaceAll(r'\', '/')}',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Center(
                          child: Icon(Icons.broken_image, size: 60, color: Colors.blue[200]),
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 20),

                _buildDetailRow('Catégorie', product.category.type),
                SizedBox(height: 12),

                product.showPrice
                    ? _buildDetailRow('Prix', '${product.price.toStringAsFixed(2)} €')
                    : _buildDetailRow('Prix', 'Prix non disponible', isAvailable: false),

                _buildDetailRow(
                  'Disponibilité',
                  product.stockStatus == StockStatus.IN_STOCK ? 'En stock' : 'Rupture de stock',
                  isAvailable: product.stockStatus == StockStatus.IN_STOCK,
                ),
                SizedBox(height: 24),

                if (product.canBePurchased)
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      onPressed: () {
                        cartController.addToCart(product);
                        Get.snackbar(
                          'Succès',
                          '${product.name} ajouté au panier',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: Duration(seconds: 1),
                        );
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Ajouter au panier',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isAvailable = true}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isAvailable ? Colors.blue[800] : Colors.red,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onImageTap;
  final VoidCallback? onAddToCart;

  const ProductCard({
    required this.product,
    required this.onImageTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: onImageTap,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: product.storagePath.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    'http://10.0.2.2:3000/${product.storagePath.first.replaceAll(r'\', '/')}',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Icon(Icons.broken_image, size: 50, color: Colors.grey[500]),
                  ),
                )
                    : Center(
                  child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey[500]),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[800],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  product.category.type,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                SizedBox(height: 8),

                if (product.showPrice)
                  Text(
                    '${product.price.toStringAsFixed(2)} €',
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                Text(
                  product.stockStatus == StockStatus.IN_STOCK ? 'En stock' : 'Rupture de stock',
                  style: TextStyle(
                    color: product.stockStatus == StockStatus.IN_STOCK
                        ? Colors.green
                        : Colors.red,
                    fontSize: 12,
                  ),
                ),

                if (product.canBePurchased && onAddToCart != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.add_shopping_cart, size: 20, color: Colors.blue[800]),
                      onPressed: onAddToCart,
                      padding: EdgeInsets.zero,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}