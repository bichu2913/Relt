  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relt/view/home_page/widgets/all_tile.dart';
import 'package:relt/view/home_page/widgets/product_grid.dart';
import 'package:relt/view/home_page/widgets/slider.dart';

SizedBox allproduct(double screenHeight, double screenWidth, void Function(DocumentSnapshot<Object?> productSnapshot) navigateToProductDetails, Future<List<DocumentSnapshot<Object?>>> allProductsData) {
    return SizedBox(
                  height: screenHeight * 0.7,
                  width: screenWidth,
                  child: FutureBuilder<List<DocumentSnapshot>>(
                    future: allProductsData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No data available');
                      } else {
                        return GridCategoryTile(
                          snapshotData: snapshot.data!,
                          onTap: navigateToProductDetails,
                        );
                      }
                    },
                  ),
                );
  }
  SizedBox recentproduct(double screenHeight, double screenWidth, void Function(DocumentSnapshot<Object?> productSnapshot) navigateToProductDetails, Future<List<DocumentSnapshot<Object?>>> allProductsData) {
    return SizedBox(
                  height: screenHeight * 0.4,
                  width: screenWidth,
                  child: FutureBuilder<List<DocumentSnapshot>>(
                    future: allProductsData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No data available');
                      } else {
                        return GridCategoryTile2( 
                          snapshotData: snapshot.data!,
                          onTap: navigateToProductDetails, 
                        );
                      }
                    }, 
                  ), 
                ); 
  }
   Padding slider(double screenHeight, double screenWidth, void Function(DocumentSnapshot<Object?> productSnapshot) navigateToProductDetails, Future<List<DocumentSnapshot<Object?>>> featuredData) {
    return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: screenHeight * 0.3,
                    width: screenWidth,
                    child: FutureBuilder<List<DocumentSnapshot>>(
                      future: featuredData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child:  CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text('No data available');
                        } else {
                          return NewCategoryTile(
                            snapshotData: snapshot.data!,
                            height: screenHeight / 4,
                            onTap: navigateToProductDetails,
                          );
                        }
                      },
                    ),
                  ),
                );
  } 