import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FStorage {
  late String url2;

  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadImageToFirebase(File image) async {
    //Devuelve el nombre de la imagen.
    final String nameFile = image.path.split("/").last;

//Dividir en carpetas las imagenes.

    Reference ref = storage.ref().child("images").child(nameFile);

//Tarea que se encarga de poner el archivo en la referencia.
    final UploadTask uploadTask = ref.putFile(image);

    print(uploadTask);

    //Monitorea el task
    TaskSnapshot snapshot = await uploadTask;

    print(snapshot);

    final String url = await snapshot.ref.getDownloadURL();
    print(url);

    return url;
  }
}
