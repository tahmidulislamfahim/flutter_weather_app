import 'package:flutter/material.dart';

class WeatherTheme {
  final List<Color> backgroundGradient;
  WeatherTheme(this.backgroundGradient);
}

WeatherTheme themeForWeather(String condition) {
  final cond = condition.toLowerCase();
  if (cond.contains('cloud')) {
    return WeatherTheme([const Color(0xFF4E6D9B), const Color(0xFFB0C3E6)]);
  } else if (cond.contains('rain') ||
      cond.contains('drizzle') ||
      cond.contains('thunder')) {
    return WeatherTheme([const Color(0xFF2B5876), const Color(0xFF4ECDC4)]);
  } else if (cond.contains('snow')) {
    return WeatherTheme([const Color(0xFF83A4D4), const Color(0xFFB6FBFF)]);
  } else if (cond.contains('clear')) {
    return WeatherTheme([const Color(0xFF56CCF2), const Color(0xFF2F80ED)]);
  } else {
    return WeatherTheme([const Color(0xFFFBD786), const Color(0xFFF7797D)]);
  }
}
