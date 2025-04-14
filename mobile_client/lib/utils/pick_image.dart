import 'package:image_picker/image_picker.dart';

Future<String?> pickImageFromGallery() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  return image?.path;
}

Future<String?> pickImageFromCamera() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.camera);

  return image?.path;
}
