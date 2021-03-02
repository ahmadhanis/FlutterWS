import 'dart:convert';

import 'package:fluttergetx/models/book.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BooksController extends GetxController {
  List books = List<Book>().obs;

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
    print("in INIT");
  }

  void fetchBooks() async {
    print("in FETCH");
    await http.post("https://slumberjer.com/mylibrary/php/loadbooks.php",
        body: {}).then((res) {
      if (res.body == null) {
        books = null;
      } else {
        var jsondata = json.decode(res.body);
        var listbooks = jsondata["books"];
        for (int i = 0; i < listbooks.length; i++) {
          books.add(Book(
              title: listbooks[i]['title'],
              bookid: listbooks[i]['bookid'],
              description: listbooks[i]['description'],
              type: listbooks[i]['type'],
              price: listbooks[i]['price']));
        }
      }
    }).catchError((err) {
      print(err);
    });
  }

  void deleteBook(String bookid) async {
    print("in Delete");
    await http
        .post("https://slumberjer.com/mylibrary/php/deletebook.php", body: {
      "bookid": bookid,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
      } else {}
    }).catchError((err) {
      print(err);
    });
  }
}
