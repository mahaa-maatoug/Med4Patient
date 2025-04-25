import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../login/usercontroller.dart';
import 'cart_controller.dart';



class CartScreen extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Light blue background
      appBar: AppBar(
        title: Text('Mon Panier', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800], // Dark blue app bar
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: () => _showClearCartDialog(),
          ),
        ],
      ),
      body: Obx(() {
        if (!userController.isLoggedIn.value) {
          return _buildLoginPrompt();
        }
        if (cartController.cart.value.items.isEmpty) {
          return _buildEmptyCart();
        }
        return _buildCartContent();
      }),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.login, size: 64, color: Colors.blue[800]),
          SizedBox(height: 20),
          Text('Connectez-vous pour commander',
            style: TextStyle(
              fontSize: 18,
              color: Colors.blue[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Get.offAllNamed('/login'),
            child: Text('Se connecter',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 64, color: Colors.blue[800]),
          SizedBox(height: 16),
          Text('Votre panier est vide',
            style: TextStyle(
              fontSize: 18,
              color: Colors.blue[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Get.back(),
            child: Text('Continuer vos achats',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: cartController.cart.value.items.length,
            itemBuilder: (context, index) {
              final item = cartController.cart.value.items[index];
              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Dismissible(
                  key: Key(item.product.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    cartController.removeFromCart(item.product.id);
                    Get.snackbar(
                      'Supprimé',
                      '${item.product.name} retiré du panier',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.blue[800],
                      colorText: Colors.white,
                    );
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: item.product.storagePath.isNotEmpty
                          ? Image.network(
                        'http://10.0.2.2:3000/${item.product.storagePath.first.replaceAll(r'\', '/')}',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        width: 60,
                        height: 60,
                        color: Colors.blue[100],
                        child: Icon(Icons.image_not_supported,
                            color: Colors.blue[800]),
                      ),
                    ),
                    title: Text(item.product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    subtitle: Text('${item.product.price.toStringAsFixed(2)} €',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, color: Colors.blue[800]),
                            onPressed: () => cartController.updateQuantity(
                              item.product.id,
                              item.quantity - 1,
                            ),
                          ),
                          Text(item.quantity.toString(),
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: Colors.blue[800]),
                            onPressed: () => cartController.updateQuantity(
                              item.product.id,
                              item.quantity + 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        _buildCheckoutSection(),
      ],
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${cartController.cart.value.totalAmount.toStringAsFixed(2)} €',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
              onPressed: () async {
                final success = await cartController.submitOrder(
                  userController.userId.value,
                );
                if (success) {
                  Get.defaultDialog(
                    title: 'Commande passée',
                    titleStyle: TextStyle(color: Colors.blue[800]),
                    middleText: 'Votre commande a été enregistrée!',
                    middleTextStyle: TextStyle(color: Colors.blue[900]),
                    textConfirm: 'OK',
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      Get.back();
                      Get.back();
                    },
                    buttonColor: Colors.blue[800],
                  );
                }
              },
              child: Text('Passer la commande',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog() {
    Get.defaultDialog(
      title: 'Vider le panier',
      titleStyle: TextStyle(color: Colors.blue[800]),
      middleText: 'Êtes-vous sûr de vouloir vider votre panier?',
      middleTextStyle: TextStyle(color: Colors.blue[900]),
      textCancel: 'Annuler',
      textConfirm: 'Vider',
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.blue[800],
      onConfirm: () {
        cartController.clearCart();
        Get.back();
      },
      buttonColor: Colors.blue[800],
    );
  }
}