import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:covaccination/Services/weather.dart';
import 'package:covaccination/Utilities/RoundedButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'location_screen.dart';
import 'package:covaccination/Services/location.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  // ignore: must_call_super
  void initState() {}

  void getLocationData() async {
    var weatherData = await WeatherModel().getLocationWeather();
    List list = weatherData['sessions'] as List;
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationScreen(
        listData: list,
        pinCode: Location.pin,
      );
    }));
  }

  updateScreen() {
    getLocationData();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size.height;
    final _mediaQueryStatus = MediaQuery.of(context).padding.top;
    final _unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    final _multiplier = 6.0;
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: _mediaQuery * 0.10 - _mediaQueryStatus),
                FittedBox(
                  child: TextLiquidFill(
                    boxHeight: _mediaQuery * 0.25 - _mediaQueryStatus,
                    text: 'VACCINATED\nINDIA',
                    textAlign: TextAlign.center,
                    waveColor: Colors.blueAccent,
                    boxBackgroundColor: Colors.white,
                    textStyle: TextStyle(
                      fontSize: _multiplier * _unitHeightValue,
                      fontFamily: 'raleway',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: _mediaQuery * 0.1 - _mediaQueryStatus),
                Image(
                  image: AssetImage(
                    "images/doc.gif",
                  ),
                  height: _mediaQuery * 0.4 - _mediaQueryStatus,
                ),
                SizedBox(height: _mediaQuery * 0.1 - _mediaQueryStatus),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: RoundedButton(
                    title: "Check Vaccine",
                    colour: Colors.indigo,
                    onPressed: updateScreen,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
