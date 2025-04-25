
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login/usercontroller.dart';
import 'order_controller.dart';





class OrderHistoryScreen extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    final patientId = userController.userId.value;

    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des commandes'),
        backgroundColor: Colors.blue[800],
      ),
      body: FutureBuilder(
        future: orderController.fetchPatientOrders(patientId),
        builder: (context, snapshot) {
          return Obx(() {
            if (orderController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (orderController.orders.isEmpty) {
              return Center(child: Text('Aucune commande trouvée.'));
            }

            return ListView.builder(
              itemCount: orderController.orders.length,
              itemBuilder: (context, index) {
                final order = orderController.orders[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text('Commande #${index + 1}'),
    subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text('Total : ${order["totalAmount"]} €'),
    Text('Statut : ${order["status"]}'),

    SizedBox(height: 8),
    Text('Produits :'),
    ...List<Widget>.from(
      (order["items"] ?? []).map<Widget>((item) {
        final product = item["product"];
        final name = product?["name"] ?? "Nom inconnu";
        final category = product?["category"]?["type"] ?? "Catégorie inconnue";
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text('- $name ($category)'),
        );
      }),
    ),
    ],
    ),


                  ),
                );
              },
            );
          });
        },
      ),
    );
  }
}
