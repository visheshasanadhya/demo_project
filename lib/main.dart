import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'utils/image_picker_util.dart';
import 'utils/download_util.dart';

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

  void handlePickImage(bool isProfile) async {
    final image = await ImagePickerUtil.pickImage();
    if (image != null) {
      setState(() {
        if (isProfile) {
          userImage = image;
        } else {
          bgImage = image;
        }
      });
    }
  }

  void handleDownload() async {
    await DownloadUtil.downloadPoster(context, screenshotController);
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
              onPressed: () => handlePickImage(true),
              child: const Text("Upload Profile Image"),
            ),
            ElevatedButton(
              onPressed: () => handlePickImage(false),
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
                onPressed: handleDownload,
                child: const Text("Download Poster"),
              ),
          ],
        ),
      ),
    );
  }
}
