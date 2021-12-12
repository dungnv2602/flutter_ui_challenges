import 'package:flutter/widgets.dart';

final RadialListViewModel forecastRadialList = RadialListViewModel(
  items: [
    RadialListItemViewModel(
      icon: const AssetImage('assets/images/weather_forecast/ic_rain.png'),
      title: '11:30',
      subtitle: 'Light Rain',
      isSelected: true,
    ),
    RadialListItemViewModel(
      icon: const AssetImage('assets/images/weather_forecast/ic_rain.png'),
      title: '12:30P',
      subtitle: 'Light Rain',
    ),
    RadialListItemViewModel(
      icon: const AssetImage('assets/images/weather_forecast/ic_cloudy.png'),
      title: '1:30P',
      subtitle: 'Cloudy',
    ),
    RadialListItemViewModel(
      icon: const AssetImage('assets/images/weather_forecast/ic_sunny.png'),
      title: '2:30P',
      subtitle: 'Sunny',
    ),
    RadialListItemViewModel(
      icon: const AssetImage('assets/images/weather_forecast/ic_sunny.png'),
      title: '3:30P',
      subtitle: 'Sunny',
    ),
  ],
);

class RadialListViewModel {
  const RadialListViewModel({
    this.items = const [],
  });

  final List<RadialListItemViewModel> items;
}

class RadialListItemViewModel {
  RadialListItemViewModel({
    this.icon,
    this.title = '',
    this.subtitle = '',
    this.isSelected = false,
  });

  final ImageProvider icon;
  final bool isSelected;
  final String subtitle;
  final String title;
}
