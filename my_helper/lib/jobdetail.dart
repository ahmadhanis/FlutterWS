import 'package:flutter/material.dart';

import 'mainscreen.dart';

class JobDetail extends StatefulWidget {
  //final String email,jobid;
  final String useremail,
      jobid,
      jobprice,
      jobdesc,
      jobowner,
      jobimage,
      jobtitle;

  const JobDetail(
      {Key key,
      this.useremail,
      this.jobid,
      this.jobprice,
      this.jobdesc,
      this.jobowner,
      this.jobimage,
      this.jobtitle})
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
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: DetailInterface(widget.jobimage, widget.jobtitle,
                  widget.jobdesc, widget.jobprice),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(email: widget.useremail),
        ));
    return Future.value(false);
  }
}

class DetailInterface extends StatefulWidget {
  String jobimage, jobtitle, jobdesc, jobprice;

  DetailInterface(
      String jobimage, String jobtitle, String jobdesc, String jobprice) {
    this.jobimage = jobimage;
    this.jobtitle = jobtitle;
    this.jobdesc = jobdesc;
    this.jobprice = jobprice;
    print(jobprice);
  }

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(),
        Container(
          width: 400,
          height: 320,
          child: Image.network(
              'http://slumberjer.com/myhelper/images/${widget.jobimage}.jpg',
              fit: BoxFit.fill),
        ),
        SizedBox(
          height: 10,
        ),
        Text(widget.jobtitle.toUpperCase(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Text("Job Description:   ",
                  style: TextStyle(
                    fontSize: 18,fontWeight: FontWeight.bold
                  )),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  widget.jobdesc,
                  maxLines: 3,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 18,
                    
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Job Price:  ",
                  style: TextStyle(
                    fontSize: 18,fontWeight: FontWeight.bold
                  )),
              SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text("RM" + widget.jobprice,
                    style: TextStyle(
                      fontSize: 18,
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 350,
                child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                height: 50,
                child: Text('ACCEPT JOB',style: TextStyle(
                  fontSize: 18
                ),),
                color: Color.fromRGBO(159, 30, 99, 1),
                textColor: Colors.white,
                elevation: 5,
                onPressed: _onAcceptJob,
              ),
              ),
              
            ],
          ),
        ),
      ],
    );
  }

  void _onAcceptJob() {}
}
