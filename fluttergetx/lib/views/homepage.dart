import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttergetx/controllers/books_controller.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'bookstile.dart';
import 'newbook_page.dart';

class HomePage extends StatelessWidget {
  final bookController = Get.put(BooksController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Icon(
          Icons.arrow_back_ios,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'LibX',
                    style: TextStyle(
                        fontFamily: 'avenir',
                        fontSize: 32,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.add_circle),
                    onPressed: () async {
                      await Get.to(() => NewBookPage());
                      BooksController bookController = Get.put(BooksController());
                      bookController.loadBooks();
                    }),
                    IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      BooksController bookController = Get.put(BooksController());
                      bookController.loadBooks();
                    }),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (bookController.isLoading.value)
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text(
                      bookController.statusMsj.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ));
              else if (bookController.bookList == null) {
                return Center(
                    child: Text(
                  bookController.statusMsj.toString(),
                  style: TextStyle(fontSize: 20),
                ));
              } else
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  itemCount: bookController.bookList.length,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  itemBuilder: (context, index) {
                    return BooksTile(bookController.bookList[index]);
                  },
                  staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                );
            }),
          )
        ],
      ),
    );
  }
}
