import 'package:flutter/material.dart';
import 'package:relt/Screen/cart/cartscreen.dart';
import 'package:relt/Screen/categoriespages/categories.dart';
import 'package:relt/Screen/favourites/favouritescreen.dart';
import 'package:relt/Screen/homepage.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  BottomNavigationScreenState createState() => BottomNavigationScreenState();
}

class BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomePage(),
    const Maincategory(),
    const CartScreen(),
    const WishlistScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  _onTabTapped(0);
                },
              ),
              IconButton(
                icon: const Icon(Icons.category),
                onPressed: () {
                  _onTabTapped(1);
                },
              ),
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  _onTabTapped(2);
                },
              ),
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  _onTabTapped(3);
                },
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}


