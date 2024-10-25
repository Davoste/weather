import 'package:flutter/material.dart';

import 'package:weather/services.dart'; // Assuming this file contains your API key and endpoint

class Search extends StatefulWidget {
  final String city;
  Search({super.key, required this.city});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late Future<dynamic> cityHewa;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() {
    cityHewa = ApiServices().cityWeather(widget.city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "WEATHER",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: FutureBuilder(
          future: cityHewa,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No weather data available'));
            } else {
              var weatherData = snapshot.data; // Cast it to your Weather type
              return Container(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Mmmmh the weather in " +
                                      widget
                                          .city, // Example: Displaying main weather info
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/earth.jpg', // Your image asset
                                  height: 50,
                                  width: 50,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "is mainly " + weatherData.main,
                                ),
                                Text(" ..that is " + weatherData.description),
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
                        )),
                  ),
                ),
              );
            }
          },
        ));
  }
}
