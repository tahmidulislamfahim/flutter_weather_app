import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_weather_app/models/weather_data.dart';

class HourTile extends StatelessWidget {
  final WeatherHour hour;
  const HourTile({super.key, required this.hour});

  @override
  Widget build(BuildContext context) {
    final time = DateFormat(
      'ha',
    ).format(DateTime.fromMillisecondsSinceEpoch(hour.dt * 1000));
    final iconUrl = 'https://openweathermap.org/img/wn/${hour.icon}@2x.png';
    return Container(
      width: 90,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 6),
          Image.network(iconUrl, width: 44, height: 44),
          const SizedBox(height: 6),
          Text(
            '${hour.temp.toStringAsFixed(0)}°',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
