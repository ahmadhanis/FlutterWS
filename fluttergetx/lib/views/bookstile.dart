import 'package:flutter/material.dart';
import 'package:fluttergetx/controllers/books_controller.dart';
import 'package:fluttergetx/models/book.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BooksTile extends StatelessWidget {
  final Book book;
  BooksTile(this.book);
  final bookController = Get.put(BooksController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () => _deleteDialog(),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                      height: 180,
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://slumberjer.com/mylibrary/images/${book.bookid}.jpg",
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, error) => new Icon(
                          Icons.broken_image,
                        ),
                      )),
                  Positioned(
                    right: 0,
                    child: Obx(() => CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: book.isFavorite.value
                                ? Icon(Icons.favorite_rounded)
                                : Icon(Icons.favorite_border),
                            onPressed: () {
                              book.isFavorite.toggle();
                            },
                          ),
                        )),
                  )
                ],
              ),
              SizedBox(height: 8),
              Text(
                book.title,
                maxLines: 2,
                style: TextStyle(
                    fontFamily: 'avenir', fontWeight: FontWeight.w800),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              if (book.rating != null)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        book.rating.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 8),
              Text('\RM ${book.price}',
                  style: TextStyle(fontSize: 26, fontFamily: 'avenir')),
            ],
          ),
        ),
      ),
    );
  }

  _deleteDialog() {
    print("Hello" + book.bookid);
    Get.dialog(
      AlertDialog(
          title: new Text(
            "Delete " + book.title + "?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Are you sure? ",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  new TextButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () async {
                      navigator.pop();
                      //book.delete(book.bookid);
                      bookController.deleteBook(book);
                    },
                  ),
                  new TextButton(
                    child: new Text(
                      "No",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      navigator.pop();
                    },
                  ),
                ],
              )
            ],
          )),
      barrierDismissible: true,
    );
  }
}