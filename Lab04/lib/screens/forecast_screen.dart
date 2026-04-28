import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/forecast_model.dart';
import '../providers/weather_provider.dart';
import '../utils/date_formatter.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WeatherProvider provider = context.watch<WeatherProvider>();
    final List<ForecastModel> forecasts = provider.forecast;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dự báo thời tiết',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Làm mới',
            onPressed: provider.isLoading
                ? null
                : () {
                    context.read<WeatherProvider>().refreshWeather();
                  },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<WeatherProvider>().refreshWeather(),
        child: forecasts.isEmpty
            ? const _EmptyForecastState()
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ForecastHeader(provider: provider),
                    const SizedBox(height: 24),
                    const _SectionTitle(
                      title: 'Dự báo theo giờ',
                      icon: Icons.schedule_rounded,
                    ),
                    const SizedBox(height: 12),
                    _HourlyForecastSection(
                      forecasts: forecasts.take(12).toList(),
                      provider: provider,
                    ),
                    const SizedBox(height: 28),
                    const _SectionTitle(
                      title: 'Dự báo 5 ngày',
                      icon: Icons.calendar_month_rounded,
                    ),
                    const SizedBox(height: 12),
                    _DailyForecastSection(
                      summaries: _buildDailySummaries(forecasts),
                      provider: provider,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  List<_DailyForecastSummary> _buildDailySummaries(
    List<ForecastModel> forecasts,
  ) {
    final Map<DateTime, List<ForecastModel>> grouped = {};

    for (final ForecastModel forecast in forecasts) {
      final DateTime key = DateTime(
        forecast.dateTime.year,
        forecast.dateTime.month,
        forecast.dateTime.day,
      );

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(forecast);
    }

    final List<_DailyForecastSummary> summaries = [];

    for (final MapEntry<DateTime, List<ForecastModel>> entry
        in grouped.entries) {
      final List<ForecastModel> items = entry.value;

      double minTemp = items.first.tempMin;
      double maxTemp = items.first.tempMax;
      int totalHumidity = 0;
      double totalWind = 0;
      double maxPop = 0;

      for (final ForecastModel item in items) {
        if (item.tempMin < minTemp) {
          minTemp = item.tempMin;
        }

        if (item.tempMax > maxTemp) {
          maxTemp = item.tempMax;
        }

        totalHumidity += item.humidity;
        totalWind += item.windSpeed;

        if (item.precipitationProbability > maxPop) {
          maxPop = item.precipitationProbability;
        }
      }

      final ForecastModel representative = items.length > 3
          ? items[items.length ~/ 2]
          : items.first;

      summaries.add(
        _DailyForecastSummary(
          dateTime: entry.key,
          minTemp: minTemp,
          maxTemp: maxTemp,
          averageHumidity: totalHumidity / items.length,
          averageWindSpeed: totalWind / items.length,
          precipitationProbability: maxPop,
          description: representative.description,
          iconUrl: representative.iconUrl,
        ),
      );
    }

    summaries.sort((_DailyForecastSummary a, _DailyForecastSummary b) {
      return a.dateTime.compareTo(b.dateTime);
    });

    return summaries.take(5).toList();
  }
}

class _ForecastHeader extends StatelessWidget {
  final WeatherProvider provider;

  const _ForecastHeader({required this.provider});

  @override
  Widget build(BuildContext context) {
    final currentWeather = provider.currentWeather;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(25),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.location_on_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentWeather == null
                      ? 'Chưa có vị trí'
                      : '${currentWeather.cityName}, ${currentWeather.country}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormatter.formatLastUpdate(provider.lastUpdateTime),
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HourlyForecastSection extends StatelessWidget {
  final List<ForecastModel> forecasts;
  final WeatherProvider provider;

  const _HourlyForecastSection({
    required this.forecasts,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 185,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: forecasts.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final ForecastModel forecast = forecasts[index];

          final double temperature = provider.convertTemperature(
            forecast.temperature,
          );

          return Container(
            width: 125,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormatter.formatHour(
                    forecast.dateTime,
                    use12Hour: provider.timeFormat == '12h',
                  ),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Image.network(
                  forecast.iconUrl,
                  width: 54,
                  height: 54,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.cloud_rounded, size: 44);
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  '${temperature.round()}${provider.getTemperatureSymbol()}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(forecast.precipitationProbability * 100).round()}% mưa',
                  style: TextStyle(color: Colors.blue.shade700, fontSize: 13),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DailyForecastSection extends StatelessWidget {
  final List<_DailyForecastSummary> summaries;
  final WeatherProvider provider;

  const _DailyForecastSection({
    required this.summaries,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: summaries.map((_DailyForecastSummary summary) {
        final double minTemp = provider.convertTemperature(summary.minTemp);
        final double maxTemp = provider.convertTemperature(summary.maxTemp);
        final double windSpeed = provider.convertWindSpeed(
          summary.averageWindSpeed,
        );

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(14),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Image.network(
                summary.iconUrl,
                width: 56,
                height: 56,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.cloud_rounded, size: 46);
                },
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormatter.formatDay(summary.dateTime),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      summary.description,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        _MiniInfo(
                          icon: Icons.water_drop_rounded,
                          text: '${summary.averageHumidity.round()}%',
                        ),
                        _MiniInfo(
                          icon: Icons.air_rounded,
                          text:
                              '${windSpeed.toStringAsFixed(1)} ${provider.getWindSpeedSymbol()}',
                        ),
                        _MiniInfo(
                          icon: Icons.umbrella_rounded,
                          text:
                              '${(summary.precipitationProbability * 100).round()}%',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${minTemp.round()} / ${maxTemp.round()}${provider.getTemperatureSymbol()}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MiniInfo({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _EmptyForecastState extends StatelessWidget {
  const _EmptyForecastState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 120),
        Icon(Icons.cloud_off_rounded, size: 76, color: Colors.grey.shade500),
        const SizedBox(height: 18),
        Text(
          'Chưa có dữ liệu dự báo',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Hãy quay lại trang chính và tải dữ liệu thời tiết trước.',
          style: TextStyle(color: Colors.grey.shade700),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _DailyForecastSummary {
  final DateTime dateTime;
  final double minTemp;
  final double maxTemp;
  final double averageHumidity;
  final double averageWindSpeed;
  final double precipitationProbability;
  final String description;
  final String iconUrl;

  const _DailyForecastSummary({
    required this.dateTime,
    required this.minTemp,
    required this.maxTemp,
    required this.averageHumidity,
    required this.averageWindSpeed,
    required this.precipitationProbability,
    required this.description,
    required this.iconUrl,
  });
}
