import 'package:intl/intl.dart';

import 'location.dart';
import 'networking.dart';

const apiKey = '98f6e607eb46e1807f63f62f8e215460';
const openWeatherMapURL =
    'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin';

class WeatherModel {
  String _date = DateTime.now().toString().split(' ')[0];

  String get date => _date;

  set date(String value) {
    _date = value.split(' ')[0];
  }

  Future<dynamic> getCityWeather(String cityName, String date) async {
    var url =
        '$openWeatherMapURL?pincode=$cityName&date=${DateFormat("dd-MM-yyyy").format(DateTime.parse(date))}';
    NetworkHelper networkHelper = NetworkHelper(url);
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();
    NetworkHelper networkHelper = NetworkHelper(
        'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=${Location.pin}&date=${DateFormat("dd-MM-yyyy").format(DateTime.now())}');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  String getWeatherIcon() {
    return '💉 ';
  }

  int updateSum(List li) {
    int sum = 0;
    for (int i = 0; i < li.length && li != null; i++)
      sum = sum + li[i]['available_capacity'];
    return sum;
  }
}
