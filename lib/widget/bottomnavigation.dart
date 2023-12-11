import 'package:dhurmaati/model/cartModel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class BottomMenu extends StatelessWidget {
  final selectedIndex;
  ValueChanged<int> onClicked;
  BottomMenu({this.selectedIndex, required this.onClicked});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black45,
      currentIndex: selectedIndex, // the variable is undefined
      onTap: onClicked,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: ScopedModel.of<CartModel>(context, rebuildOnChange: true)
                      .cart
                      .length ==
                  0
              ? Icon(Icons.shopping_cart)
              : new Stack(
                  children: <Widget>[
                    new Icon(Icons.shopping_cart),
                    new Positioned(
                      right: 0,
                      // bottom: 10,
                      child: new Container(
                        // padding: EdgeInsets.all(1),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          '${ScopedModel.of<CartModel>(context, rebuildOnChange: true).cart.length}',
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.view_list_outlined), label: 'Orders'),

        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),

        // BottomNavigationBarItem(icon: Icon(Icons.library_add), label: "List"),
      ],
    );
  }
}
