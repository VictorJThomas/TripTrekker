import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../views/login/BienvenidoView.dart';
import 'favorites/favorites.dart';

class UserView extends StatelessWidget {
  // Función para cerrar sesión
  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Navegar a la vista de bienvenida después de cerrar sesión
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const BienvenidoView()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imgs/TriptekkerLogo.jpg',
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '"Triptekker" es una app de geolocalización y turismo que permite explorar lugares cercanos, guardar favoritos y momentos especiales. Incluye autenticación de usuarios y cierre de sesión.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Arial',
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 10),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(
                    'Error al obtener datos',
                    style: TextStyle(color: Colors.black),
                  );
                } else {
                  String? username =
                      snapshot.data?.get('username') as String?;
                  String? photoURL =
                      snapshot.data?.get('profilePictureUrl') as String?;

                  return Column(
                    children: [
                      Text(
                        username ?? '',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      if (photoURL != null)
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(photoURL),
                        ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => _signOut(context),
                        icon: Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Cerrar sesión',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FavoritesView(
                                userId: currentUser!.uid,
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.star,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Lugares favoritos del usuario',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(200, 50),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
