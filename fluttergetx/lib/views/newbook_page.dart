import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttergetx/controllers/books_controller.dart';
import 'package:get/get.dart';

class NewBookPage extends StatelessWidget {
  final bookController = Get.put(BooksController());

  @override
  Widget build(BuildContext context) {
    double screenHeight, screenWidth;
    File _image;
    String pathAsset = "assets/images/uum.png";
    List<String> listType = [
      "Novel",
      "Education",
      "Magazine",
      "Fiction",
      "Other",
    ].obs;
    TextEditingController booktitlectrl = new TextEditingController();
    TextEditingController bookdescctrl = new TextEditingController();
    String selectedType;

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
        child: Column(
          children: [
            Center(),
            GestureDetector(
                onTap: () => {_onPictureSelection()},
                child: Container(
                  height: screenHeight / 3.2,
                  width: screenWidth / 1.8,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _image == null
                          ? AssetImage(pathAsset)
                          : FileImage(_image),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      width: 3.0,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0) //         <--- border radius here
                        ),
                  ),
                )),
            SizedBox(height: 5),
            Text("Click image to take picture ",
                style: TextStyle(fontSize: 14.0, color: Colors.black)),
            SizedBox(height: 5),
            TextField(
                controller: booktitlectrl,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Book Title', icon: Icon(Icons.book))),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.menu_book, color: Colors.grey),
                SizedBox(width: 15),
                GetX<BooksController>(builder: (controller) {
                  return DropdownButton(
                    hint: Text(
                      'Book Type',
                      style: TextStyle(
                        color: Color.fromRGBO(253, 72, 13, 50),
                      ),
                    ),
                    onChanged: (newValue) {
                      
                    },
                    value: selectedType,
                    items: listType.map((selectedType) {
                      return DropdownMenuItem(
                        child: new Text(
                          selectedType,
                        ),
                        value: selectedType,
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
            TextField(
                controller: bookdescctrl,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                minLines: 5,
                decoration: InputDecoration(
                    labelText: 'Book Description', icon: Icon(Icons.notes))),
            SizedBox(height: 15),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              minWidth: screenWidth / 1.2,
              height: 50,
              child: Text('Insert New Book'),
              color: Colors.blueAccent,
              textColor: Colors.white,
              elevation: 15,
              onPressed: _insertNewBookDialog,
            ),
          ],
        ),
      ))),
    );
  }

  _onPictureSelection() {}

  void _insertNewBookDialog() {}
}
