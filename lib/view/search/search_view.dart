// search.dart


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relt/model/search.dart';
import 'package:relt/view/home_page/widgets/all_tile.dart';
import 'package:relt/view/productdetail.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);
 
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  late SearchController controller;
  late SearchModel model;

  @override
  void initState() {
    super.initState();
    model = SearchModel();
    controller = SearchController();
    model.fetchProducts();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SEARCH ",textAlign: TextAlign.center ,),backgroundColor: Colors.black,
    
      ),
      body: StreamBuilder<List<DocumentSnapshot<Object?>>>(
        stream: model.productsStream, 
        builder: (context, snapshot) { 
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<DocumentSnapshot<Object?>> filteredProducts = snapshot.data ?? [];

            return Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        onChanged: model.filterProducts,
                        decoration: const InputDecoration(
                          labelText: 'Search',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: filteredProducts.isNotEmpty
                          ? GridCategoryTile(
                              snapshotData: filteredProducts,
                              onTap: (productSnapshot) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(productSnapshot),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text('No products found.'),
                            ),
                    ),
                  ],
                ),
                
                 
              ],
            );
          }
        },
      ),
    );
  }
}
