import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_weather_app/pages/models/weather_model.dart';

class WeatherService {
  static const baseUrl = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey = dotenv.env['API_KEY'] ?? '';

  WeatherService();

  Future<WeatherModel> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    // get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      timeLimit: Duration(seconds: 2),
    );

    // fetch the current location
    Position position =
        await Geolocator.getCurrentPosition(locationSettings: locationSettings);

    // convert the location into a list of placemark objects
    List<Placemark>? placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemarks[0].locality;
    if (city == null || city.isEmpty) {
      city = placemarks[0].subAdministrativeArea;
    }
    return city ?? "";
  }
}
