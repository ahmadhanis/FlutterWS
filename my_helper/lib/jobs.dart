class Jobs {
  Source source;
  String jobid;
  String jobtitle;
  String jobowner;
  String jobdescription;
  String jobtime;

  Jobs(
      {this.source,
      this.jobid,
      this.jobtitle,
      this.jobowner,
      this.jobdescription,
      this.jobtime});

  factory Jobs.fromJson(Map<String, dynamic> json) {
    return Jobs(
        source: Source.fromJson(json["source"]),
        jobid: json["jobid"],
        jobtitle: json["jobtitle"],
        jobowner: json["jobowner"],
        jobdescription: json["jobdescription"],
        jobtime: json["jobtime"]);
  }
}

class Source {
  String jobid;
  String jobowner;

  Source({this.jobid, this.jobowner});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      jobid: json["jobid"] as String,
      jobowner: json["jobowner"] as String,
    );
  }
}
