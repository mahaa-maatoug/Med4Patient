import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med4front/modules/Home/profile_update_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ordonnance/ordonnance_list_screen.dart';
import 'ColisScreen.dart';
import 'home_controller.dart';

import 'profile_screen.dart';



class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  final List<Widget> pages = [
    ColisScreen(), // Page des colis
    OrdonnanceListScreen(), // Page des ordonnances
    ProfileScreen(), // Page du profil
    Center(child: Text('Déconnexion', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))), // Placeholder pour logout
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Obx(() => pages[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: (index) async {
            if (index == 3) {
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
              label: 'Ordonnances',  // Added Ordonnances tab
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout, color: Colors.red),
              label: 'Logout',
            ),
          ],
        ),
      ),
    );
  }
}
