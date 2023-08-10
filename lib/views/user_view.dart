import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../views/login/BienvenidoView.dart';

class UserView extends StatelessWidget {
  // Función para cerrar sesión
  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Navegar a la vista de bienvenida después de cerrar sesión
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => BienvenidoView()),
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
          SizedBox(
              height:
                  40), // Ajustar el espacio para mover la imagen hacia arriba
          // Imagen de portada
          Image.asset(
            'assets/imgs/TriptekkerLogo.jpg',
            height: 150,
          ),
          Center(
            child: Text(
              '"Triptekker" es una app de geolocalización y turismo que permite explorar lugares cercanos, guardar favoritos y momentos especiales. Incluye autenticación de usuarios y cierre de sesión.',
              textAlign: TextAlign.center, // Alineación del texto al centro
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Arial',
              ),
            ),
          ),
          SizedBox(height: 10),

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
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error al obtener datos');
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
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        if (photoURL != null)
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(photoURL),
                          ),
                        SizedBox(height: 20),

                        // Botón para cerrar sesión
                        ElevatedButton.icon(
                          onPressed: () => _signOut(context),
                          icon: Icon(Icons.logout),
                          label: Text('Cerrar sesión'),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),

          SizedBox(height: 20),

          // Botones que llevan a diferentes vistas
          Column(
            children: [
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Lógica para navegar a la primera vista
                },
                icon: Icon(Icons.star), // Icono de estrella
                label: Text('Lugares favoritos del usuario'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50), // Ancho y alto del botón
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Lógica para navegar a la segunda vista
                },
                icon: Icon(Icons.camera), // Icono de cámara
                label: Text('Momentos guardados a través de la cámara'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  }
}
