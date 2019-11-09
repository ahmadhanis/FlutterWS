import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'mainscreen.dart';

class JobDetail extends StatefulWidget {
  //final String email,jobid;
  final String useremail,
      jobid,
      jobprice,
      jobdesc,
      jobowner,
      jobimage,
      jobtitle,
      joblatitude,
      joblongitude,
      jobtime,
      jobradius;

  const JobDetail(
      {Key key,
      this.useremail,
      this.jobid,
      this.jobprice,
      this.jobdesc,
      this.jobowner,
      this.jobimage,
      this.jobtitle,
      this.joblatitude,
      this.joblongitude,
      this.jobtime,
      this.jobradius})
      : super(key: key);

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
                  widget.jobimage,
                  widget.jobtitle,
                  widget.jobdesc,
                  widget.jobprice,
                  widget.joblatitude,
                  widget.joblongitude,
                  widget.jobtime),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            email: widget.useremail,
            radius: widget.jobradius,
          ),
        ));
    return Future.value(false);
  }
}

class DetailInterface extends StatefulWidget {
 final String jobimage,
      jobtitle,
      jobdesc,
      jobprice,
      joblatitude,
      joblongitude,
      jobtime;

  DetailInterface(this.jobimage, this.jobtitle, this.jobdesc, this.jobprice,
      this.joblatitude, this.joblongitude, this.jobtime);

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
          double.parse(widget.joblatitude), double.parse(widget.joblongitude)),
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
              'http://slumberjer.com/myhelper/images/${widget.jobimage}.jpg',
              fit: BoxFit.fill),
        ),
        SizedBox(
          height: 10,
        ),
        Text(widget.jobtitle.toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        Text(widget.jobtime),
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
                  Text(widget.jobdesc),
                ]),
                TableRow(children: [
                  Text("Job Price",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("RM" + widget.jobprice),
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

  void _onAcceptJob() {}
}
