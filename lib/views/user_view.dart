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
    // Obtener la información del usuario actualmente autenticado
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
              height:
                  40), // Ajustar el espacio para mover la imagen hacia arriba
          // Imagen de portada
          Image.asset(
            'assets/imgs/TriptekkerLogo.jpg',
            height: 150,
          ),
          const Center(
            child: Text(
              '"Triptekker" es una app de geolocalización y turismo que permite explorar lugares cercanos, guardar favoritos y momentos especiales. Incluye autenticación de usuarios y cierre de sesión.',
              textAlign: TextAlign.center, // Alineación del texto al centro
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Arial',
                color: Colors.black, // Cambia el color del texto a negro
              ),
            ),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: Center(
              // Centrar el contenido verticalmente
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser!.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error al obtener datos',
                        style: TextStyle(
                            color: Colors
                                .black)); // Cambia el color del texto a negro
                  } else {
                    String? username =
                        snapshot.data?.get('username') as String?;
                    String? photoURL =
                        snapshot.data?.get('profilePictureUrl') as String?;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          username ?? '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .black, // Cambia el color del texto a negro
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (photoURL != null)
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(photoURL),
                          ),
                        const SizedBox(height: 20),

                        // Botón para cerrar sesión
                        ElevatedButton.icon(
                          onPressed: () => _signOut(context),
                          icon: const Icon(Icons.logout,
                              color: Colors
                                  .black), // Cambia el color del icono a negro
                          label: const Text('Cerrar sesión',
                              style: TextStyle(
                                  color: Colors
                                      .black)), // Cambia el color del texto a negro
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Botones que llevan a diferentes vistas
          Column(
            children: [
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FavoritesView(
                              userId: currentUser!.uid,
                            )),
                  );
                },
                icon: const Icon(Icons.star,
                    color: Colors.black), // Cambia el color del icono a negro
                label: const Text('Lugares favoritos del usuario',
                    style: TextStyle(
                        color:
                            Colors.black)), // Cambia el color del texto a negro
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50), // Ancho y alto del botón
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
