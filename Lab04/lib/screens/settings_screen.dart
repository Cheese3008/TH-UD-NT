import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WeatherProvider provider = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cài đặt',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SettingsHeader(provider: provider),
            const SizedBox(height: 24),

            const _SectionTitle(
              icon: Icons.thermostat_rounded,
              title: 'Đơn vị nhiệt độ',
            ),
            const SizedBox(height: 12),
            _OptionCard(
              children: [
                _RadioSettingTile<String>(
                  title: 'Celsius',
                  subtitle: 'Hiển thị nhiệt độ theo độ C',
                  value: 'celsius',
                  groupValue: provider.temperatureUnit,
                  trailingText: '°C',
                  onChanged: (String value) {
                    context.read<WeatherProvider>().updateTemperatureUnit(
                      value,
                    );
                  },
                ),
                const Divider(height: 1),
                _RadioSettingTile<String>(
                  title: 'Fahrenheit',
                  subtitle: 'Hiển thị nhiệt độ theo độ F',
                  value: 'fahrenheit',
                  groupValue: provider.temperatureUnit,
                  trailingText: '°F',
                  onChanged: (String value) {
                    context.read<WeatherProvider>().updateTemperatureUnit(
                      value,
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            const _SectionTitle(
              icon: Icons.air_rounded,
              title: 'Đơn vị tốc độ gió',
            ),
            const SizedBox(height: 12),
            _OptionCard(
              children: [
                _RadioSettingTile<String>(
                  title: 'Mét trên giây',
                  subtitle: 'Đơn vị mặc định từ OpenWeatherMap',
                  value: 'ms',
                  groupValue: provider.windSpeedUnit,
                  trailingText: 'm/s',
                  onChanged: (String value) {
                    context.read<WeatherProvider>().updateWindSpeedUnit(value);
                  },
                ),
                const Divider(height: 1),
                _RadioSettingTile<String>(
                  title: 'Kilômét trên giờ',
                  subtitle: 'Phù hợp cách đọc phổ biến tại Việt Nam',
                  value: 'kmh',
                  groupValue: provider.windSpeedUnit,
                  trailingText: 'km/h',
                  onChanged: (String value) {
                    context.read<WeatherProvider>().updateWindSpeedUnit(value);
                  },
                ),
                const Divider(height: 1),
                _RadioSettingTile<String>(
                  title: 'Dặm trên giờ',
                  subtitle: 'Đơn vị mph',
                  value: 'mph',
                  groupValue: provider.windSpeedUnit,
                  trailingText: 'mph',
                  onChanged: (String value) {
                    context.read<WeatherProvider>().updateWindSpeedUnit(value);
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            const _SectionTitle(
              icon: Icons.schedule_rounded,
              title: 'Định dạng thời gian',
            ),
            const SizedBox(height: 12),
            _OptionCard(
              children: [
                _RadioSettingTile<String>(
                  title: '24 giờ',
                  subtitle: 'Ví dụ: 16:30',
                  value: '24h',
                  groupValue: provider.timeFormat,
                  trailingText: '24h',
                  onChanged: (String value) {
                    context.read<WeatherProvider>().updateTimeFormat(value);
                  },
                ),
                const Divider(height: 1),
                _RadioSettingTile<String>(
                  title: '12 giờ',
                  subtitle: 'Ví dụ: 04:30 PM',
                  value: '12h',
                  groupValue: provider.timeFormat,
                  trailingText: '12h',
                  onChanged: (String value) {
                    context.read<WeatherProvider>().updateTimeFormat(value);
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            const _SectionTitle(
              icon: Icons.language_rounded,
              title: 'Ngôn ngữ',
            ),
            const SizedBox(height: 12),
            _OptionCard(
              children: [
                _RadioSettingTile<String>(
                  title: 'Tiếng Việt',
                  subtitle: 'Giao diện và mô tả ưu tiên tiếng Việt',
                  value: 'vi',
                  groupValue: provider.languageCode,
                  trailingText: 'VI',
                  onChanged: (String value) {
                    context.read<WeatherProvider>().updateLanguage(value);
                  },
                ),
                const Divider(height: 1),
                _RadioSettingTile<String>(
                  title: 'English',
                  subtitle: 'English display preference',
                  value: 'en',
                  groupValue: provider.languageCode,
                  trailingText: 'EN',
                  onChanged: (String value) {
                    context.read<WeatherProvider>().updateLanguage(value);
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            _InfoBox(
              title: 'Lưu ý',
              message:
                  'Các cài đặt sẽ được lưu trên thiết bị bằng SharedPreferences. Khi đổi đơn vị, dữ liệu đang hiển thị sẽ được cập nhật ngay.',
              icon: Icons.info_outline_rounded,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  final WeatherProvider provider;

  const _SettingsHeader({required this.provider});

  @override
  Widget build(BuildContext context) {
    final String temperatureUnit = provider.temperatureUnit == 'fahrenheit'
        ? '°F'
        : '°C';

    final String windUnit = provider.getWindSpeedSymbol();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withAlpha(170),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withAlpha(70),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(45),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.settings_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tùy chỉnh hiển thị',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$temperatureUnit • $windUnit • ${provider.timeFormat}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withAlpha(230),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

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

class _OptionCard extends StatelessWidget {
  final List<Widget> children;

  const _OptionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(16),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(children: children),
      ),
    );
  }
}

class _RadioSettingTile<T> extends StatelessWidget {
  final String title;
  final String subtitle;
  final T value;
  final T groupValue;
  final String trailingText;
  final ValueChanged<T> onChanged;

  const _RadioSettingTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.trailingText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade500,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withAlpha(25)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary.withAlpha(90)
                      : Colors.grey.shade300,
                ),
              ),
              child: Text(
                trailingText,
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const _InfoBox({
    required this.title,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: TextStyle(color: Colors.blue.shade900, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
