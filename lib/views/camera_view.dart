import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  File? _imageFile;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_isTakingPicture) return;

    try {
      setState(() {
        _isTakingPicture = true;
      });

      await _initializeControllerFuture!;
      final imagePath = await _controller.takePicture();
      setState(() {
        _imageFile = File(imagePath.path);
      });
      _showPreviewDialog();
    } catch (e) {
      print("Error al tomar la foto: $e");
    } finally {
      setState(() {
        _isTakingPicture = false;
      });
    }
  }

  void _showPreviewDialog() async {
    if (_imageFile != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePreviewScreen(
            imagePath: _imageFile!.path,
            onImageSaved: () => _savePhotoToDatabase(),
          ),
        ),
      );
    }
  }

  void _savePhotoToDatabase() async {
    if (_imageFile != null) {
      try {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final filePath = '${appDir.path}/$fileName';

        await _imageFile!.copy(filePath);
        await GallerySaver.saveImage(filePath);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Imagen guardada en la galería",
              style: TextStyle(
                  color: Colors.black), // Cambia el color del texto a negro
            ),
            duration: Duration(seconds: 2),
          ),
        );

        _imageFile = null;
      } catch (e) {
        print("Error al guardar la foto: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_controller),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 16.0), // Espaciado vertical deseado
                    child: ElevatedButton(
                      onPressed: _isTakingPicture ? null : _takePicture,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16.0),
                      ),
                      child: _isTakingPicture
                          ? const CircularProgressIndicator()
                          : const Icon(
                              Icons.camera,
                              color: Colors
                                  .black, // Cambia el color del icono a negro
                            ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class ImagePreviewScreen extends StatelessWidget {
  final String imagePath;
  final VoidCallback onImageSaved;

  const ImagePreviewScreen({
    super.key,
    required this.imagePath,
    required this.onImageSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vista Previa',
          style: TextStyle(
              color: Colors.black), // Cambia el color del texto a negro
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(File(imagePath)),
            ElevatedButton(
              onPressed: () {
                onImageSaved();
                Navigator.pop(context);
              },
              child: const Text(
                'Guardar',
                style: TextStyle(
                    color: Colors.black), // Cambia el color del texto a negro
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Descartar',
                style: TextStyle(
                    color: Colors.black), // Cambia el color del texto a negro
              ),
            ),
          ],
        ),
      ),
    );
  }
}
