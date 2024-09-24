import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class PostImageProvider with ChangeNotifier{
  List<String> imageList;

  PostImageProvider([
    this.imageList = const []
  ]);

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      imageList.add(image.path);
      notifyListeners();
    }
  }

  void deleteImage(int index){
    imageList.removeAt(index);
    notifyListeners();
  }
}