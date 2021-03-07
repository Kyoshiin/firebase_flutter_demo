import 'dart:io'; // not html
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
class ContactDetails extends StatefulWidget {
  Map<String, dynamic> data;
  ContactDetails(this.data);

  @override
  _ContactDetailsState createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  File url;
  final picker = ImagePicker();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            GestureDetector(
                child: CircleAvatar(
                  backgroundImage: url == null
                      ? AssetImage('images/ic_launcher.png')
                      : FileImage(url),
                  radius: 50,
                  backgroundColor: Colors.cyan[100],
                  // child: url == null
                  //     ? Icon(Icons.person, size: 40)
                  //     : Image.file(url,
                  //     fit: BoxFit.fill,
                  //   width: 60,
                  //   height: 60,
                  // ),
                ),
                onTap: () => openModal() //changeImage(),
            ),

            Text(widget.data['name']),
            Text(widget.data['phone'].toString()),
            Text(widget.data['email']),
          ],
        ),
      ),
    );
  }

  changeImage(ImageSource src) async {
    try {
      final _pickedFile = await picker.getImage(source: src);
      if (_pickedFile == null) return;

      if (src == ImageSource.camera) {
        // if camera then store
        //location provided by path provider
        final _extDir = await getExternalStorageDirectory();
        final imgPath = '${_extDir.path}/all_images'; // path location
        final imgDir = await new Directory(imgPath).create();
        File tmp = File(_pickedFile.path); // temp file from image
        print(imgDir.path); // for debug

        if (imgDir.isAbsolute) {
          tmp = await tmp.copy("$imgPath/IMG_${DateTime.now()}.jpg");
        }
      }
      setState(() {
        url = File(_pickedFile.path);
      });
    } catch (e) {
      print(e);
    }
  }

  /// Bottom modal for options
  openModal() {
      showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            color: Colors.cyan,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(Icons.camera_alt_outlined),
                    onPressed: () {
                      changeImage(ImageSource.camera);
                      Navigator.pop(context); // for dismissing the bottomsheet
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      icon: Icon(Icons.folder),
                      onPressed: () {
                        changeImage(ImageSource.gallery);
                        Navigator.pop(context); // for dismissing the bottomsheet
                      }),
                )
              ],
            ),
          );
        },
      );
  }

  Future<void> uploadFile(String filepath) async{
    File file = File(filepath);

    try{
      await FirebaseStorage.instance
          .ref('uploadImage/img1')
          .putFile(file);
    }on FirebaseException catch(e){}
  }

  Future<void> downloadURLExample() async{
    String downloadURL = await FirebaseStorage.instance
    .ref('uploadImage/img1')
    .getDownloadURL();
  }
}
