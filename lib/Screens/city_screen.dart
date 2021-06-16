import 'package:covaccination/Services/weather.dart';
import 'package:covaccination/Utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CityScreen extends StatefulWidget {
  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  String cityName;
  DateTime dateTime;
  WeatherModel weatherModel = WeatherModel();

  Widget dateFromCalender() {
    final _mediaQueryWidth = MediaQuery.of(context).size.width;
    return Container(
      width: _mediaQueryWidth * 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.indigo,
            ),
            child: Text(
              dateTime == null
                  ? 'Pick a Date'
                  : dateTime.toString().split(' ')[0],
              style: kButtonTextStyle,
            ),
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2021),
                lastDate: DateTime(2022),
              ).then((date) => {
                    setState(() {
                      if (date != null) {
                        dateTime = date;
                        weatherModel.date = dateTime.toString();
                      }
                    }),
                  });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size.height;
    final _mediaQueryStatus = MediaQuery.of(context).padding.top;
    final _mediaQueryWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: ListView(
            children: <Widget>[
              Container(
                height: _mediaQuery * 0.13 - _mediaQueryStatus,
                color: Colors.white,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: TextButton(
                        child: Icon(
                          Icons.arrow_back,
                          size: 38.0,
                          color: Colors.indigo,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                ),
              ),
              SizedBox(height: _mediaQuery * 0.05 - _mediaQueryStatus),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                  decoration: kTextFieldInputDecoration,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    cityName = value;
                  },
                ),
              ),
              SizedBox(height: _mediaQuery * 0.05 - _mediaQueryStatus),
              Container(
                color: Colors.white,
                height: _mediaQuery * 0.12 - _mediaQueryStatus,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    dateFromCalender(),
                    Container(
                      width: _mediaQueryWidth * 0.4,
                      margin: EdgeInsets.only(right: 10.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.indigo,
                        ),
                        child: Text(
                          'Fetch Slots',
                          style: kButtonTextStyle,
                        ),
                        onPressed: () {
                          Map<String, String> data = {
                            "cityName": cityName,
                            "date": weatherModel.date
                          };
                          Navigator.pop(context, data);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: _mediaQuery * 0.05 - _mediaQueryStatus),
              Image(
                image: AssetImage(
                  "images/vac.gif",
                ),
                fit: BoxFit.cover,
                height: _mediaQuery * 0.40 - _mediaQueryStatus,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
