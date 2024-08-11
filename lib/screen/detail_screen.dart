import 'package:flutter/material.dart';
import 'package:movie_shop/model/movie_model.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.movieModel});

  final MovieModel movieModel;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            widget.movieModel.imageUrl,
            width: MediaQuery.of(context).size.width,
            height: 400,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.movieModel.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(widget.movieModel.desc),
                Wrap(
                  spacing: 25,
                  children: [
                    cardWidget(widget.movieModel.keshvar, 'کشور'),
                    cardWidget(widget.movieModel.price, 'هزینه'),
                    cardWidget(widget.movieModel.zaman, 'زمان'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox cardWidget(String content, String title) {
    return SizedBox(
      height: 120,
      width: 100,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              content,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
