import 'package:firebase_database/firebase_database.dart';

class User {
  String name;
  String email;
  String phone;

  User(this.name, this.email, this.phone);

  User.fromSnapshot(DataSnapshot snapshot)
      : name = snapshot.value["name"],
        email = snapshot.value["email"],
        phone = snapshot.value["phone"];

  toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
    };
  }
}
