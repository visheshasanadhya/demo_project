import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  static Future<Uint8List?> pickImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    return file != null ? await file.readAsBytes() : null;
  }
}
