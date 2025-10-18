class WeatherData {
  final String cityName;
  final String mainCondition;
  final String description;
  final String icon;
  final int temperatureCelsius;
  final int feelsLikeC;
  final int humidity;
  final double windSpeed;
  final List<WeatherHour> hourly;

  WeatherData({
    required this.cityName,
    required this.mainCondition,
    required this.description,
    required this.icon,
    required this.temperatureCelsius,
    required this.feelsLikeC,
    required this.humidity,
    required this.windSpeed,
    required this.hourly,
  });

  factory WeatherData.fromJson(
    Map<String, dynamic> currentJson,
    Map<String, dynamic> oneCallJson,
  ) {
    final weatherList = currentJson['weather'] as List<dynamic>?;
    final weather = weatherList != null && weatherList.isNotEmpty
        ? weatherList.first
        : {'main': 'N/A', 'description': 'N/A', 'icon': '01d'};

    final hourly = ((oneCallJson['hourly'] as List<dynamic>?) ?? [])
        .take(7)
        .map((e) => WeatherHour.fromJson(e as Map<String, dynamic>))
        .toList();

    return WeatherData(
      cityName:
          currentJson['name'] ?? (currentJson['sys']?['country'] ?? 'Unknown'),
      mainCondition: weather['main'] ?? 'N/A',
      description: weather['description'] ?? 'N/A',
      icon: weather['icon'] ?? '01d',
      temperatureCelsius: (currentJson['main']?['temp'] as num?)?.toInt() ?? 0,
      feelsLikeC: (currentJson['main']?['feels_like'] as num?)?.toInt() ?? 0,
      humidity: (currentJson['main']?['humidity'] as num?)?.toInt() ?? 0,
      windSpeed: (currentJson['wind']?['speed'] as num?)?.toDouble() ?? 0.0,
      hourly: hourly,
    );
  }
}

class WeatherHour {
  final int dt;
  final double temp;
  final String icon;

  WeatherHour({required this.dt, required this.temp, required this.icon});

  factory WeatherHour.fromJson(Map<String, dynamic> json) {
    final weatherList = json['weather'] as List<dynamic>?;
    final weather = weatherList != null && weatherList.isNotEmpty
        ? weatherList.first
        : {'icon': '01d'};

    return WeatherHour(
      dt: (json['dt'] as num?)?.toInt() ?? 0,
      temp: (json['temp'] as num?)?.toDouble() ?? 0.0,
      icon: weather['icon'] ?? '01d',
    );
  }
}

extension StringCasingExtension on String {
  String capitalize() =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
}
