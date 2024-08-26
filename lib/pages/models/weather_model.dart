import 'dart:convert';

class WeatherModel {
  final String cityName;
  final double temperature;
  final String mainCondition;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
  });

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
      cityName: map['name'] as String,
      temperature: map['main']['temp'] as double,
      mainCondition: map['weather'][0]['main'],
    );
  }

  factory WeatherModel.fromJson(String source) =>
      WeatherModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
