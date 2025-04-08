import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool showPasswordFields = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Add this line

  // User data
  final firstName = ''.obs;
  final lastName = ''.obs;
  final email = ''.obs;

  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? _token;

  @override
  void onInit() {
    super.onInit();
    _loadToken();
    fetchUserData();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    if (_token == null) {
      Get.snackbar('Error'.tr, 'Not authenticated'.tr);
    }
  }

  Future<void> fetchUserData() async {
    if (_token == null) return;

    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/user/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        firstName.value = data['firstName'] ?? '';
        lastName.value = data['lastName'] ?? '';
        email.value = data['email'] ?? '';

        // Update controllers
        firstNameController.text = firstName.value;
        lastNameController.text = lastName.value;
        emailController.text = email.value;
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      Get.snackbar('Error'.tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    if (_token == null) return;

    isLoading.value = true;

    try {
      // Update profile info
      final profileResponse = await http.put(
        Uri.parse('http://10.0.2.2:3000/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'firstName': firstNameController.text.trim(),
          'lastName': lastNameController.text.trim(),
          'email': emailController.text.trim(),
        }),
      );

      if (profileResponse.statusCode != 200) {
        throw Exception(jsonDecode(profileResponse.body)['message'] ?? 'Update failed');
      }

      // Update password if fields are shown and filled
      if (showPasswordFields.value &&
          newPasswordController.text.isNotEmpty &&
          currentPasswordController.text.isNotEmpty) {
        await changePassword();
      }

      Get.snackbar('Success'.tr, 'Profile updated'.tr);
      Get.back();
    } catch (e) {
      Get.snackbar('Error'.tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword() async {
    if (_token == null) return;
    if (newPasswordController.text != confirmPasswordController.text) {
      throw Exception('Passwords do not match');
    }
    if (newPasswordController.text.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    final response = await http.put(
      Uri.parse('http://10.0.2.2:3000/user/change-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({
        'currentPassword': currentPasswordController.text,
        'newPassword': newPasswordController.text,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Password change failed');
    }
  }

  void togglePasswordFields() {
    showPasswordFields.toggle();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}