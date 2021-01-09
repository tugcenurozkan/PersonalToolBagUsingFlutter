import 'dart:typed_data';
import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// void main() {
//   runApp(MaterialApp(
//     title: "",
//     home: ImagesGalery(),
//   ));
// }

class ImagesGalery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Images Galery"),
      ),
      body: Container(
        color: Colors.grey[850],
        child: Center(
          child: GridView.builder(
              itemCount: 12, //12 tane resim mevcut
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                return ImagesGridItem(
                    index + 1); //index şart image yükledi mi bilmek için
              }),
        ),
      ),
    );
  }
}

class ImagesGridItem extends StatefulWidget {
  int _index;

  ImagesGridItem(index) {
    this._index =
        index; //contructor referans verildi firebase storage a resimleri alabilmek için
  }

  @override
  _ImagesGridItemState createState() => _ImagesGridItemState();
}

class _ImagesGridItemState extends State<ImagesGridItem> {
  Uint8List imagesFile;

  firebase_storage.Reference photoReference =
      firebase_storage.FirebaseStorage.instance.ref().child("photos");
  getImages() {
    int MAX_SIZE = 7 * 1024 * 1024;
    photoReference
        .child("image_${widget._index}.jpg")
        .getData(MAX_SIZE)
        .then((data) {
      this.setState(() {
        imagesFile = data;
      });
    }).catchError((error) {});
  }

  Widget ImageControl() {
    if (imagesFile == null) {
      return Center(child: Text("Veri Yok"));
    } else {
      return Image.memory(
        imagesFile,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getImages();
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: ImageControl(),
    );
  }
}
