import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Product.dart';
import 'cart.dart';

class CartController extends GetxController {
  final Rx<Cart> cart = Cart().obs;
  final String _baseUrl = 'http://10.0.2.2:3000/orders';

  // Existing cart methods...
  void addToCart(Product product) {
    cart.value.addItem(product);
    cart.refresh();
  }

  void removeFromCart(String productId) {
    cart.value.removeItem(productId);
    cart.refresh();
  }

  void updateQuantity(String productId, int newQuantity) {
    cart.value.updateQuantity(productId, newQuantity);
    cart.refresh();
  }

  void clearCart() {
    cart.value.clear();
    cart.refresh();
  }

  Future<bool> submitOrder(String patientId) async {
    try {
      final orderItems = cart.value.items.map((item) => {
        'productId': item.product.id,
        'quantity': item.quantity,
        'priceAtPurchase': item.product.price,
      }).toList();

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',

        },
        body: json.encode({
          'patientId': patientId,
          'items': orderItems,
          'totalAmount': cart.value.totalAmount,
          'status': 'pending',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        clearCart();
        return true;
      } else {
        Get.snackbar('Error', 'Failed to submit order: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to server: $e');
      return false;
    }
  }
}