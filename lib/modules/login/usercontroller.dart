import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  var userId = ''.obs;
  var email = ''.obs;
  var firstName = ''.obs;

  Future<void> loadUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getString('userId') ?? '';
    email.value = prefs.getString('email') ?? '';
    firstName.value = prefs.getString('firstName') ?? '';
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    userId.value = '';
    email.value = '';
    firstName.value = '';
    Get.offAllNamed('/login'); // Redirige vers la page de connexion
  }
}
