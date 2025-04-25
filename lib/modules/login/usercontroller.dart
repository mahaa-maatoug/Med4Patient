import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  var userId = ''.obs;
  var email = ''.obs;
  var firstName = ''.obs;
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    loadUserFromStorage();
    super.onInit();
  }

  Future<void> loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      userId.value = prefs.getString('userId') ?? '';
      email.value = prefs.getString('email') ?? '';
      firstName.value = prefs.getString('firstName') ?? '';
      isLoggedIn.value = userId.value.isNotEmpty;
    } catch (e) {
      print('Error loading user: $e');
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      userId.value = '';
      email.value = '';
      firstName.value = '';
      isLoggedIn.value = false;
      Get.offAllNamed('/login');
    } catch (e) {
      print('Logout error: $e');
    }
  }
}
