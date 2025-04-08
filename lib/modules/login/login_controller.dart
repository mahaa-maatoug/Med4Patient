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
  final UserController userController = Get.put(UserController());

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
        final user = data['user']; // Vérifie que 'user' est bien dans la réponse

        // Stocker les infos utilisateur
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('userId', user['_id']); // ID du patient
        await prefs.setString('email', user['email']);
        await prefs.setString('firstName', user['firstName']);

        // Charger les infos utilisateur
        await userController.loadUserFromStorage();

        Get.offNamed('/home'); // Redirection vers l'accueil
      } else {
        final errorMessage = jsonDecode(response.body)['message'] ?? 'Échec de la connexion';
        Get.snackbar("Erreur", errorMessage, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Erreur", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
