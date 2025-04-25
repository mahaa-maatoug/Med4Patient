
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cart_controller.dart';


class CartIcon extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
      children: [
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () => Get.toNamed('/cart'),
        ),
        if (cartController.cart.value.itemCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                cartController.cart.value.itemCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    ));
  }
}