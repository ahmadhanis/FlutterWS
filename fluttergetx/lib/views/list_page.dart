import 'package:flutter/material.dart';
import 'package:fluttergetx/controllers/books_controller.dart';
import 'package:fluttergetx/controllers/cart_controller.dart';
import 'package:get/get.dart';

class ListPage extends StatelessWidget {
  final bookController = Get.put(BooksController());
  final cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: () {
              
          },
        ),
        backgroundColor: Colors.teal,
        body: SafeArea(
          child: Column(children: <Widget>[
            Expanded(
                flex: 9,
                child: GetX<BooksController>(builder: (controller) {
                  return ListView.builder(
                      itemCount: controller.books.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onLongPress: () =>
                              _deleteBookDialog(index, context, controller),
                          child: Card(
                            margin: const EdgeInsets.all(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Obx(() => Text(
                                                  '${controller.books[index].title}',
                                                  style:
                                                      TextStyle(fontSize: 24),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                            Obx(() => Text(
                                                  '${controller.books[index].description}' +
                                                      '\n\n',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                )),
                                            Obx(() => Text(
                                                '\RM ${controller.books[index].price}',
                                                style:
                                                    TextStyle(fontSize: 20))),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            RaisedButton(
                                              onPressed: () {
                                                cartController.addToCart(
                                                    controller.books[index]);
                                              },
                                              color: Colors.blue,
                                              textColor: Colors.white,
                                              child: Text('Add to Cart'),
                                            ),
                                            Obx(() => IconButton(
                                                  icon: controller.books[index]
                                                          .isFavorite.value
                                                      ? Icon(
                                                          Icons.favorite,
                                                          color: Colors.red,
                                                        )
                                                      : Icon(Icons
                                                          .favorite_border_outlined),
                                                  onPressed: () {
                                                    controller
                                                        .books[index].isFavorite
                                                        .toggle();
                                                  },
                                                ))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                })),
            SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: GetX<CartController>(builder: (controller) {
                return Text(
                  'Total amount: \$ ${controller.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                );
              }),
            ),
          ]),
        ),
      ),
    );
  }

  _deleteBookDialog(
      int index, BuildContext context, BooksController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Delete " + '${controller.books[index].title}' + "?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are your sure? ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                controller.deleteBook(controller.books[index].bookid);
                controller.onStart();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
