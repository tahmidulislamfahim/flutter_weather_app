import 'package:flutter/material.dart';
import '../models/weather_data.dart';

class WeatherCard extends StatelessWidget {
  final WeatherData weather;
  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    // Get gradient based on weather type
    final gradientColors = _getGradient(weather.mainCondition);

    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weather.cityName,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            weather.mainCondition.capitalize(),
            style: const TextStyle(fontSize: 20, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Image.network(
            'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 8),
          Text(
            '${weather.temperatureCelsius}°C',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Feels like ${weather.feelsLikeC}°C',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _infoTile(Icons.water_drop, '${weather.humidity}%', Colors.white),
              const SizedBox(width: 16),
              _infoTile(Icons.air, '${weather.windSpeed} m/s', Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 4),
        Text(value, style: TextStyle(color: color)),
      ],
    );
  }

  List<Color> _getGradient(String condition) {
    condition = condition.toLowerCase();
    if (condition.contains('cloud')) {
      return [Colors.blueGrey.shade700, Colors.blueGrey.shade400];
    } else if (condition.contains('rain') || condition.contains('drizzle')) {
      return [Colors.indigo.shade700, Colors.indigo.shade400];
    } else if (condition.contains('thunderstorm')) {
      return [Colors.deepPurple.shade700, Colors.deepPurple.shade400];
    } else if (condition.contains('snow')) {
      return [Colors.blue.shade200, Colors.white];
    } else if (condition.contains('clear')) {
      return [Colors.orange.shade400, Colors.yellow.shade300];
    } else if (condition.contains('mist') ||
        condition.contains('fog') ||
        condition.contains('haze')) {
      return [Colors.grey.shade500, Colors.grey.shade300];
    } else {
      return [Colors.blue.shade400, Colors.lightBlueAccent.shade200];
    }
  }
}
