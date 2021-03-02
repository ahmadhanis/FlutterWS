import 'package:get/state_manager.dart';

class Book {
  String title, bookid, description, type, price;

  Book({
    this.title,
    this.bookid,
    this.description,
    this.type,
    this.price,
  });
  final isFavorite = false.obs;
  
}
