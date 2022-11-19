import 'package:first_lesson/data/models/detail/daily_item/daily_item.dart';
import 'package:first_lesson/ui/screens/weahter_main/weather_main_screen.dart';
import 'package:first_lesson/ui/screens/weather_detail/weather_detail_screen.dart';
import 'package:first_lesson/utils/constants.dart';
import 'package:flutter/material.dart';

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mainScreen:
        return MaterialPageRoute(builder: (_) => WeatherMainScreen());
      case dailyScreen:
        return MaterialPageRoute(
          builder: (_) => WeatherDailyScreen(
            daily: settings.arguments as List<DailyItem>,
          ),
        );
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                  child: Text('No route defined for ${settings.name}')),
            ));
    }
  }
}