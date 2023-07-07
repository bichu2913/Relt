import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relt/Screen/productdetail.dart';
import 'package:relt/Screen/search.dart';
import 'package:relt/firebase/firebasedata.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseService firebaseService = FirebaseService();
 
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 238, 94),
      appBar: AppBar( elevation: 0, 
        title: Center(
            child: Text(
              "WELCOME: ${user.email!}",
              style: const TextStyle(fontSize: 20),
            ),
          ),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout), 
          ),
        ],
      ),
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
                    color: Colors.white),
                child:  InkWell(
                  onTap:() {
                        Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Search()), // Navigate to Search screen
    );
                  }, 
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
                  const SectionTitle(title: 'NEW'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      
                      height: screenHeight * 0.3,
                      width: screenWidth,
                      child: FutureBuilder<List<DocumentSnapshot>>(
                        future: firebaseService.getProducts(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Text('No data available');
                          } else {
                            return NewCategoryTile(snapshotData: snapshot.data!);
                          }
                        },
                      ),
                    ),
                  ),
                
                   SizedBox(
                    
                    height: screenHeight * 0.5,
                    width: screenWidth,
                    child: FutureBuilder<List<DocumentSnapshot>>(
                      future: firebaseService.getFeatured(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text('No data available');
                        } else {
                          return GridCategoryTile(snapshotData: snapshot.data!);
                        }
                      },
                    ),
                  ),
                 
                  SizedBox(
                    
                    height: screenHeight * 0.5 ,
                    width: screenWidth,
                    child: FutureBuilder<List<DocumentSnapshot>>(
                      future: firebaseService.getrecentalyData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text('No data available');
                        } else {
                          return GridCategoryTile2(snapshotData: snapshot.data!);
                        }
                      },
                    ), 
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        
        style: const TextStyle(
        
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white ,
          
        ),
      ),
    ); 
  } 
}




class NewCategoryTile extends StatefulWidget {
  final List<DocumentSnapshot<Object?>> snapshotData;

  const NewCategoryTile({Key? key, required this.snapshotData}) : super(key: key);

  @override
  NewCategoryTileState createState() => NewCategoryTileState();
}

class NewCategoryTileState extends State<NewCategoryTile> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentPageIndex < widget.snapshotData.length - 1) {
        _pageController.nextPage(duration: const Duration(milliseconds: 1000), curve: Curves.ease);
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _navigateToProductDetails(DocumentSnapshot productSnapshot) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductDetailScreen( productSnapshot)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.snapshotData.length,
      onPageChanged: (index) {
        setState(() {
          _currentPageIndex = index; 
        });
      },
      itemBuilder: (context, index) {
        DocumentSnapshot productSnapshot = widget.snapshotData[index];

        String name = productSnapshot['name'] as String? ?? '';
        double price = (productSnapshot['price'] as num?)?.toDouble() ?? 0.0;
        List<dynamic>? imageUrls = productSnapshot['images'] as List<dynamic>?;

        String imageUrl = imageUrls != null && imageUrls.isNotEmpty ? imageUrls[0] as String? ?? '' : '';

        return GestureDetector(
          onTap: () => _navigateToProductDetails(productSnapshot),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  } 
}
class GridCategoryTile extends StatelessWidget {
  final List<DocumentSnapshot<Object?>> snapshotData;

  const GridCategoryTile({Key? key, required this.snapshotData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.8  , 
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.8 ,
            color: const Color(0xff2874F0), 
          ),
          Container(
            height: MediaQuery.of(context).size.height / 7,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.topCenter,
            child: Image.network(
              'https://rukminim1.flixcart.com/flap/800/178/image/e76ebd.jpg?q=90',
            ),
          ),
          Positioned( 
            top: MediaQuery.of(context).size.height / 65,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Featured Items',    
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('View All'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
  height: MediaQuery.of(context).size.height / 2 ,
  padding: const EdgeInsets.only(left: 8, right: 8),
  width: MediaQuery.of(context).size.width,
  child: Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    color: Colors.white,
    child: SingleChildScrollView(
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: snapshotData.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          DocumentSnapshot productSnapshot = snapshotData[index];

          String name = productSnapshot['name'] as String? ?? '';
          double price = (productSnapshot['price'] as num?)?.toDouble() ?? 0.0;
          List<dynamic>? imageUrls = productSnapshot['images'] as List<dynamic>?;

          String imageUrl = imageUrls != null && imageUrls.isNotEmpty ? imageUrls[0] as String? ?? '' : '';

          return buildItem(context, name, imageUrl, price);
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
      ),
    ),
  ),
),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, String name, String imageUrl, double price) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3.5,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height / 6.5,
            width: MediaQuery.of(context).size.width / 4,
            child: Image.network(imageUrl),
          ),
          Text(
            name,
            style: const TextStyle(fontSize: 15),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              '\$${price.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
class GridCategoryTile2 extends StatelessWidget {
  final List<DocumentSnapshot<Object?>> snapshotData;

  const GridCategoryTile2({Key? key, required this.snapshotData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.6  , 
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.7 ,
            color: const Color(0xffb6e4d2), 
          ),
          Container(
            height: MediaQuery.of(context).size.height / 7,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.topCenter,
            child: Image.network(
              'https://rukminim1.flixcart.com/flap/800/178/image/eeb594865936b505.jpg?q=90',
            
            ),
          ),
          Positioned( 
            top: MediaQuery.of(context).size.height / 65,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recently Viewed',     
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('View All'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
  height: MediaQuery.of(context).size.height / 2 ,
  padding: const EdgeInsets.only(left: 8, right: 8),
  width: MediaQuery.of(context).size.width,
  child: Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    color: Colors.white,
    child: SingleChildScrollView(
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: snapshotData.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          DocumentSnapshot productSnapshot = snapshotData[index];

          String name = productSnapshot['name'] as String? ?? '';
          double price = (productSnapshot['price'] as num?)?.toDouble() ?? 0.0;
          List<dynamic>? imageUrls = productSnapshot['images'] as List<dynamic>?;

          String imageUrl = imageUrls != null && imageUrls.isNotEmpty ? imageUrls[0] as String? ?? '' : '';

          return buildItem(context, name, imageUrl, price);
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
      ),
    ),
  ),
),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, String name, String imageUrl, double price) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3.5,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height / 6.5,
            width: MediaQuery.of(context).size.width / 4,
            child: Image.network(imageUrl),
          ),
          Text(
            name,
            style: const TextStyle(fontSize: 15),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              '\$${price.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}

