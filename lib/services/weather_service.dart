import 'package:dio/dio.dart';

/// Weather data model
class WeatherData {
  final double temperature;
  final double humidity;
  final String description;
  final String icon;
  final double windSpeed;
  final int cloudiness;
  final DateTime timestamp;

  WeatherData({
    required this.temperature,
    required this.humidity,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.cloudiness,
    required this.timestamp,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final weather = (json['weather'] as List).first as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>;
    final clouds = json['clouds'] as Map<String, dynamic>;

    return WeatherData(
      temperature: (main['temp'] as num).toDouble(),
      humidity: (main['humidity'] as num).toDouble(),
      description: weather['description'] as String,
      icon: weather['icon'] as String,
      windSpeed: (wind['speed'] as num).toDouble(),
      cloudiness: clouds['all'] as int,
      timestamp: DateTime.now(),
    );
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';
}

/// Weather forecast model
class WeatherForecast {
  final List<WeatherData> daily;
  final String cityName;

  WeatherForecast({
    required this.daily,
    required this.cityName,
  });
}

/// Service for OpenWeatherMap API integration
class WeatherService {
  // OpenWeatherMap API key (free tier)
  static const String _apiKey = 'a985e08c78055d53b26a4cab71500a5e';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  final Dio _dio;

  WeatherService({Dio? dio}) : _dio = dio ?? Dio();

  /// Get current weather by coordinates
  Future<WeatherData> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _dio.get(
      '$_baseUrl/weather',
      queryParameters: {
        'lat': latitude,
        'lon': longitude,
        'appid': _apiKey,
        'units': 'metric',
        'lang': 'ms', // Malay language
      },
    );

    return WeatherData.fromJson(response.data);
  }

  /// Get 5-day forecast by coordinates
  Future<WeatherForecast> getForecast({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _dio.get(
      '$_baseUrl/forecast',
      queryParameters: {
        'lat': latitude,
        'lon': longitude,
        'appid': _apiKey,
        'units': 'metric',
        'lang': 'ms',
      },
    );

    final list = response.data['list'] as List;
    final city = response.data['city'] as Map<String, dynamic>;

    // Get one forecast per day (every 8th item = 24 hours)
    final dailyForecasts = <WeatherData>[];
    for (int i = 0; i < list.length && dailyForecasts.length < 7; i += 8) {
      dailyForecasts.add(WeatherData.fromJson(list[i]));
    }

    return WeatherForecast(
      daily: dailyForecasts,
      cityName: city['name'] as String,
    );
  }

  /// Get weather by district name (Melaka)
  Future<WeatherData> getWeatherByDistrict(String district) async {
    // Melaka district coordinates
    final coordinates = _getDistrictCoordinates(district);
    return getCurrentWeather(
      latitude: coordinates['lat']!,
      longitude: coordinates['lon']!,
    );
  }

  /// Get forecast by district name
  Future<WeatherForecast> getForecastByDistrict(String district) async {
    final coordinates = _getDistrictCoordinates(district);
    return getForecast(
      latitude: coordinates['lat']!,
      longitude: coordinates['lon']!,
    );
  }

  /// Get coordinates for Melaka districts
  Map<String, double> _getDistrictCoordinates(String district) {
    switch (district.toLowerCase().replaceAll(' ', '')) {
      case 'melakatengah':
        return {'lat': 2.1896, 'lon': 102.2501}; // Melaka City
      case 'alorgajah':
        return {'lat': 2.3811, 'lon': 102.1498}; // Alor Gajah
      case 'jasin':
        return {'lat': 2.3125, 'lon': 102.4306}; // Jasin
      default:
        return {'lat': 2.1896, 'lon': 102.2501}; // Default to Melaka Tengah
    }
  }
}
