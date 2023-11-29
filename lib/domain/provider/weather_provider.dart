import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/domain/api/api.dart';
import 'package:weather_app/domain/models/coord.dart';
import 'package:weather_app/domain/models/weather_data.dart';
import 'package:weather_app/ui/resources/app_bg.dart';

class WeatherProvider extends ChangeNotifier {
  //хранение координат
  Coord? coords;

  //хранение данных о погоде
  WeatherData? weatherData;

  //хранение текущих данных о погоде
  Current? current;

  //коньроллер для установки города
  TextEditingController cityController = TextEditingController();
  int currentTemp = 0;
  int kelvin = -273;
  //Главную функцию которую мы запустим в FutureBuilder
  Future<WeatherData?> setUp({String? cityName}) async {
    coords = await Api.getCoords(cityName: cityName ?? 'Ташкент');
    weatherData = await Api.getWeather(coords);
    current = weatherData?.current;
    //
    setCurrentTime();

    currentTemp = ((current?.temp ?? -kelvin) + kelvin).round();

    setWeekDays();

    return weatherData;
  }

  //изменение заднего фона
  String? currentBg;

  String setBg() {
    int id = current?.weather?[0].id ?? -1;

    if (id == -1 || current?.sunset == null || current?.dt == null) {
      currentBg = AppBg.shinyDay;
    }

    try {
      if (current?.sunset < current?.dt) {
        if (id >= 200 && id <= 531) {
          currentBg = AppBg.rainyNight;
        } else if (id >= 600 && id <= 622) {
          currentBg = AppBg.snowNight;
        } else if (id >= 701 && id <= 781) {
          currentBg = AppBg.fogNight;
        } else if (id == 800) {
          currentBg = AppBg.shinyNight;
        } else if (id >= 801 && id <= 804) {
          currentBg = AppBg.cloudyNight;
        }
      } else {
        if (id >= 200 && id <= 531) {
          currentBg = AppBg.rainyDay;
        } else if (id >= 600 && id <= 622) {
          currentBg = AppBg.snowDay;
        } else if (id >= 701 && id <= 781) {
          currentBg = AppBg.fogDay;
        } else if (id == 800) {
          currentBg = AppBg.shinyDay;
        } else if (id >= 801 && id <= 804) {
          currentBg = AppBg.cloudyDay;
        }
      }
    } catch (e) {
      return AppBg.shinyDay;
    }
    return currentBg ?? AppBg.shinyDay;
  }

  //текущее время

  String? currentTime;
  String setCurrentTime() {
    final getTime = (current?.dt ?? 0) + (weatherData?.timezoneOffset ?? 0);
    final setTime = DateTime.fromMillisecondsSinceEpoch(getTime * 1000);
    currentTime = DateFormat('HH:mm a').format(setTime);
    return currentTime ?? 'Error';
  }

  //Метод превращения первой буквы слова в заглавную, остальные строчные
  String capitalize(String str) => str[0].toUpperCase() + str.substring(1);

  /* текущий статус погоды */
  String iconUrl = 'https://api.openweathermap.org/img/w/';

  // метод получения текущей иконки
  String iconData() {
    return '$iconUrl${current?.weather?[0].icon}.png';
  }

  //метод текущего статуса погоды
  String currentStatus = 'Ошибка';

  String getCurrentStatus() {
    currentStatus = current?.weather?[0].description ?? 'Ошибка';
    return capitalize(currentStatus);
  }

  //получение текущей температуры



  //получение максимальной температуры

  int maxTemp = 0;

  int setMaxTemp() {
    maxTemp = ((weatherData?.daily?[0].temp?.max ?? -kelvin) + kelvin).round();
    return maxTemp;
  }

  //получение минимальной температуры

  int minTemp = 0;

  int setMinTemp() {
    minTemp = ((weatherData?.daily?[0].temp?.min ?? -kelvin) + kelvin).round();
    return minTemp;
  }

  //установка дней недели

  final List<String> date = [];
  List<Daily> daily = [];

  void setWeekDays() {
    daily = weatherData?.daily ?? [];
    for (var i = 0; i < daily.length; i++) {
      if (i == 0 && daily.isNotEmpty) {
        date.clear();
      }
      if (i == 0) {
        date.add('Сегодня');
      } else {
        var timeNum = daily[i].dt * 1000;
        var itemDate = DateTime.fromMillisecondsSinceEpoch(timeNum);
        date.add(capitalize(DateFormat('EEEE', 'ru').format(itemDate)));
      }
    }
  }

  // метод получения  иконок на все неделю

  String setDailyIcons(int index) {
    final String getIcon = '${weatherData?.daily?[index].weather?[0].icon}';
    final String setIcon = '$iconUrl$getIcon.png';

    return setIcon;
  }

  /* получение дневной температуры на каждый день*/

  int dailyTemp = 0;

  int setDailyTemp(int index) {
    dailyTemp =
        ((weatherData?.daily?[index].temp?.morn ?? -kelvin) + kelvin).round();
    return dailyTemp;
  }
  /* получение вечерней температуры на каждый день*/

  int nightTemp = 0;

  int setNigthTemp(int index) {
    nightTemp =
        ((weatherData?.daily?[index].temp?.night ?? -kelvin) + kelvin).round();
    return nightTemp;
  }
}
