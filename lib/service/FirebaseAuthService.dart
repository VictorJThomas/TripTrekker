import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Registro de usuario en Firebase Authentication y Firestore
  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
    required String profilePictureUrl,
  }) async {
    try {
      // Crear el usuario en Firebase Authentication
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Obtener el UID del usuario registrado
      final String uid = userCredential.user?.uid ?? '';

      // Guardar información adicional en Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        'profilePictureUrl': profilePictureUrl,
      });
    } catch (e) {
      // Lanza un error si ocurre algún problema en el registro
      throw Exception("Error en el registro: $e");
    }
  }

  // Inicio de sesión con nombre de usuario y contraseña
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception("Error en el inicio de sesión: $e");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
