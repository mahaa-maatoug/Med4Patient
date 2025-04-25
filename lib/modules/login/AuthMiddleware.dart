import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';
import 'package:med4front/modules/login/usercontroller.dart';

class AuthMiddleware extends GetMiddleware {
  final UserController userController = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    return userController.isLoggedIn.value
        ? null
        : RouteSettings(name: '/login');
  }
}