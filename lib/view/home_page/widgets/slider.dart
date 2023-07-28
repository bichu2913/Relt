// new_category_tile.dart
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class NewCategoryTile extends StatefulWidget {
  final List<DocumentSnapshot<Object?>> snapshotData;
  final double height;
  final Function(DocumentSnapshot) onTap;

  const NewCategoryTile({Key? key, required this.snapshotData, required this.height,  required this.onTap})
      : super(key: key);

  @override
  NewCategoryTileState createState() => NewCategoryTileState();
}

class NewCategoryTileState extends State<NewCategoryTile> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) { 
    return Column(
      children: [
        CarouselSlider.builder(
          itemBuilder: (context, index, realIndex) {
            DocumentSnapshot productSnapshot = widget.snapshotData[index];
            List<dynamic>? imageUrls = productSnapshot['images'] as List<dynamic>?;

            String imageUrl = imageUrls != null && imageUrls.isNotEmpty ? imageUrls[0] as String? ?? '' : '';

            return GestureDetector(
              onTap: () => widget.onTap(productSnapshot),
              child: buildImage(imageUrl),
            );
          },
          itemCount: widget.snapshotData.length,
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            
            enlargeCenterPage: true,
            padEnds: true,
            viewportFraction: 0.98,
            autoPlay: true,
            height: widget.height,
          ),
        ),
        const SizedBox(height: 10),
        buildIndicator(),
      ],
    );
  }

  Widget buildImage(String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: CachedNetworkImage(
        placeholder: (context, url) => Image.asset("C:/canva/relt/assests/Metaversefundingvoguebusphotographermonth22story1.png"), // Replace with your placeholder image
        imageUrl: imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildIndicator() {
    return Center(
      child: AnimatedSmoothIndicator(
        activeIndex: _currentPageIndex,
        count: widget.snapshotData.length,
        effect: const ExpandingDotsEffect(
          dotColor: Colors.white, 
          activeDotColor: Color.fromARGB(255, 59, 59, 59),
          dotWidth: 10,
          dotHeight: 7,
        ),
      ),
    );
  }
}



