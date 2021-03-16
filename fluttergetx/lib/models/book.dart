import 'dart:convert';
import 'package:get/state_manager.dart';

List<Book> booksFromJson(String str) =>
    List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));
String booksToJson(List<Book> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
  String title, bookid, description, type, price, rating, base64Image,email;

  Book({
    this.title,
    this.bookid,
    this.description,
    this.type,
    this.price,
    this.rating,
    this.base64Image,
    this.email,
  });

  final isFavorite = false.obs;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
      bookid: json["bookid"],
      title: json["title"],
      description: json["description"],
      type: json["type"],
      price: json["price"],
      rating: json["rating"]);

  Map<String, dynamic> toJson() => {
        "bookid": bookid,
        "title": title,
        "description": description,
        "type": type,
        "price": price,
        "rating": rating,
      };
}
