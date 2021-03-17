import 'package:flutter/material.dart';
import 'package:fluttergetx/models/book.dart';
import 'package:fluttergetx/services/remote_services.dart';
import 'package:get/get.dart';

class BooksController extends GetxController {
  static BooksController get to => Get.find<BooksController>();

  var bookList = <Book>[].obs;
  var isLoading = true.obs;
  var statusMsj = "Loading".obs;
  final selected = "Novel".obs;

  void setSelected(String value) {
    selected.value = value;
  }

  TextEditingController booktitlectrl;
  TextEditingController bookdescctrl;
  TextEditingController bookpricectrl;

  List<String> listType = [
    "Novel",
    "Education",
    "Magazine",
    "Fiction",
    "Other",
  ];

  @override
  void onInit() {
    booktitlectrl = new TextEditingController();
    bookdescctrl = new TextEditingController();
    bookpricectrl = new TextEditingController();
    fetchBooks();
    super.onInit();
  }

  void fetchBooks() async {
    try {
      isLoading(true);
      var books = await RemoteServices.fetchBooks();
      if (books != null) {
        bookList.assignAll(books);
      } else {
        bookList = null;
        statusMsj("No data");
      }
    } finally {
      isLoading(false);
    }
  }

  void loadBooks() async {
    try {
      isLoading(true);
      var books = await RemoteServices.fetchBooks();
      if (books != null) {
        bookList.assignAll(books);
      } else {
        bookList = null;
        statusMsj("No data");
      }
    } finally {
      isLoading(false);
    }
  }

  void deleteBook(book) async {
    try {
      isLoading(true);
      var resp = await RemoteServices.deleteBook(book.bookid);
      if (resp == "success") {
        fetchBooks();
      }
      print(resp);
    } finally {
      isLoading(false);
    }
  }

  Future<String> newBook(book) async {
    try {
      isLoading(true);
      var resp = await RemoteServices.newBook(book);
      if (resp == "success") {
        fetchBooks();
      }
      return resp;
    } finally {
      isLoading(false);
    }
  }
}
