import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_weather_app/models/weather_data.dart';
import 'package:flutter_weather_app/widgets/info_tile.dart';

class BuildInfoBar extends StatelessWidget {
  const BuildInfoBar({super.key, required WeatherData? weather})
    : _weather = weather;

  final WeatherData? _weather;

  @override
  Widget build(BuildContext context) {
    if (_weather == null) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InfoTile(
                icon: Icons.thermostat,
                value: '${_weather.temperatureCelsius}°C',
                label: 'Temp',
              ),
              InfoTile(
                icon: Icons.water_drop,
                value: '${_weather.humidity}%',
                label: 'Humidity',
              ),
              InfoTile(
                icon: Icons.air,
                value: '${_weather.windSpeed} m/s',
                label: 'Wind',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
