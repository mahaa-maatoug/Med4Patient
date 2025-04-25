import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med4front/modules/login/resetpasswordcontroller.dart';


class ResetPasswordView  extends StatelessWidget {
  final ResetPasswordController controller = Get.put(ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Réinitialiser le mot de passe",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF163659),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Entrez le code de vérification envoyé à votre e-mail.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF163659),
                ),
              ),
              SizedBox(height: 16),

              // Code Input Field
              TextField(
                controller: controller.codeController,
                decoration: InputDecoration(
                  labelText: 'Code de vérification',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock, color: Colors.blue[800]),
                ),
              ),

              SizedBox(height: 16),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: controller.verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Obx(() => controller.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Vérifier le code',
                    style: TextStyle(color: Colors.white),
                  ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              Obx(() {
                if (controller.isCodeVerified.value) {
                  return Column(
                    children: [
                      TextField(
                        controller: controller.passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Nouveau mot de passe',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock, color: Colors.blue[800]),
                        ),
                      ),
                      SizedBox(height: 16),

                      TextField(
                        controller: controller.confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirmer le mot de passe',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock, color: Colors.blue[800]),
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: controller.resetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Obx(() => controller.isLoading.value
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                            'Réinitialiser',
                            style: TextStyle(color: Colors.white),
                          ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}