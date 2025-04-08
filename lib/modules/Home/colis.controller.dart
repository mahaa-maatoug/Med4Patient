import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ColisController extends GetxController {
  var isLoading = false.obs;
  var packages = [].obs;
  var errorMessage = ''.obs;

  // Filters
  var priorityFilter = false.obs;
  var statusFilter = 'En préparation'.obs;

  @override
  void onInit() {
    fetchPackages();
    super.onInit();
  }

  Future<void> fetchPackages() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/packages')
            .replace(queryParameters: {
          'priority': priorityFilter.value.toString(),
          'status': statusFilter.value,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        packages.assignAll(data);
      } else {
        throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to load packages');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters(bool priority, String status) {
    priorityFilter.value = priority;
    statusFilter.value = status;
    fetchPackages();
  }
}