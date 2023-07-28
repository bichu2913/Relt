import 'package:flutter/material.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:relt/view/cart/cart_screen.dart';
import 'package:relt/view/categoriespages/categories.dart';
import 'package:relt/view/favourites/favorite_screen.dart';
import 'package:relt/view/home_page/home_page.dart';
import 'package:relt/view/oredrstatus/orderstatus.dart';
import 'bottom_navigation_provider.dart'; // Import the provider class

class BottomNavigationScreen extends StatelessWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use ChangeNotifierProvider to provide the BottomNavigationProvider
    return ChangeNotifierProvider(
      create: (context) => BottomNavigationProvider(),
      child: Consumer<BottomNavigationProvider>(
        builder: (context, provider, _) {
          int currentIndex = provider.selectedIndex;
          List<Widget> pages = [
            const HomePageView(),
            const Maincategory(),
             const CartScreen(),
            const WishlistScreen(),
            const OrderStatusPage(),
          ];

          return Scaffold(
            extendBody: true,
            body: pages[currentIndex],
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: FloatingNavbar(
                unselectedItemColor: Colors.black,
                borderRadius: 45,
                width: MediaQuery.of(context).size.width / 1.1,
                itemBorderRadius: 45,
                selectedBackgroundColor: Colors.black,
                selectedItemColor: Colors.white,
                backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                currentIndex: currentIndex,
                onTap: (newCurrentIndex) {
                  // Use the provider to change the selected index
                  provider.changeIndex(newCurrentIndex);
                },
                items: <FloatingNavbarItem>[
                  FloatingNavbarItem(
                    icon: Icons.home_filled,
                  ),
                  FloatingNavbarItem(
                    icon: Icons.category,
                  ),
                  FloatingNavbarItem(
                    icon: Icons.shopping_cart,
                  ),
                  FloatingNavbarItem(
                    icon: Icons.favorite,
                  ),
                  FloatingNavbarItem(
                    icon: Icons.shopping_bag,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}







