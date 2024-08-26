import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_weather_app/pages/models/weather_model.dart';
import 'package:flutter_weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService();
  WeatherModel? _weather;

  // fetch weather
  _fetchWeather() async {
    // get the current ciy
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    // any erros
    catch (e) {
      log(e.toString());
    }
  }

  // weather animations

  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName ?? "loading city..."),
            Text('${_weather?.temperature.round() ?? ''}°C'),
          ],
        ),
      ),
    );
  }
}
