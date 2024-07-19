import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CardsToSlide extends StatelessWidget {
  const CardsToSlide({super.key, required this.events});
  final List events;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: CarouselSlider(
        items: events.map((event) {
          return InkWell(
            child: Stack(children: [
              Container(
                height: 300,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                  color: Colors.amber,
                  image: DecorationImage(
                    image: NetworkImage(event['imageUrl']),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Text(
                    event['title'],
                    style: const TextStyle(fontSize: 45),
                  ),
                ),
              ),
              // Positioned(
              //   left: 30,
              //   bottom: 10,
              //   child: Text(
              //     event['title'],
              //     style: const TextStyle(fontSize: 30),
              //   ),
              // )
            ]),
            onTap: () {},
          );
        }).toList(),
        options: CarouselOptions(
          height: 250,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlay: true,
          aspectRatio: 16 / 9,
          viewportFraction: 0.8,
        ),
      ),
    );
  }
}
