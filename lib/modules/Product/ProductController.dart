import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'Product.dart';

class ProductController extends GetxController {
  final String baseUrl = 'http://10.0.2.2:3000/products';
  var productList = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var isLoading = true.obs;
  var showPrices = true.obs;
  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
      );

      print('Status: ${response.statusCode}'); // Debug
      print('Body: ${response.body}'); // Debug

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        productList.assignAll(data.map((e) => Product.fromJson(e)).toList());
        filteredProducts.assignAll(productList);
      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar('Error', 'Failed to load products');
    } finally {
      isLoading(false);
    }
  }

  void filterByCategory(String category) {
    if (category.isEmpty) {
      filteredProducts.assignAll(
          showPrices.value
              ? productList
              : productList.where((p) => p.showPrice).toList()
      );
    } else {
      filteredProducts.assignAll(
          productList.where((p) =>
          p.category.type.toLowerCase().contains(category.toLowerCase()) &&
              (showPrices.value ? true : p.showPrice)
          ).toList()
      );
    }
  }

  // Add this new method to toggle price visibility
  void togglePriceVisibility(bool show) {
    showPrices.value = show;
    filterByCategory(''); // Reapply current filters
  }

}
