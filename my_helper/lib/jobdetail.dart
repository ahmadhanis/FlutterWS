import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_helper/user.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'job.dart';
import 'mainscreen.dart';

class JobDetail extends StatefulWidget {
  final Job job;
  final User user;

  const JobDetail({Key key, this.job, this.user}) : super(key: key);

  @override
  _JobDetailState createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('JOB DETAILS'),
            backgroundColor: Color.fromRGBO(159, 30, 99, 1),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: DetailInterface(
                job: widget.job,
                user: widget.user,
              ),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            user: widget.user,
          ),
        ));
    return Future.value(false);
  }
}

class DetailInterface extends StatefulWidget {
  final Job job;
  final User user;
  DetailInterface({this.job, this.user});

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _myLocation;

  @override
  void initState() {
    super.initState();
    _myLocation = CameraPosition(
      target: LatLng(
          double.parse(widget.job.joblat), double.parse(widget.job.joblon)),
      zoom: 17,
    );
    print(_myLocation.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(),
        Container(
          width: 280,
          height: 200,
          child: Image.network(
              'http://slumberjer.com/myhelper/images/${widget.job.jobimage}.jpg',
              fit: BoxFit.fill),
        ),
        SizedBox(
          height: 10,
        ),
        Text(widget.job.jobtitle.toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        Text(widget.job.jobtime),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Table(children: [
                TableRow(children: [
                  Text("Job Description",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.job.jobdes),
                ]),
                TableRow(children: [
                  Text("Job Price",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("RM" + widget.job.jobprice),
                ]),
                TableRow(children: [
                  Text("Job Location",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("")
                ]),
              ]),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 120,
                width: 340,
                child: GoogleMap(
                  // 2
                  initialCameraPosition: _myLocation,
                  // 3
                  mapType: MapType.normal,
                  // 4

                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
              Container(
                width: 350,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  height: 40,
                  child: Text(
                    'ACCEPT JOB',
                    style: TextStyle(fontSize: 16),
                  ),
                  color: Color.fromRGBO(159, 30, 99, 1),
                  textColor: Colors.white,
                  elevation: 5,
                  onPressed: _onAcceptJob,
                ),
                //MapSample(),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _onAcceptJob() {
    print("Accept Job");
    _showDialog();
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Accept " + widget.job.jobtitle),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                acceptRequest(widget.job.jobid);
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> acceptRequest(String jobid) async {
    String urlLoadJobs = "http://slumberjer.com/myhelper/php/accept_job.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Accepting Job");
    pr.show();
    http.post(urlLoadJobs, body: {
      "jobid": widget.job.jobid,
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            pr.dismiss();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(
                user: widget.user,
              ),
            ));
        //init();
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            pr.dismiss();
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }
}
