// home_page_view.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relt/model/home_pagee.dart';
import 'package:relt/view/home_page/methods/all_product.dart';
import 'package:relt/view/home_page/widgets/drawer.dart';
import 'package:relt/view/home_page/widgets/name_tile.dart';

import 'package:relt/view/productdetail.dart';
import 'package:relt/view/search/search_view.dart'; 




class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final HomePageModel _model = HomePageModel();

  @override
  void initState() {
    super.initState();
    _initializeCurrentUser();
  }

  Future<void> _initializeCurrentUser() async {
    await _model.getCurrentUser();
    setState(() {});
  }
 
  void _navigateToSearchScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Search()),
    );
  }

  void _navigateToProductDetails(DocumentSnapshot productSnapshot) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductDetailScreen(productSnapshot)),
    );
  }


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: Text(
            "WELCOME: ${_model.currentUser?.email ?? ''}",
            style: const TextStyle(fontSize: 20),
          ),
        ),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: _model.signUserOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: buildDrawer(context),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 11,
            color: Colors.grey[900],
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: InkWell(
                  onTap: _navigateToSearchScreen,
                  child: const Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(Icons.search),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Search for Products, Brands and More',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SectionTitle(title: 'Featured'),
                  slider(screenHeight, screenWidth,_navigateToProductDetails,_model.getFeaturedData()), 
                  const SectionTitle(title: 'Recently Viewed'),
                  recentproduct(screenHeight, screenWidth,_navigateToProductDetails,_model.getRecentlyData()),
                  const SectionTitle(title: 'All products'),
                  allproduct(screenHeight, screenWidth,_navigateToProductDetails,_model.getAllProductsData()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

 

  


}
