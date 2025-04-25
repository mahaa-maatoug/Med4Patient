import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med4front/modules/Home/profile_update_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Product/ProductListView.dart';
import '../ordonnance/ordonnance_list_screen.dart';
import 'ColisScreen.dart';
import 'home_controller.dart';

import 'profile_screen.dart';



class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  final List<Widget> pages = [
    ColisScreen(), // Page des colis (index 0)
    OrdonnanceListScreen(), // Page des ordonnances (index 1)
    ProfileScreen(), // (index 2)
    ProductListView(), // (index 3)
    // No need for logout placeholder here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: (index) async {
            if (index == 4) { // Logout is now index 4
              // Déconnexion
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              await prefs.remove('userId');
              Get.offAllNamed('/login');
            } else if (index == 2) {
              // Récupérer l'userId avant d'ouvrir la page de mise à jour du profil
              final prefs = await SharedPreferences.getInstance();
              final String? userId = prefs.getString('userId');

              if (userId != null) {
                Get.to(() => ProfileUpdateScreen());
              } else {
                Get.snackbar("Erreur", "Utilisateur non trouvé", snackPosition: SnackPosition.BOTTOM);
              }
            } else {
              controller.changeTabIndex(index);
            }
          },
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping),
              label: 'Colis',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Ordonnances',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medical_services),
              label: 'Produits',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout, color: Colors.red),
              label: 'Déconnexion',
            ),
          ],
        ),
      ),
    );
  }
}