import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:slash_task/Bloc/ProductsBloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageSlider extends StatefulWidget {
  final List<String> images;

  ImageSlider({required this.images});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.images.length,
          itemBuilder: (context, index, realIndex) {
            final imageUrl = widget.images[index];
            return buildImage(imageUrl, index);
          },
          options: CarouselOptions(
            height: 400,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              // Handle page change if needed
              setState(() {
                activeIndex = index;
              });
            },
          ),
        ),
        SizedBox(height: 5),
        buildIndicator(activeIndex, widget.images.length),
      ],
    );
  }
}

Widget buildImage(imageUrl, index) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 12),
    color: Colors.green,
    child: Image.network(
      imageUrl,
      fit: BoxFit.cover,
    ),
  );
}

Widget buildIndicator(activeIndex, itemCount) {
  return AnimatedSmoothIndicator(
    activeIndex: (activeIndex),
    count: (itemCount),
  );
}
