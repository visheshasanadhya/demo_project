import 'dart:typed_data';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:universal_html/html.dart' as html;

void main() {
  runApp(const MaterialApp(home: ShivPoster()));
}

class ShivPoster extends StatefulWidget {
  const ShivPoster({super.key});
  @override
  State<ShivPoster> createState() => _ShivPosterState();
}

class _ShivPosterState extends State<ShivPoster> {
  Uint8List? userImage;
  Uint8List? bgImage;
  String userName = '';
  bool showDownload = false;

  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> pickImage(bool isProfile) async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final bytes = await file.readAsBytes();
      setState(() {
        if (isProfile) {
          userImage = bytes;
        } else {
          bgImage = bytes;
        }
      });
    }
  }

  Future<void> downloadPoster() async {
    final image = await screenshotController.capture();
    if (image == null) return;

    if (kIsWeb) {
      final blob = html.Blob([image]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'poster.png')
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      if (await Permission.storage.request().isGranted) {
        final directory = await getApplicationDocumentsDirectory();
        final path =
            '${directory.path}/poster_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = io.File(path);
        await file.writeAsBytes(image);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Poster saved at $path')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shiv Poster Generator")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Screenshot(
              controller: screenshotController,
              child: Container(
                width: 320,
                height: 440,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: bgImage != null
                        ? MemoryImage(bgImage!)
                        : const AssetImage('assets/shiv_bg.jpg')
                              as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 100,
                      left: 20,
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white,
                        backgroundImage: userImage != null
                            ? MemoryImage(userImage!)
                            : null,
                        child: userImage == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => pickImage(true),
              child: const Text("Upload Profile Image"),
            ),
            ElevatedButton(
              onPressed: () => pickImage(false),
              child: const Text("Upload Background Image"),
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Enter your name'),
              onChanged: (val) => setState(() => userName = val),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => setState(() => showDownload = true),
              child: const Text("Submit"),
            ),
            if (showDownload)
              ElevatedButton(
                onPressed: downloadPoster,
                child: const Text("Download Poster"),
              ),
          ],
        ),
      ),
    );
  }
}
