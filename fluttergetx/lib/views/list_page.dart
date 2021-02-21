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
        backgroundColor: Colors.teal,
        body: SafeArea(
          child: Column(children: <Widget>[
            Expanded(child: GetX<BooksController>(builder: (controller) {
              return ListView.builder(
                  itemCount: controller.books.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${controller.books[index].title}',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    Text(
                                        '${controller.books[index].description}'),
                                    Text('\$${controller.books[index].price}',
                                        style: TextStyle(fontSize: 24)),
                                  ],
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    cartController
                                        .addToCart(controller.books[index]);
                                  },
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  child: Text('Add to Cart'),
                                ),
                              ],
                            ),
                            Obx(() => IconButton(
                                  icon: controller.books[index].isFavorite.value
                                      ? Icon(Icons.check_box_rounded)
                                      : Icon(Icons
                                          .check_box_outline_blank_outlined),
                                  onPressed: () {
                                    controller.books[index].isFavorite.toggle();
                                  },
                                ))
                          ],
                        ),
                      ),
                    );
                  });
            })),
            SizedBox(height: 10),
            GetX<CartController>(builder: (controller) {
              return Text(
                'Total amount: \$ ${controller.totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 32, color: Colors.white),
              );
            }),
            SizedBox(height: 50),
          ]),
        ),
      ),
    );
  }
}
