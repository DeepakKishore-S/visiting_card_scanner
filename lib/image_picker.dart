import 'package:image_picker/image_picker.dart';

Future<void> pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.camera);

  if (pickedFile != null) {
    // Process the picked image
  } else {
    print('No image selected.');
  }
}
