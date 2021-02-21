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
  }

  void fetchBooks() async {
    await http.post("https://slumberjer.com/mylibrary/php/loadbooks.php",
        body: {}).then((res) {
      if (res.body == null) {
        books = null;
      } else {
        var jsondata = json.decode(res.body);
        var listbooks = jsondata["books"];

        print(listbooks);
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
}
