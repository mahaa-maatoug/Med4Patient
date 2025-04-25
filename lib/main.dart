

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/routes/app_pages.dart';
import 'modules/login/login_controller.dart';
import 'modules/login/usercontroller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Vérifier si l'utilisateur est connecté en récupérant le token
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  Get.put(UserController());
  Get.put(LoginController());
  runApp(MyApp(isLoggedIn: token != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Med4Front',
      initialRoute: isLoggedIn ? '/home' : '/login', // Si connecté, redirige vers Home
      getPages: AppPages.routes,

    );
  }

}
