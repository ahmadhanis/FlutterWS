import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter/services.dart';

List<CameraDescription> cameras;
String pathpic = 'assets/images/profile.png';

class RegisterUser extends StatefulWidget {
  final String imagePath;
  @override
  _RegisterUserState createState() => _RegisterUserState();
  const RegisterUser({Key key, this.imagePath}) : super(key: key);
}

class _RegisterUserState extends State<RegisterUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New User Registration'),
        backgroundColor: Colors.black,
      ),
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: _onCamera,
              child: Image.asset(
                pathpic,
                width: 180,
                height: 180,
              ),
            ),
            TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                )),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone',
                )),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              minWidth: 300,
              height: 50,
              child: Text('Register'),
              color: Colors.black,
              textColor: Colors.white,
              elevation: 15,
              onPressed: _onRegister,
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
                onTap: _onBackPress,
                child:
                    Text('Already Register', style: TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );
  }

  void _onRegister() {}

  void _onBackPress() {
    Navigator.of(context).pop();
    //MaterialPageRoute(builder: (context) => LoginPage());
  }

  void _onCamera() async {
    print('Camera');
    cameras = await availableCameras();
    final firstCamera = cameras.first;
    runApp(
      MaterialApp(
        home: TakePictureScreen(
          // Pass the appropriate camera to the TakePictureScreen widget.
          camera: firstCamera,
        ),
      ),
    );
  }
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('Take a picture'),
        backgroundColor: Colors.red,
      ),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            ); //${DateTime.now()}.png

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);
            print(path);
            pathpic = path;
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterUserAfter(imagePath: path),
                ));
            // If the picture was taken, display it on a new screen.
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    ));
  }
}

class RegisterUserAfter extends StatefulWidget {
  final String imagePath;
  @override
  RegisterUserAfterState createState() => RegisterUserAfterState();
  const RegisterUserAfter({Key key, this.imagePath}) : super(key: key);
}

class RegisterUserAfterState extends State<RegisterUserAfter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New User Registration'),
        backgroundColor: Colors.black,
      ),
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: _onCamera,
              child: Image.file(
                File(pathpic),
                width: 180,
                height: 180,
              ),
            ),
            TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                )),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone',
                )),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              minWidth: 300,
              height: 50,
              child: Text('Register'),
              color: Colors.black,
              textColor: Colors.white,
              elevation: 15,
              onPressed: _onRegister,
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
                onTap: _onBackPress,
                child:
                    Text('Already Register', style: TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );
  }

  void _onRegister() {}

  void _onBackPress() {
    Navigator.of(context).pop();
    //MaterialPageRoute(builder: (context) => LoginPage());
  }

  void _onCamera() async {
    print('Camera');
    cameras = await availableCameras();
    final firstCamera = cameras.first;
    runApp(
      MaterialApp(
        home: TakePictureScreen(
          // Pass the appropriate camera to the TakePictureScreen widget.
          camera: firstCamera,
        ),
      ),
    );
  }
}
