
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'cart_item.dart';


class OrderService {
  final String _baseUrl = 'http://10.0.2.2:3000/orders';

  Future<bool> submitOrder({
    required String patientId,
    required String pharmacyId,
    required List<CartItem> items,
    required String paymentMethod,
    required String deliveryAddress,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'patientId': patientId,
          'pharmacyId': pharmacyId,
          'items': items.map((item) => {
            'productId': item.product.id,
            'quantity': item.quantity,
          }).toList(),
          'paymentMethod': paymentMethod,
          'deliveryAddress': deliveryAddress,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        Get.snackbar('Error', 'Failed to submit order');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to server');
      return false;
    }
  }

  Future<List<dynamic>> getPatientOrders(String patientId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/patient/$patientId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        Get.snackbar('Error', 'Failed to fetch orders');
        return [];
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to server');
      return [];
    }
  }
}