import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:movie_shop/model/movie_model.dart';
import 'package:movie_shop/model/stars_model.dart';
import 'package:movie_shop/screen/detail_screen.dart';
import '../const/url.dart';
import '../model/carousel_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CarouselModel> carouselList = [];
  List<MovieModel> movieList1 = [];
  List<MovieModel> movieList2 = [];
  List<StarsModel> starsList = [];
  bool carouseLoading = false;
  bool movieLoading = false;
  bool starsLoading = false;

  callCarouselApi() async {
    final url = Uri.parse("$ip=pageviewmovie");
    carouseLoading = true;
    Response response = await get(url);
    carouseLoading = false;
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (int i = 0; i < data.length; i++) {
        setState(() {
          carouselList.add(
            CarouselModel(
              id: data[i]['id'],
              imgSlide: data[i]['img_slide'],
              name: data[i]['name'],
            ),
          );
        });
      }
    }
  }

  callMovieApi(String action, List<MovieModel> movieList) async {
    final url = Uri.parse("$ip=$action");
    movieLoading = true;
    Response response = await get(url);
    movieLoading = false;
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (int i = 0; i < data.length; i++) {
        setState(() {
          movieList.add(
            MovieModel(
              id: data[i]['id'],
              name: data[i]['name'],
              desc: data[i]['description'],
              saleSakht: data[i]['saleSakht'],
              price: data[i]['price'],
              imageUrl: data[i]['image_url'],
              keshvar: data[i]['keshvar'],
              zaman: data[i]['zaman'],
            ),
          );
        });
      }
    }
  }

  callStarsApi() async {
    final url = Uri.parse("$ip=stars");
    starsLoading = true;
    Response response = await get(url);
    starsLoading = false;
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (int i = 0; i < data.length; i++) {
        setState(() {
          starsList.add(
            StarsModel(
              id: data[i]['id'],
              name: data[i]['name'],
              pic: data[i]['pic'],
            ),
          );
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callCarouselApi();
    callMovieApi("movie1", movieList1);
    callMovieApi("movie2", movieList2);
    callStarsApi();
  }

  SizedBox loadingWidget() {
    return SizedBox(
      height: 200,
      child: SpinKitFadingFour(
        color: Colors.purpleAccent,
        size: MediaQuery.of(context).size.width * 0.15,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                carouseLoading
                    ? loadingWidget()
                    : CarouselWidget(carouselList: carouselList),
                movieLoading
                    ? loadingWidget()
                    : MovieSection(movieList: movieList1, title: 'پرفروش ترین'),
                starsLoading
                    ? loadingWidget()
                    : StarsListWidget(starsList: starsList),
                carouseLoading
                    ? loadingWidget()
                    : MovieSection(
                        movieList: movieList2,
                        title: 'تازه ترین',
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StarsListWidget extends StatelessWidget {
  const StarsListWidget({
    super.key,
    required this.starsList,
  });

  final List<StarsModel> starsList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: starsList.length,
        itemBuilder: (context, index) => Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: FadeInImage(
                placeholder: const AssetImage('assets/images/logo.png'),
                image: NetworkImage(starsList[index].pic),
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(starsList[index].name),
          ],
        ),
      ),
    );
  }
}

class MovieSection extends StatelessWidget {
  const MovieSection({
    super.key,
    required this.movieList,
    required this.title,
  });

  final List<MovieModel> movieList;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                'بیشتر >',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 260,
          child: ListView.builder(
            itemCount: movieList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => SizedBox(
              width: 175,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        DetailScreen(movieModel: movieList[index]),
                  ));
                },
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage(
                          placeholder:
                              const AssetImage('assets/images/logo.png'),
                          image: NetworkImage(movieList[index].imageUrl),
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        movieList[index].name,
                        maxLines: 1,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${movieList[index].price},000 تومان',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({
    super.key,
    required this.carouselList,
  });

  final List<CarouselModel> carouselList;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: carouselList.length,
      itemBuilder: (context, index, realIndex) => Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Card(
              elevation: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/images/logo.png'),
                  image: NetworkImage(carouselList[index].imgSlide),
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Positioned(
            top: 165,
            left: 10,
            child: Container(
              height: 25,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  carouselList[index].name,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      options: CarouselOptions(
          autoPlay: true, enlargeCenterPage: true, viewportFraction: 0.95),
    );
  }
}
