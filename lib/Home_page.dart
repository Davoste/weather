import 'package:flutter/material.dart';
import 'package:weather/search.dart';
import 'package:weather/services.dart'; // Ensure this contains naiWeather() definition
//import 'package:carousel_slider/carousel_slider.dart' as slider;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<dynamic> weather;
  late Future<dynamic> city;
  final myController = TextEditingController();

  final List<String> imgList = [
    'assets/images/rainy.png',
    'assets/images/sunny.jpeg',
    'assets/images/thinder.jpg',
    'assets/images/windy.png',
  ];

  var userSearch = "";
  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() {
    weather = ApiServices().naiWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Column(
        children: [
          whereYou(),
          const SizedBox(height: 15),
          naiWeather(),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 200,
          )
        ],
      ),
    );
  }

  Container naiWeather() {
    return Container(
        width: 300,
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    "The weather in Nairobi is",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            FutureBuilder(
              future: weather,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No weather data available'));
                } else {
                  var weatherData = snapshot.data!;
                  return Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Mainly ${weatherData.main}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                ' ..that is ${weatherData.description}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ), //des
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                'https://openweathermap.org/img/w/${weatherData.icon}.png',
                                width: 50,
                                height: 50,
                              ),
                            ],
                          )
                        ],
                      ));
                }
              },
            ),
          ],
        ));
  }

  Padding whereYou() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text(
                "Where you at?",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset(
                'assets/images/earth.jpg',
                height: 50,
                width: 50,
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 145, 204, 221),
                ),
                onPressed: () {
                  openDialog();
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            contentPadding: EdgeInsets.only(top: 10.0),
            backgroundColor: Colors.white,
            content: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                autofocus: true,
                controller: myController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  hintText: 'London',
                  suffixIcon: IconButton(
                    onPressed: () {
                      //clear users iniput
                      myController.clear();
                    },
                    icon: const Icon(
                      Icons.clear,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                  ),
                  color: Colors.black,
                  onPressed: () {
                    setState(() {
                      userSearch = myController.text;
                    });

                    // Navigate to the next screen first
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Search(city: userSearch),
                      ),
                    ).then((_) {
                      // After navigation is complete, close the dialog
                      Navigator.of(context).pop();
                    });

                    myController.clear();
                  },
                  child: const Text(
                    "Find",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ))
            ],
          ));

  AppBar myAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "WEATHER",
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0, // Remove shadow
      leading: const Icon(
        Icons.menu,
        color: Colors.black,
      ),
    );
  }
}

Widget buildImage(String urlImage, int index) => Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Image.asset(
        urlImage,
        fit: BoxFit.cover,
      ),
    );
