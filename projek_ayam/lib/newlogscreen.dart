import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
//import 'package:basic_utils/basic_utils.dart';
import 'user.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NewLogScreen extends StatefulWidget {
  final User user;

  const NewLogScreen({Key key, this.user}) : super(key: key);
  @override
  _NewLogScreenState createState() => _NewLogScreenState();
}

class _NewLogScreenState extends State<NewLogScreen> {
  double screenHeight, screenWidth;
  File _image;
  String pathAsset = 'assets/images/camera.png';
  final f = new DateFormat('dd-MM-yyyy hh:mm');

  TextEditingController desccontroller = new TextEditingController();
  TextEditingController _svrEditingController = new TextEditingController();
  TextEditingController _aliveEditingController = new TextEditingController();
  TextEditingController _deadEditingController = new TextEditingController();
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Log Baru'),
      ),
      body: Container(
          alignment: Alignment.topCenter,
          child: ListView(
            children: <Widget>[
              Center(
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(children: <Widget>[
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
                                        Radius.circular(
                                            5.0) //         <--- border radius here
                                        ),
                                  ),
                                )),
                            SizedBox(height: 5),
                            Text("Klik utk ambil gambar",
                                style: TextStyle(
                                    fontSize: 10.0, color: Colors.white)),
                            SizedBox(height: 5),
                            Card(
                                elevation: 10,
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(children: <Widget>[
                                      TextFormField(
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          focusNode: focus,
                                          onFieldSubmitted: (v) {
                                            FocusScope.of(context)
                                                .requestFocus(focus1);
                                          },
                                          controller: _svrEditingController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            labelText: 'Nama pelawat',
                                            icon: Icon(Icons.person),
                                          )),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Flexible(
                                            child: TextFormField(
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                              focusNode: focus1,
                                              onFieldSubmitted: (v) {
                                                FocusScope.of(context)
                                                    .requestFocus(focus2);
                                              },
                                              controller:
                                                  _aliveEditingController,
                                              keyboardType:
                                                  TextInputType.number,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                labelText: 'Bil Hidup',
                                                icon: Icon(
                                                    MdiIcons.emoticonHappy),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: TextFormField(
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                              focusNode: focus2,
                                              onFieldSubmitted: (v) {
                                                FocusScope.of(context)
                                                    .requestFocus(focus3);
                                              },
                                              controller:
                                                  _deadEditingController,
                                              keyboardType:
                                                  TextInputType.number,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                labelText: 'Bil Mati',
                                                icon:
                                                    Icon(MdiIcons.emoticonDead),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Ulasan anda",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: 150,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 0, 0, 0),
                                          child: TextFormField(
                                              maxLines: 10,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                              focusNode: focus3,
                                              controller: desccontroller,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              textInputAction:
                                                  TextInputAction.done,
                                              decoration: new InputDecoration(
                                                hintText:
                                                    "Beri ulasan ringkas.",
                                                contentPadding:
                                                    const EdgeInsets.all(5),

                                                fillColor: Colors.white,
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          5.0),
                                                  borderSide: new BorderSide(),
                                                ),

                                                //fillColor: Colors.green
                                              )),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        minWidth: 200,
                                        height: 40,
                                        child: Text('Simpan'),
                                        color:
                                            Color.fromRGBO(101, 255, 218, 50),
                                        textColor: Colors.black,
                                        elevation: 5,
                                        onPressed: newLogDialog,
                                      ),
                                    ])))
                          ]))))
            ],
          )),
    );
  }

  _onPictureSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            //backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              //color: Colors.white,
              height: screenHeight / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Ambil gambar dari:",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Kamera',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        color: Color.fromRGBO(101, 255, 218, 50),
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseCamera()},
                      )),
                      SizedBox(width: 10),
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Galeri',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        color: Color.fromRGBO(101, 255, 218, 50),
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: () => {
                          Navigator.pop(context),
                          _chooseGallery(),
                        },
                      )),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  void _chooseCamera() async {
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  void _chooseGallery() async {
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                //CropAspectRatioPreset.ratio3x2,
                //CropAspectRatioPreset.original,
                //CropAspectRatioPreset.ratio4x3,
                //CropAspectRatioPreset.ratio16x9
              ]
            : [
                //CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                //CropAspectRatioPreset.ratio3x2,
                //CropAspectRatioPreset.ratio4x3,
                //CropAspectRatioPreset.ratio5x3,
                //CropAspectRatioPreset.ratio5x4,
                //CropAspectRatioPreset.ratio7x5,
                //CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Resize',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void newLogDialog() {
    String desc = desccontroller.text;

    if (_image == null) {
      Toast.show("Sila ambil gambar dahulu!.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }
    if (desc == "") {
      Toast.show("Sila isi penerangan!.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Simpan log ini? ",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Anda pasti?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Ya",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _registerNewLog();
              },
            ),
            new FlatButton(
              child: new Text(
                "Tidak",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _registerNewLog() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Menyimpan...");
    await pr.show();
    final dateTime = DateTime.now();
    String base64Image = base64Encode(_image.readAsBytesSync());
    String urlLoadJobs = "https://slumberjer.com/ayam/php/new_log.php";
    await http.post(urlLoadJobs, body: {
      "icno": widget.user.icno,
      "supervisor": _svrEditingController.text,
      "alive": _aliveEditingController.text,
      "dead": _deadEditingController.text,
      "description": toBeginningOfSentenceCase(desccontroller.text),
      "imagename": widget.user.icno + "-${dateTime.microsecondsSinceEpoch}",
      "encoded_string": base64Image,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Berjaya.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        Navigator.of(context).pop();
      } else if (res.body == "done") {
        Toast.show("Telah log hari ini.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      } else {
        Toast.show("Gagal.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }
}
