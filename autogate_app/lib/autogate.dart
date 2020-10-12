import 'package:firebase_database/firebase_database.dart';

class AutoGate {
  String gateid;
  String desc;

  AutoGate(this.gateid, this.desc);

  AutoGate.fromSnapshot(DataSnapshot snapshot)
      : gateid = snapshot.value["gateid"],
        desc = snapshot.value["desc"];

  toJson() {
    return {
      "gateid": gateid,
      "desc": desc,
    };
  }
}
