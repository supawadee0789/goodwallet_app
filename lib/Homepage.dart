import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodwallet_app/main.dart';
import 'Login_popup.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var _screenWidth = MediaQuery.of(context).size.width;
    var _screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: (252.5 / 760) * _screenHeight),
            child:
                Hero(tag: 'pop_up', child: SvgPicture.asset('images/Logo.svg')),
          ),
          Container(
            padding: EdgeInsets.only(bottom: (38 / 760) * _screenHeight),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LoginPopup();
                }));
              },
              child: Column(
                children: <Widget>[
                  // Icon(
                  //   Icons.keyboard_arrow_up_rounded,
                  //   color: Colors.white,
                  //   size: 30,
                  // ),
                  Text(
                    "TOUCH\nTO START",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
