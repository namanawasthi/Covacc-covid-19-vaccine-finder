import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color colour;
  final String title;
  final Function onPressed;

  RoundedButton({this.colour, @required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      color: colour,
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        onPressed: onPressed,
        padding: EdgeInsets.all(8.0),
        height: MediaQuery.of(context).size.height * 0.05,
        minWidth: MediaQuery.of(context).size.width * 0.95,
        child: Text(
          title,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'raleway',
              fontSize: 20.0),
        ),
      ),
    );
  }
}
