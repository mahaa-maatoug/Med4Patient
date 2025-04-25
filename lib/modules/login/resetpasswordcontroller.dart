import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordController extends GetxController {
  var emailController = TextEditingController();
  var codeController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  var isCodeVerified = false.obs;
  var isLoading = false.obs;
  var email = ''.obs;

  Future<void> sendResetCode(String email) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/auth/reset-password/request-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        this.email.value = email;
        Get.snackbar(
          'Succès',
          'Code de réinitialisation envoyé',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue[800],
          colorText: Colors.white,
        );
      } else {
        throw Exception('Échec de l\'envoi du code');
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyCode() async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/auth/reset-password/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.value,
          'code': codeController.text,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['isValid'] == true) {
        isCodeVerified.value = true;
        Get.snackbar(
          'Succès',
          'Code vérifié',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue[800],
          colorText: Colors.white,
        );
      } else {
        throw Exception('Code invalide ou expiré');
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Erreur',
        'Les mots de passe ne correspondent pas',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/auth/reset-password/reset'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.value,
          'code': codeController.text,
          'newPassword': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Succès',
          'Mot de passe réinitialisé avec succès',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue[800],
          colorText: Colors.white,
        );
        Get.offAllNamed('/login');
      } else {
        throw Exception('Échec de la réinitialisation');
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}