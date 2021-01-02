import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodwallet_app/Voice_Input.dart';

class ConfirmedMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          body1: TextStyle(
            fontFamily: "HinSiliguri",
            fontSize: 20.0,
            color: Colors.white,
          ),
          button: TextStyle(
            fontFamily: "HinSiliguri",
            fontSize: 20.0,
          ),
        ),
      ),
      home: Scaffold(
        body: Container(
          //Background Gradient Color
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffAE90F4), Color(0xffDF8D9F)],
            ),
          ),
          child: SafeArea(child: ConfirmedPage()),
        ),
      ),
    );
  }
}

class ConfirmedPage extends StatefulWidget {
  @override
  _ConfirmedPageState createState() => _ConfirmedPageState();
}

class _ConfirmedPageState extends State<ConfirmedPage> {
  @override
  Widget build(BuildContext context) {
    var _screenWidth = MediaQuery.of(context).size.width;
    var _screenHeight = MediaQuery.of(context).size.height;
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 171,
          ),
          Container(
            child: SvgPicture.asset(
              'images/check-mark.svg',
              height: 169.0,
              width: 169.0,
              color: Colors.white,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 37),
            child: Text('This item has been saved'),
          ),
          SizedBox(
            height: 100,
          ),
          Container(
            alignment: Alignment.center,
            height: 51,
            width: 268,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Colors.white, width: 5.0, style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(27.0)),
            ),
            child: Listener(
              onPointerDown: (detail) {
                print('go to add transaction page');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VoiceInputMainPage()),
                );
              },
              child: Text(
                'ADD NEW TRANSACTION',
                style: TextStyle(color: Color(0xff6A2388)),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 16),
            height: 51,
            width: 268,
            decoration: BoxDecoration(
              color: Color(0xff580F77),
              border: Border.all(
                  color: Color(0xff580F77),
                  width: 5.0,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(27.0)),
            ),
            child: Listener(
              onPointerDown: (detail) {
                print('going to transaction lists');
              },
              child: Text(
                'SHOW TRANSACTIONS',
              ),
            ),
          )
        ],
      ),
    );
  }
}
