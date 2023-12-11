import 'package:scoped_model/scoped_model.dart';

class SubscriptionModel extends Model {
  List<Productss> cart = [];
  double totalCartValue = 0;

  int get total => cart.length;

  void addProduct(product) {
    int index = cart.indexWhere((i) => i.id == product.id);
    print(index);
    if (index != -1)
      updateProduct(product, product.qty + 1);
    else {
      cart.add(product);
      calculateTotal();
      notifyListeners();
    }
  }

  void removeProduct(product) {
    int index = cart.indexWhere((i) => i.id == product.id);
    cart[index].qty = 1;
    cart.removeWhere((item) => item.id == product.id);
    calculateTotal();
    notifyListeners();
  }

  void updateProduct(product, qty) {
    int index = cart.indexWhere((i) => i.id == product.id);
    cart[index].qty = qty;
    if (cart[index].qty == 0) removeProduct(product);

    calculateTotal();
    notifyListeners();
  }

  void clearCart() {
    cart.forEach((f) => f.qty = 1);
    cart = [];
    notifyListeners();
  }

  void calculateTotal() {
    totalCartValue = 0;
    cart.forEach((f) {
      totalCartValue += f.price * f.qty;
    });
  }
}

class Productss {
  int id;
  String title;
  String imgUrl;
  String description;
  double price;
  int qty;
  bool subscribe;

  Productss(
      {required this.id,
      required this.title,
      required this.price,
      required this.description,
      required this.qty,
      required this.subscribe,
      required this.imgUrl});
  Map toJson() => {
        'product_id': id,
        'product_name': title,
        'price': price,
        'quantity': qty,
        'subscription': subscribe,
        'image_url': imgUrl
      };
}
