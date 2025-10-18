import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';

class WeatherService {
  final String _apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  Future<WeatherData> fetchWeatherByCity(String city) async {
    if (_apiKey.isEmpty) throw Exception('API key not set in .env');

    // 1️⃣ Get current weather to find lat/lon
    final currentUri = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=${Uri.encodeComponent(city)}&appid=$_apiKey&units=metric',
    );
    final currentRes = await http.get(currentUri);
    if (currentRes.statusCode != 200) {
      final body = jsonDecode(currentRes.body);
      throw Exception(body['message'] ?? 'Failed to fetch weather');
    }
    final currentJson = Map<String, dynamic>.from(
      jsonDecode(currentRes.body) as Map,
    );

    final lat = currentJson['coord']?['lat'];
    final lon = currentJson['coord']?['lon'];

    if (lat == null || lon == null) {
      throw Exception('Coordinates not found');
    }

    // 2️⃣ Get hourly forecast
    final oneCallUri = Uri.parse(
      'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely,daily,alerts&appid=$_apiKey&units=metric',
    );
    final oneCallRes = await http.get(oneCallUri);

    Map<String, dynamic> oneCallJson = {};
    if (oneCallRes.statusCode == 200) {
      final jsonBody = jsonDecode(oneCallRes.body);
      if (jsonBody is Map<String, dynamic>) {
        oneCallJson = jsonBody;
      }
    }

    // Ensure hourly is always a List
    oneCallJson['hourly'] =
        (oneCallJson['hourly'] as List<dynamic>?)?.take(7).toList() ?? [];

    return WeatherData.fromJson(currentJson, oneCallJson);
  }

  Future<WeatherData> fetchWeatherByLocation() async {
    if (_apiKey.isEmpty) throw Exception('API key not set in .env');

    // Check location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied');
    }

    // Get device location
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      ),
    );
    final lat = pos.latitude;
    final lon = pos.longitude;

    // Current weather
    final currentUri = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric',
    );
    final currentRes = await http.get(currentUri);
    if (currentRes.statusCode != 200) {
      throw Exception('Failed to get location name');
    }
    final currentJson = Map<String, dynamic>.from(
      jsonDecode(currentRes.body) as Map,
    );

    // Hourly forecast
    final oneCallUri = Uri.parse(
      'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely,daily,alerts&appid=$_apiKey&units=metric',
    );
    final oneCallRes = await http.get(oneCallUri);

    Map<String, dynamic> oneCallJson = {};
    if (oneCallRes.statusCode == 200) {
      final jsonBody = jsonDecode(oneCallRes.body);
      if (jsonBody is Map<String, dynamic>) {
        oneCallJson = jsonBody;
      }
    }

    // Ensure hourly is always a List
    oneCallJson['hourly'] =
        (oneCallJson['hourly'] as List<dynamic>?)?.take(7).toList() ?? [];

    return WeatherData.fromJson(currentJson, oneCallJson);
  }
}
