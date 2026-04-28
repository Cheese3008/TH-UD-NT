import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/weather_model.dart';
import '../providers/weather_provider.dart';
import '../utils/date_formatter.dart';
import '../utils/weather_icons.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const CurrentWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final WeatherProvider provider = context.watch<WeatherProvider>();

    final double temperature = provider.convertTemperature(weather.temperature);
    final double feelsLike = provider.convertTemperature(weather.feelsLike);
    final String temperatureSymbol = provider.getTemperatureSymbol();

    final List<Color> gradientColors = WeatherIcons.getGradientColors(
      weather.mainCondition,
      isNight: weather.isNight,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withAlpha(90),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '${weather.cityName}, ${weather.country}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            DateFormatter.formatFullDate(weather.dateTime),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withAlpha(220),
            ),
          ),
          const SizedBox(height: 18),
          CachedNetworkImage(
            imageUrl: weather.iconUrl,
            width: 120,
            height: 120,
            fit: BoxFit.contain,
            placeholder: (context, url) => const SizedBox(
              width: 80,
              height: 80,
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
            errorWidget: (context, url, error) => Icon(
              WeatherIcons.getIcon(weather.mainCondition),
              size: 90,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${temperature.round()}$temperatureSymbol',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 76,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            weather.description.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Cảm giác như ${feelsLike.round()}$temperatureSymbol',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white.withAlpha(230)),
          ),
        ],
      ),
    );
  }
}
