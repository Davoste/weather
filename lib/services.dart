import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/model.dart';

const Api_Key = "51d08ed5bd0aa26f024ec8c75acf5ff2";

class ApiServices {
  final getWeather =
      "https://api.openweathermap.org/data/2.5/weather?lat=-1.30326415&lon=36.826384099341595&appid=51d08ed5bd0aa26f024ec8c75acf5ff2";
  final getCityWeather = "https://api.openweathermap.org/data/2.5/weather?q=";

  //GET WEATHER FOR Nairobi
  Future<Weather> naiWeather() async {
    Uri url = Uri.parse(getWeather);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final weather = Weather.fromJson(
          jsonResponse['weather'][0]); // Fetches the first weather object
      return weather; // Return a Weather object
    } else {
      throw Exception("Failed to load weather details");
    }
  }

  Future<Weather> cityWeather(String city) async {
    Uri url = Uri.parse("$getCityWeather" + "$city" + "&appid=$Api_Key");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final weather = Weather.fromJson(
          jsonResponse['weather'][0]); // Fetches the first weather object
      return weather; // Return a Weather object
    } else {
      throw Exception("Failed to load weather details");
    }
  }
}
