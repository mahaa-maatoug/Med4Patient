import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:med4front/modules/Home/profilecontroller.dart';



class ProfileUpdateScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 105,
              height: 44,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                "Modifier le profil",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
        elevation: 0,
      ),
      body: Obx(() => SingleChildScrollView(
        child: Container(
          color: Colors.grey[100],
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Header Section
                Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 1),
                )],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Informations personnelles",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  Divider(color: Colors.grey[300]),
                ],
              ),
            ),
            SizedBox(height: 20),

            // First Name Field
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
              BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1),
              )],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Prénom",
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: controller.firstNameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide:
                      BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide:
                      BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  validator: (value) => value!.isEmpty
                      ? 'Veuillez entrer votre prénom'
                      : null,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Last Name Field
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
            BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
            )],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nom",
                style: TextStyle(
                  color: Colors.blue[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: controller.lastNameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide:
                    BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide:
                    BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                validator: (value) => value!.isEmpty
                    ? 'Veuillez entrer votre nom'
                    : null,
              ),
            ],
          ),
        ),
        SizedBox(height: 16),

        // Email Field
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
          BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 3,
          offset: Offset(0, 1),
          )],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Email",
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: controller.emailController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide:
                  BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide:
                  BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              validator: (value) => value!.isEmpty
                  ? 'Veuillez entrer votre email'
                  : null,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
          SizedBox(height: 16),

          // Password Change Section
          if (!controller.showPasswordFields.value)
      TextButton(
      onPressed: controller.togglePasswordFields,
      child: Text(
        'Changer le mot de passe',
        style: TextStyle(color: Colors.blue[800]),
      ),
    ),

    if (controller.showPasswordFields.value) ...[
    // Current Password Field
    Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
    BoxShadow(
    color: Colors.grey.withOpacity(0.2),
    spreadRadius: 1,
    blurRadius: 3,
    offset: Offset(0, 1),
    ),
    ],
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    "Mot de passe actuel",
    style: TextStyle(
    color: Colors.blue[800],
    fontWeight: FontWeight.bold,
    ),
    ),
    SizedBox(height: 8),
    TextFormField(
    controller:
    controller.currentPasswordController,
    obscureText: true,
    decoration: InputDecoration(
    contentPadding: EdgeInsets.symmetric(
    horizontal: 12, vertical: 8),
    border: OutlineInputBorder(
    borderRadius:
    BorderRadius.circular(4),
    borderSide: BorderSide(
    color: Colors.grey[300]!),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius:
    BorderRadius.circular(4),
    borderSide: BorderSide(
    color: Colors.grey[300]!),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius:
    BorderRadius.circular(4),
    borderSide:
    BorderSide(color: Colors.blue),
    ),
    ),
    validator: (value) => value!.isEmpty
    ? 'Veuillez entrer votre mot de passe actuel'
        : null,
    ),
    ],
    ),
    ),
    SizedBox(height: 16),

    // New Password Field
    Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
    BoxShadow(
    color: Colors.grey.withOpacity(0.2),
    spreadRadius: 1,
    blurRadius: 3,
    offset: Offset(0, 1),
    )],
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    "Nouveau mot de passe",
    style: TextStyle(
    color: Colors.blue[800],
    fontWeight: FontWeight.bold,
    ),
    ),
    SizedBox(height: 8),
    TextFormField(
    controller: controller.newPasswordController,
    obscureText: true,
    decoration: InputDecoration(
    contentPadding: EdgeInsets.symmetric(
    horizontal: 12, vertical: 8),
    border: OutlineInputBorder(
    borderRadius:
    BorderRadius.circular(4),
    borderSide: BorderSide(
    color: Colors.grey[300]!),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius:
    BorderRadius.circular(4),
    borderSide: BorderSide(
    color: Colors.grey[300]!),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius:
    BorderRadius.circular(4),
    borderSide:
    BorderSide(color: Colors.blue),
    ),
    ),
    validator: (value) {
    if (value != null &&
    value.isNotEmpty &&
    value.length < 6) {
    return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
    },
    ),
    ],
    ),
    ),
    SizedBox(height: 16),

    // Confirm Password Field
    Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
    BoxShadow(
    color: Colors.grey.withOpacity(0.2),
    spreadRadius: 1,
    blurRadius: 3,
    offset: Offset(0, 1),
    ),
    ],
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    "Confirmer le nouveau mot de passe",
    style: TextStyle(
    color: Colors.blue[800],
    fontWeight: FontWeight.bold,
    ),
    ),
    SizedBox(height: 8),
    TextFormField(
    controller:
    controller.confirmPasswordController,
    obscureText: true,
    decoration: InputDecoration(
    contentPadding: EdgeInsets.symmetric(
    horizontal: 12, vertical: 8),
    border: OutlineInputBorder(
    borderRadius:
    BorderRadius.circular(4),
    borderSide: BorderSide(
    color: Colors.grey[300]!),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius:
    BorderRadius.circular(4),
    borderSide: BorderSide(
    color: Colors.grey[300]!),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius:
    BorderRadius.circular(4),
    borderSide:
    BorderSide(color: Colors.blue),
    ),
    ),
    validator: (value) =>
    value != controller.newPasswordController.text
    ? 'Les mots de passe ne correspondent pas'
        : null,
    ),
    ],
    ),
    ),
    SizedBox(height: 16),

    // Cancel Password Change Button
    TextButton(
    onPressed: controller.togglePasswordFields,
    child: Text(
    'Annuler',
    style: TextStyle(color: Colors.red),
    ),
    ),
    ],
    SizedBox(height: 30),

    // Update Button
    Padding(
    padding: EdgeInsets.only(left: 38, bottom: 20),
    child: SizedBox(
    width: 353,
    height: 36,
    child: ElevatedButton(
    onPressed: () {
    if (controller.formKey.currentState!
        .validate()) {
    controller.updateProfile();
    }
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue[800],
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4),
    ),
    padding: EdgeInsets.zero,
    ),
    child: Text(
    'Mettre à jour',
    style: TextStyle(
    fontSize: 16,
    color: Colors.white,
    ),
    ),
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    )),
    );
  }
}