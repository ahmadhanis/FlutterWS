import 'package:fluttergetx/models/book.dart';
import 'package:http/http.dart' as http;

class RemoteServices {
  static var client = http.Client();

  static Future<List<Book>> fetchBooks() async {
    var response =
        await client.get('https://slumberjer.com/mylibrary/php/loadbooks.php');
    if (response.statusCode == 200) {
      if (response.body == "nodata") {
        return null;
      } else {
        var jsonString = response.body;
        print("IN remoteservices" + jsonString);
        return booksFromJson(jsonString);
      }
    } else {
      //show error message
      return null;
    }
  }

  static Future<String> deleteBook(bookid) async {
    var response = await client.post(
        'https://slumberjer.com/mylibrary/php/deletebook.php',
        body: {"bookid": bookid});
    if (response.statusCode == 200) {
      var resp = response.body;
      return resp;
    } else {
      //show error message
      return null;
    }
  }

  static Future<String> newBook(book) async {
    var response = await client
        .post('https://slumberjer.com/mylibrary/php/insertbook.php', body: {
      "email": book.email,
      "booktitle": book.title,
      "booktype": book.type,
      "bookdesc": book.description,
      "bookprice":book.price,
      "bookrating":book.rating,
      "encoded_string": book.base64Image,
    });
    if (response.statusCode == 200) {
      var resp = response.body;
      return resp;
    } else {
      //show error message
      return null;
    }
  }
}
