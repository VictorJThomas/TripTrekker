import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'LoginView.dart';
import '../../service/FirebaseAuthService.dart';
import '../../service/select_image.dart';
import '../../service/upload_image.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _profilePictureController = TextEditingController();

  FirebaseAuthService _authService = FirebaseAuthService();
  Imagen imagen = new Imagen();
  FStorage subirImg = new FStorage();

  File? _selectedImage;

  Future<void> _selectProfilePicture() async {
    final image = await imagen.getImage();

    if (image != null) {
      setState(() {
        _selectedImage = File(image!.path);
        _profilePictureController.text = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: const Text(
                  "Hola! Registrate para poder explorar la aplicación",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            //username
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8F9),
                  border: Border.all(
                    color: const Color(0xFFE8ECF4),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Nombre de usuario',
                      hintStyle: TextStyle(
                        color: Color(0xFF8391A1),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            //email
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8F9),
                  border: Border.all(
                    color: const Color(0xFFE8ECF4),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: Color(0xFF8391A1),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            //password
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8F9),
                  border: Border.all(
                    color: const Color(0xFFE8ECF4),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Contraseña',
                      hintStyle: TextStyle(
                        color: Color(0xFF8391A1),
                      ),
                    ),
                    obscureText: true, // Ocultar el texto de la contraseña
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            //confirm password
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8F9),
                  border: Border.all(
                    color: const Color(0xFFE8ECF4),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Confirmar contraseña',
                      hintStyle: TextStyle(
                        color: Color(0xFF8391A1),
                      ),
                    ),
                    obscureText: true, // Ocultar el texto de la contraseña
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            // Foto de perfil
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: GestureDetector(
                onTap:
                    _selectProfilePicture, // Llamar al método para seleccionar la imagen
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8F9),
                    border: Border.all(
                      color: const Color(0xFFE8ECF4),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(Icons.add_a_photo),
                        const SizedBox(width: 8),
                        Text(
                          'Agregar foto de perfil',
                          style: TextStyle(
                            color: Color(0xFF8391A1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            // Vista previa de la imagen seleccionada (si existe)
            if (_selectedImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipOval(
                  child: Image.file(
                    _selectedImage!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            //register button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      color: const Color(0xFF1E232C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onPressed: () async {
                        // Realizar las validaciones antes de registrar al usuario
                        if (_usernameController.text.isEmpty ||
                            _emailController.text.isEmpty ||
                            _passwordController.text.isEmpty ||
                            _confirmPasswordController.text.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Por favor, completa todos los campos.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                        } else if (_passwordController.text !=
                            _confirmPasswordController.text) {
                          Fluttertoast.showToast(
                            msg: "Las contraseñas no coinciden.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                        } else if (_passwordController.text.length < 6) {
                          Fluttertoast.showToast(
                            msg:
                                "La contraseña debe tener al menos 6 caracteres.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                        } else if (_profilePictureController.text.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Ingrese una foto de perfil.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                        } else {
                          try {
                            String profilePictureUrl = '';
                            if (_selectedImage != null) {
                              profilePictureUrl = await subirImg
                                  .uploadImageToFirebase(_selectedImage!);
                            }

                            await _authService.registerUser(
                              username: _usernameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              profilePictureUrl:
                                  profilePictureUrl, // Pasar la URL de la foto de perfil al método
                            );

                            if (_selectedImage == null) {
                              return;
                            }

                            // Registro exitoso, mostrar mensaje y navegar a la pantalla de inicio de sesión
                            Fluttertoast.showToast(
                              msg: "Registro exitoso.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginView(),
                              ),
                            );
                          } catch (e) {
                            // Manejo de errores si ocurre algún problema en el registro
                            print("Error en el registro: $e");
                            Fluttertoast.showToast(
                              msg:
                                  "Error en el registro. Inténtalo nuevamente. $e",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );
                          }
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Registrate",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Ya tienes una cuenta? ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()));
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Color(0xFF35C2C1),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
