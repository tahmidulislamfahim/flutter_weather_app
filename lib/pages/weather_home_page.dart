import 'package:flutter/material.dart';
import 'package:flutter_weather_app/services/weather_service.dart';
import 'package:flutter_weather_app/widgets/build_error.dart';
import 'package:flutter_weather_app/widgets/build_info_bar.dart';
import 'package:flutter_weather_app/widgets/weather_card.dart';
import 'package:flutter_weather_app/models/weather_data.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final TextEditingController _cityController = TextEditingController(
    text: 'Dhaka',
  );
  WeatherData? _weather;
  bool _loading = false;
  String? _error;
  final WeatherService _service = WeatherService();

  @override
  void initState() {
    super.initState();
    _searchCity(_cityController.text);
  }

  Future<void> _searchCity(String city) async {
    if (city.trim().isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _service.fetchWeatherByCity(city.trim());
      setState(() {
        _weather = data;
        _cityController.text = data.cityName;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _fetchByLocation() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _service.fetchWeatherByLocation();
      setState(() {
        _weather = data;
        _cityController.text = data.cityName;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      floatingActionButton: buildFloatingButton(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.black, Colors.grey.shade900]
                : [Colors.blue.shade100, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                buildSearchRow(),
                const SizedBox(height: 25),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: _loading
                        ? const Center(child: CircularProgressIndicator())
                        : _error != null
                        ? BuildError(error: _error, isDark: isDark)
                        : _weather != null
                        ? Column(
                            children: [
                              Expanded(child: WeatherCard(weather: _weather!)),
                              const SizedBox(height: 20),
                              BuildInfoBar(weather: _weather),
                            ],
                          )
                        : emptyState(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🌍 Search bar with rounded design
  Widget buildSearchRow() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _cityController,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => _searchCity(_cityController.text),
        decoration: InputDecoration(
          hintText: 'Search city...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.location_city_rounded),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => _searchCity(_cityController.text),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  /// ☁️ Empty state
  Widget emptyState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      key: const ValueKey('empty'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_outlined,
            size: 90,
            color: isDark ? Colors.white30 : Colors.grey[400],
          ),
          const SizedBox(height: 14),
          Text(
            'Search for a city to see the weather',
            style: TextStyle(
              fontSize: 18,
              color: isDark ? Colors.white70 : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _searchCity('Dhaka'),
            icon: const Icon(Icons.location_city_rounded),
            label: const Text('Try Dhaka'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 📍 Floating Location Button with glow
  Widget buildFloatingButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.6),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _fetchByLocation,
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: const Icon(Icons.my_location, size: 28, color: Colors.white),
      ),
    );
  }
}
