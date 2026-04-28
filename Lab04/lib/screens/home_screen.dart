import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/forecast_model.dart';
import '../providers/weather_provider.dart';
import '../utils/date_formatter.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/weather_detail_item.dart';
import 'forecast_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchCity() async {
    final String cityName = _searchController.text.trim();

    if (cityName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên thành phố.')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    await context.read<WeatherProvider>().fetchWeatherByCity(cityName);
  }

  @override
  Widget build(BuildContext context) {
    final WeatherProvider provider = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Mở màn hình tìm kiếm',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            tooltip: 'Xem dự báo',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForecastScreen()),
              );
            },
            icon: const Icon(Icons.calendar_month_rounded),
          ),
          IconButton(
            tooltip: 'Cài đặt',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings_rounded),
          ),
          IconButton(
            tooltip: 'Lấy vị trí hiện tại',
            onPressed: provider.isLoading
                ? null
                : () {
                    context.read<WeatherProvider>().fetchWeatherByLocation();
                  },
            icon: const Icon(Icons.my_location_rounded),
          ),
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
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, WeatherProvider provider) {
    if (provider.isLoading && provider.currentWeather == null) {
      return const LoadingShimmer();
    }

    if (provider.hasError && provider.currentWeather == null) {
      return WeatherErrorWidget(
        message: provider.errorMessage,
        onRetry: () {
          context.read<WeatherProvider>().fetchWeatherByCity(
            'Ho Chi Minh City',
          );
        },
      );
    }

    final weather = provider.currentWeather;

    if (weather == null) {
      return WeatherErrorWidget(
        message: 'Chưa có dữ liệu thời tiết.',
        onRetry: () {
          context.read<WeatherProvider>().fetchWeatherByCity(
            'Ho Chi Minh City',
          );
        },
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<WeatherProvider>().refreshWeather(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SearchCityBox(
              controller: _searchController,
              onSearch: _searchCity,
              isLoading: provider.isLoading,
            ),

            const SizedBox(height: 20),

            if (provider.errorMessage.isNotEmpty)
              _StatusBanner(
                message: provider.errorMessage,
                isError: provider.hasError,
              ),

            if (provider.isUsingCachedData)
              _StatusBanner(
                message:
                    'Đang hiển thị dữ liệu cache. ${DateFormatter.formatLastUpdate(provider.lastUpdateTime)}',
                isError: false,
              ),

            CurrentWeatherCard(weather: weather),

            const SizedBox(height: 24),

            _SectionTitle(
              title: 'Chi tiết thời tiết',
              icon: Icons.info_outline_rounded,
            ),

            const SizedBox(height: 12),

            _WeatherDetailsGrid(provider: provider),

            const SizedBox(height: 24),

            _SectionTitle(
              title: 'Dự báo gần nhất',
              icon: Icons.calendar_month_rounded,
            ),

            const SizedBox(height: 12),

            _ForecastPreviewList(
              forecasts: provider.forecast,
              provider: provider,
            ),

            const SizedBox(height: 24),

            if (provider.recentSearches.isNotEmpty) ...[
              _SectionTitle(
                title: 'Tìm kiếm gần đây',
                icon: Icons.history_rounded,
              ),
              const SizedBox(height: 12),
              _RecentSearchChips(
                cities: provider.recentSearches,
                onTapCity: (String city) {
                  _searchController.text = city;
                  context.read<WeatherProvider>().fetchWeatherByCity(city);
                },
              ),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SearchCityBox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final bool isLoading;

  const _SearchCityBox({
    required this.controller,
    required this.onSearch,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 6, 8, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
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
          Icon(Icons.search_rounded, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSearch(),
              decoration: const InputDecoration(
                hintText: 'Nhập tên thành phố...',
                border: InputBorder.none,
              ),
            ),
          ),
          FilledButton(
            onPressed: isLoading ? null : onSearch,
            child: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Tìm'),
          ),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final String message;
  final bool isError;

  const _StatusBanner({required this.message, required this.isError});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isError
        ? Colors.red.shade50
        : Colors.orange.shade50;
    final Color borderColor = isError
        ? Colors.red.shade200
        : Colors.orange.shade200;
    final Color textColor = isError
        ? Colors.red.shade800
        : Colors.orange.shade900;
    final IconData icon = isError
        ? Icons.error_outline_rounded
        : Icons.offline_bolt_rounded;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
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

class _WeatherDetailsGrid extends StatelessWidget {
  final WeatherProvider provider;

  const _WeatherDetailsGrid({required this.provider});

  @override
  Widget build(BuildContext context) {
    final weather = provider.currentWeather!;

    final double windSpeed = provider.convertWindSpeed(weather.windSpeed);
    final String windSymbol = provider.getWindSpeedSymbol();

    final double tempMin = provider.convertTemperature(weather.tempMin);
    final double tempMax = provider.convertTemperature(weather.tempMax);
    final String tempSymbol = provider.getTemperatureSymbol();

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 700;

        return GridView.count(
          crossAxisCount: isWide ? 3 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: isWide ? 3.1 : 2.4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            WeatherDetailItem(
              icon: Icons.water_drop_rounded,
              title: 'Độ ẩm',
              value: '${weather.humidity}%',
            ),
            WeatherDetailItem(
              icon: Icons.air_rounded,
              title: 'Tốc độ gió',
              value: '${windSpeed.toStringAsFixed(1)} $windSymbol',
            ),
            WeatherDetailItem(
              icon: Icons.speed_rounded,
              title: 'Áp suất',
              value: '${weather.pressure} hPa',
            ),
            WeatherDetailItem(
              icon: Icons.visibility_rounded,
              title: 'Tầm nhìn',
              value: weather.visibility == null
                  ? 'Không có'
                  : '${(weather.visibility! / 1000).toStringAsFixed(1)} km',
            ),
            WeatherDetailItem(
              icon: Icons.cloud_rounded,
              title: 'Mây',
              value: weather.cloudiness == null
                  ? 'Không có'
                  : '${weather.cloudiness}%',
            ),
            WeatherDetailItem(
              icon: Icons.thermostat_rounded,
              title: 'Min / Max',
              value:
                  '${tempMin.round()}$tempSymbol / ${tempMax.round()}$tempSymbol',
            ),
          ],
        );
      },
    );
  }
}

class _ForecastPreviewList extends StatelessWidget {
  final List<ForecastModel> forecasts;
  final WeatherProvider provider;

  const _ForecastPreviewList({required this.forecasts, required this.provider});

  @override
  Widget build(BuildContext context) {
    if (forecasts.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Text(
          'Chưa có dữ liệu dự báo.',
          textAlign: TextAlign.center,
        ),
      );
    }

    final List<ForecastModel> previewForecasts = forecasts.take(8).toList();

    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: previewForecasts.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final ForecastModel forecast = previewForecasts[index];

          final double temperature = provider.convertTemperature(
            forecast.temperature,
          );

          return Container(
            width: 110,
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
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Image.network(
                  forecast.iconUrl,
                  width: 48,
                  height: 48,
                  errorBuilder: (_, _, _) {
                    return const Icon(Icons.cloud_rounded, size: 42);
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  '${temperature.round()}${provider.getTemperatureSymbol()}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RecentSearchChips extends StatelessWidget {
  final List<String> cities;
  final ValueChanged<String> onTapCity;

  const _RecentSearchChips({required this.cities, required this.onTapCity});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: cities.map((String city) {
        return ActionChip(
          avatar: const Icon(Icons.location_city_rounded, size: 18),
          label: Text(city),
          onPressed: () => onTapCity(city),
        );
      }).toList(),
    );
  }
}
