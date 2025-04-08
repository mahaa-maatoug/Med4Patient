import 'package:get/get.dart';
import 'package:med4front/modules/login/login_screen.dart';
import 'package:med4front/modules/login/login_binding.dart';

import '../../modules/Home/ColisScreen.dart';
import '../../modules/Home/colis_binding.dart';
import '../../modules/Home/home_screen.dart';
import '../../modules/Home/home_binding.dart';

import '../../modules/ordonnance/ordonnance_list_screen.dart';
import '../../modules/ordonnance/ordonnancebinding.dart';
class AppPages {
  static final routes = [
    GetPage(
      name: '/login',
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/home',
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: '/colis',
      page: () => ColisScreen(),
      binding: ColisBinding(),
    ),
    GetPage(
      name: '/ordonnances',
      page: () => OrdonnanceListScreen(),
        binding: OrdonnanceBinding()
    ),
  ];
}
