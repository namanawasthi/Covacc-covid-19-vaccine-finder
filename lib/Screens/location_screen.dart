import 'package:auto_size_text/auto_size_text.dart';
import 'package:covaccination/Services/weather.dart';
import 'package:covaccination/Utilities/RoundedButton.dart';
import 'package:covaccination/Utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'city_screen.dart';
import 'package:http/http.dart' as http;

class LocationScreen extends StatefulWidget {
  LocationScreen({this.listData, this.pinCode});

  final listData;
  final pinCode;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();

  String weatherMessage = "message";
  String weatherIcon;
  String pincode = "";
  List<dynamic> list = [];

  @override
  // ignore: must_call_super
  void initState() {
    list = widget.listData;
    pincode = widget.pinCode;
    updateUI(list, pincode, "");
  }

  void updateUI(List li, String pincode, String invalid) {
    setState(() {
      if (li == null) {
        list = [];
        weatherMessage =
            "No Vaccination Slots in Your Area $pincode \n[$invalid]";
      } else if (li.length == 0)
        weatherMessage = "No Vaccination Slots in Your Area $pincode";
      else {}
      weatherIcon = weather.getWeatherIcon();
    });
  }

  void checkMultipleSlots(weatherData, String typedName) {
    weatherData != null ? list = weatherData['sessions'] as List : list = null;
    updateUI(list, typedName, "");
  }

  TableRow tableDataDisplay(
    TextStyle style,
    String text1,
    String text2,
  ) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text1,
            style: style,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text2,
            style: style,
          ),
        ),
      ],
    );
  }

  Widget dataDisplay(data) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        color: Colors.indigo,
        elevation: 5.0,
        child: Table(
          columnWidths: {
            0: FlexColumnWidth(2.5),
            1: FlexColumnWidth(3),
          },
          border: TableBorder.all(color: Colors.white),
          children: <TableRow>[
            tableDataDisplay(
                KBoldTableTextStyle, "CITY", data['district_name']),
            tableDataDisplay(KBoldTableTextStyle, "LOCATION", data['name']),
            tableDataDisplay(KBoldTableTextStyle, "ADDRESS", data['address']),
            tableDataDisplay(KBoldTableTextStyle, "BLOCK", data['block_name']),
            tableDataDisplay(
                KBoldTableTextStyle, "VACCINE NAME", data['vaccine']),
            tableDataDisplay(KBoldTableTextStyle, "AGE LIMIT",
                data['min_age_limit'].toString()),
            tableDataDisplay(KBoldTableTextStyle, "AVAILABLE CAPACITY",
                data['available_capacity'].toString()),
            tableDataDisplay(KBoldTableTextStyle, "FEE",
                "${data['fee_type'].toString()} [Rs.${data['fee'].toString()}]"),
            tableDataDisplay(KSlotTextStyle, "SLOTS",
                "{ ${data['slots'][0]} } { ${data['slots'][1]} } { ${data['slots'][2]} } { ${data['slots'][3]} }"),
          ],
        ),
      ),
    );
  }

  _launchURL() async {
    const url = 'https://selfregistration.cowin.gov.in/';
    if (await canLaunch(url)) {
      await launch(
        url,
        enableJavaScript: true,
      );
    } else {}
  }

  Future<void> _handlePost(String email) async {
    print(pincode);
    var response = await http.post(
      Uri.https('covaccination.herokuapp.com', '/api/user'),
      body: {
        "email": email,
        "pincode": pincode,
        "notification": "",
      },
    );
  }

  void showInputEmail(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size.height;
    final alphanumeric = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    String inputValue = "";
    String label = "";
    bool _isTrue;
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              //Alerts Begins here
              child: StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  elevation: 10.0,
                  title: Center(
                    child: Text(
                      "Input Your Email",
                      style: kPopUpTextStyle,
                    ),
                  ),
                  content: Container(
                    height: _mediaQuery * 0.44,
                    width: MediaQuery.of(context).size.width,
                    //color: Colors.white,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextField(
                          style: TextStyle(
                            color: Colors.indigo,
                            fontFamily: 'raleway',
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                          decoration: kEmailFieldInputDecoration,
                          onChanged: (value) {
                            inputValue = value;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Center(
                            child: Text(
                              label,
                              style: TextStyle(
                                fontFamily: 'raleway',
                                fontSize: 15.0,
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Image(
                            image: AssetImage(
                              "images/giphy.gif",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.indigo,
                              ),
                              child: Text(
                                'get subscribed',
                                style: kButtonTextStyle,
                              ),
                              onPressed: () {
                                _isTrue = alphanumeric.hasMatch(inputValue);
                                if (_isTrue == false) {
                                  setState(() {
                                    label = "Input  Email";
                                  });
                                }
                                if (inputValue != "" &&
                                    inputValue != null) if (_isTrue) {
                                  setState(() {
                                    label = "Success";
                                  });
                                  _handlePost(inputValue);
                                  Navigator.of(context, rootNavigator: true)
                                      .pop('dialog');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.indigo,
                                      content: Text(
                                        "You will be notified via email",
                                        style: TextStyle(
                                            fontFamily: 'raleway',
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                } else if (!_isTrue) {
                                  setState(() {
                                    label = "Invalid Email";
                                  });
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ); //here
              }),
              //Alert Ends Here
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        // ignore: missing_return
        pageBuilder: (context, animation1, animation2) {});
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size.height;
    final _mediaQueryStatus = MediaQuery.of(context).padding.top;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: _mediaQuery - _mediaQueryStatus,
          //constraints: BoxConstraints.expand(),
          child: SafeArea(
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 20.0),
                      height: _mediaQuery * 0.15 - _mediaQueryStatus,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          AutoSizeText(
                            weather.updateSum(list).toString(),
                            style: kTempTextStyle,
                            maxLines: 1,
                            maxFontSize: 70,
                            minFontSize: 30,
                          ),
                          AutoSizeText(
                            weatherIcon,
                            style: kConditionTextStyle,
                            maxLines: 1,
                            maxFontSize: 50,
                            minFontSize: 20,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (list == null || list.length == 0)
                          Card(
                            margin: EdgeInsets.only(
                                top: 10.0, bottom: 10.0, left: 8.0, right: 8.0),
                            color: Colors.white,
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: AutoSizeText(
                                    weatherMessage,
                                    maxLines: 6,
                                    maxFontSize: 30,
                                    minFontSize: 15,
                                    style: TextStyle(
                                      fontFamily: 'raleway',
                                      fontSize: 20.0,
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          for (int i = 0; i < list.length && list != null; i++)
                            dataDisplay(list[i]),
                        if (list.length != 0 && list != null)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.indigo,
                            ),
                            child: Text(
                              'Book Now',
                              style: kButtonTextStyle,
                            ),
                            onPressed: _launchURL,
                          ),
                      ],
                    ),
                    if (list == null || list.length == 0)
                      SizedBox(height: _mediaQuery * 0.05 - _mediaQueryStatus),
                    if (list == null || list.length == 0)
                      Container(
                        //padding: EdgeInsets.all(15.0),
                        height: _mediaQuery * 0.09 - _mediaQueryStatus,
                        color: Colors.white,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 40.0, right: 40.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.indigo,
                            ),
                            child: Text(
                              "Notify me when it's available",
                              style: TextStyle(
                                fontFamily: 'raleway',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              showInputEmail(context);
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    if (list == null || list.length == 0)
                      SizedBox(height: _mediaQuery * 0.05 - _mediaQueryStatus),
                    if (list == null || list.length == 0)
                      Image(
                        image: AssetImage('images/geto.gif'),
                        height: _mediaQuery * 0.50 - _mediaQueryStatus,
                      ),
                    Container(
                      color: Colors.white,
                      height: _mediaQuery * 0.15 - _mediaQueryStatus,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          RoundedButton(
                            colour: Colors.indigo,
                            title: "Fetch by Pincode",
                            onPressed: () async {
                              Map<String, String> _list = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return CityScreen();
                                }),
                              );
                              if (_list != null) {
                                var typedName = _list['cityName'];
                                var date = _list['date'];
                                if (typedName != null) {
                                  var weatherData = await weather
                                      .getCityWeather(typedName, date);
                                  weatherData != null
                                      ? checkMultipleSlots(
                                          weatherData, typedName)
                                      : updateUI(null, typedName.toString(),
                                          "Invalid Pincode");
                                } else {}
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
