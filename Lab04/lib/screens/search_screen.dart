import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _searchCity() async {
    final String cityName = _cityController.text.trim();

    if (cityName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên thành phố.')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    await context.read<WeatherProvider>().fetchWeatherByCity(cityName);

    if (!mounted) {
      return;
    }

    final WeatherProvider provider = context.read<WeatherProvider>();

    if (provider.currentWeather != null && !provider.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đã tải thời tiết cho ${provider.currentWeather!.cityName}.',
          ),
        ),
      );
    }
  }

  Future<void> _searchCityFromChip(String cityName) async {
    _cityController.text = cityName;
    await context.read<WeatherProvider>().fetchWeatherByCity(cityName);
  }

  @override
  Widget build(BuildContext context) {
    final WeatherProvider provider = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tìm kiếm thành phố',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SearchInputBox(
              controller: _cityController,
              isLoading: provider.isLoading,
              onSearch: _searchCity,
            ),

            const SizedBox(height: 20),

            if (provider.errorMessage.isNotEmpty)
              _MessageBox(
                message: provider.errorMessage,
                isError: provider.hasError,
              ),

            if (provider.currentWeather != null)
              _CurrentCityResultCard(provider: provider),

            const SizedBox(height: 24),

            _SectionHeader(
              title: 'Thành phố yêu thích',
              icon: Icons.favorite_rounded,
              trailing: provider.favoriteCities.length >= 5
                  ? const Text('Tối đa 5', style: TextStyle(color: Colors.grey))
                  : null,
            ),

            const SizedBox(height: 12),

            if (provider.favoriteCities.isEmpty)
              const _EmptyBox(message: 'Chưa có thành phố yêu thích.')
            else
              _CityChipList(
                cities: provider.favoriteCities,
                icon: Icons.favorite_rounded,
                onTapCity: _searchCityFromChip,
              ),

            const SizedBox(height: 24),

            _SectionHeader(
              title: 'Tìm kiếm gần đây',
              icon: Icons.history_rounded,
              trailing: provider.recentSearches.isEmpty
                  ? null
                  : TextButton(
                      onPressed: () {
                        context.read<WeatherProvider>().clearRecentSearches();
                      },
                      child: const Text('Xóa'),
                    ),
            ),

            const SizedBox(height: 12),

            if (provider.recentSearches.isEmpty)
              const _EmptyBox(message: 'Chưa có lịch sử tìm kiếm.')
            else
              _CityChipList(
                cities: provider.recentSearches,
                icon: Icons.location_city_rounded,
                onTapCity: _searchCityFromChip,
              ),
          ],
        ),
      ),
    );
  }
}

class _SearchInputBox extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSearch;

  const _SearchInputBox({
    required this.controller,
    required this.isLoading,
    required this.onSearch,
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
                hintText: 'Ví dụ: Ha Noi, Da Nang, Tokyo...',
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

class _CurrentCityResultCard extends StatelessWidget {
  final WeatherProvider provider;

  const _CurrentCityResultCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final weather = provider.currentWeather!;
    final bool isFavorite = provider.isCityFavorite(weather.cityName);
    final double temperature = provider.convertTemperature(weather.temperature);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(18),
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
          Image.network(
            weather.iconUrl,
            width: 56,
            height: 56,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.cloud_rounded, size: 48);
            },
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${weather.cityName}, ${weather.country}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${temperature.round()}${provider.getTemperatureSymbol()} - ${weather.description}',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: isFavorite ? 'Xóa khỏi yêu thích' : 'Thêm vào yêu thích',
            onPressed: () {
              context.read<WeatherProvider>().toggleCurrentCityFavorite();
            },
            icon: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: isFavorite ? Colors.red : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CityChipList extends StatelessWidget {
  final List<String> cities;
  final IconData icon;
  final ValueChanged<String> onTapCity;

  const _CityChipList({
    required this.cities,
    required this.icon,
    required this.onTapCity,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: cities.map((String city) {
        return ActionChip(
          avatar: Icon(icon, size: 18),
          label: Text(city),
          onPressed: () => onTapCity(city),
        );
      }).toList(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;

  const _SectionHeader({
    required this.title,
    required this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class _MessageBox extends StatelessWidget {
  final String message;
  final bool isError;

  const _MessageBox({required this.message, required this.isError});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isError ? Colors.red.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isError ? Colors.red.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isError ? Colors.red.shade800 : Colors.orange.shade900,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  final String message;

  const _EmptyBox({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(message, style: TextStyle(color: Colors.grey.shade700)),
    );
  }
}
