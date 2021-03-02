import 'package:fluttergetx/models/book.dart';
import 'package:get/state_manager.dart';

class CartController extends GetxController {
  var cartItems = List<Book>().obs;
   
  int get count => cartItems.length;
  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + double.parse(item.price));

  addToCart(Book product) {
    cartItems.add(product);
  }
}
