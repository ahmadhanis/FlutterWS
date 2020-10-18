import 'package:firebase_database/firebase_database.dart';

class AutoGate {
  String gateid;
  String desc;
  String gtime;

  AutoGate(this.gateid, this.desc,this.gtime);

  AutoGate.fromSnapshot(DataSnapshot snapshot)
      : gateid = snapshot.value["gateid"],
        desc = snapshot.value["desc"],
        gtime = snapshot.value["gtime"];

  toJson() {
    return {
      "gateid": gateid,
      "desc": desc,
      "gtime": gtime,
    };
  }
}
