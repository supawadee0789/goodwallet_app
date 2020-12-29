import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "dart:async";

import 'package:goodwallet_app/ConfirmedPage.dart';

class ConfirmationMainPage extends StatelessWidget {
  final String text;
  ConfirmationMainPage({Key key, @required this.text}) : super(key: key);

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
          child: ConfirmationPage(resultText: text),
        ),
      ),
    );
  }
}

class ConfirmationPage extends StatefulWidget {
  final String resultText;
  ConfirmationPage({Key key, @required this.resultText}) : super(key: key);

  @override
  _ConfirmationPageState createState() =>
      _ConfirmationPageState(resultText: resultText);
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  final String resultText;
  _ConfirmationPageState({Key key, @required this.resultText});
  String _editImage = 'images/ConfirmationPage_Edit.svg';
  bool _isEditing = true;
  @override
  Widget build(BuildContext context) {
    var _screenWidth = MediaQuery.of(context).size.width;
    var _screenHeight = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(height: 100, width: _screenWidth),
          Container(
            height: 217,
            width: 211,
            decoration: BoxDecoration(
              color: Color(0xff9967B2),
              border: Border.all(
                  color: Color(0xff9967B2),
                  width: 5.0,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(21.0)),
            ),
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(right: 14.5),
                          child: Text(
                            'Expense',
                            style: TextStyle(fontSize: 28),
                          )),
                      Listener(
                        onPointerDown: (detail) {
                          setState(() {
                            if (_isEditing) {
                              _editImage = 'images/edit_arrow_white.svg';
                              _isEditing = false;
                              print('editing');
                            } else {
                              _editImage = 'images/ConfirmationPage_Edit.svg';
                              _isEditing = true;
                              print('edited');
                            }
                          });
                        },
                        child: SvgPicture.asset(
                          _editImage,
                          height: 20.0,
                          width: 20.0,
                          color: _isEditing ? null : Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 26),
                  child: Column(children: [
                    SvgPicture.asset(
                      'images/medical-kit.svg',
                      height: 71.0,
                      width: 85.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 14),
                      child: Text('Health'),
                    )
                  ]),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 53,
          ),
          Container(
            child: Text(
              resultText ?? 'waiting for text',
              style: TextStyle(fontSize: 28),
            ),
          ),
          SizedBox(
            height: 85,
          ),
          Container(
            width: _screenWidth * 0.7,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Listener(
                      onPointerDown: (detail) {
                        print('cancel');
                        Navigator.pop(
                          context,
                        );
                      },
                      child: SvgPicture.asset(
                        'images/cross-mark-on-a-black-circle-background.svg',
                        height: 85.0,
                        width: 85.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Listener(
                      onPointerDown: (detail) {
                        print('confirm');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConfirmedMainPage()),
                        );
                      },
                      child: SvgPicture.asset(
                        'images/check-mark.svg',
                        height: 85.0,
                        width: 85.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
