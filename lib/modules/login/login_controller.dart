import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med4front/modules/login/usercontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



class LoginController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isLoading = false.obs;
  final UserController userController = Get.find<UserController>();

  Future<void> login() async {
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      isLoading.value = false;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final user = data['user'];

        // Store user info
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        // Make sure to use the same field name as your backend (_id)
        await prefs.setString('userId', user['_id']);
        await prefs.setString('email', user['email']);
        await prefs.setString('firstName', user['firstName']);

        // Force reload user data
        await userController.loadUserFromStorage();

        Get.offAllNamed('/home'); // Use offAll to clear navigation stack
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar("Erreur", error['message'] ?? 'Échec de la connexion');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Erreur", "Une erreur s'est produite. Veuillez réessayer.");
      print('Login error: $e');
    }
  }
}