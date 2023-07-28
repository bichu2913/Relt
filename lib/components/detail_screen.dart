
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Reuse extends StatefulWidget {
  final List<DocumentSnapshot<Object?>> snapshotData;
  final double height;

  const Reuse({Key? key, required this.snapshotData, required this.height})
      : super(key: key);

  @override
  ReuseState createState() => ReuseState();
}

class ReuseState extends State<Reuse> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemBuilder: (context, index, realIndex) {
            DocumentSnapshot productSnapshot = widget.snapshotData[index];
            List<dynamic>? imageUrls = productSnapshot['images'] as List<dynamic>?;

            String imageUrl = imageUrls != null && imageUrls.isNotEmpty ? imageUrls[index] as String? ?? '' : '';

            return buildImage(imageUrl);
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
        placeholder: (context, url) => Image.asset("assets/placeholder.png"), // Replace with your placeholder image
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
          dotColor: Color.fromRGBO(217, 217, 217, 1),
          activeDotColor: Color.fromARGB(255, 59, 59, 59),
          dotWidth: 10,
          dotHeight: 7,
        ),
      ),
    );
  }     
}
