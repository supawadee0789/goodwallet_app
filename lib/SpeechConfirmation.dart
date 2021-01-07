import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as Http;
import 'dart:convert' as utf8;
import 'package:carousel_slider/carousel_slider.dart';

import "dart:async";

import 'package:goodwallet_app/ConfirmedPage.dart';
import 'package:goodwallet_app/Voice_Input.dart';
import 'components/Header.dart';

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
          child: SafeArea(child: ConfirmationPage(resultText: text)),
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
  var tokens;
  String type; // type of transaction eg. income expense transfer
  String _class; // class of transaction eg. health food
  String name; // name of transaction eg. ซื้อข้าวกระเพรา
  var cost; // cost of transaction
  String targetWallet; // target wallet to transfer money

  final _fireStore = Firestore.instance;

  @override
  void initState() {
    super.initState();
  }

  Future WordSegmentation(_text) async {
    var url = "https://api.aiforthai.in.th/tlexplus?text=" + _text;
    await Http.get(url, headers: {"Apikey": "elHOb4Ksl715HkIu6Leq5ZdcnYX39SPP"})
        .then((response) {
      print("Response status: ${response.body}");
      var parsedJson = utf8.jsonDecode(response.body);
      tokens = parsedJson['tokens'];
    });
  }

  final String resultText;
  _ConfirmationPageState({Key key, @required this.resultText});

  @override
  Widget build(BuildContext context) {
    var _screenWidth = MediaQuery.of(context).size.width;
    var _screenHeight = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Header(),
          SizedBox(height: 10, width: _screenWidth),
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
                    child: Text(
                  'Expense',
                  style: TextStyle(fontSize: 28),
                )),
                ClassSlider(),
              ],
            ),
          ),
          SizedBox(
            height: 53,
          ),
          Container(
            width: _screenWidth * 0.8,
            child: Text(
              resultText ?? 'waiting for text',
              textAlign: TextAlign.center,
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
                        print(checkClass(_currentIndex));
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VoiceInput()),
                        ); // cancel confirmation
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
                      onPointerDown: (detail) async {
                        await WordSegmentation(resultText);
                        print('confirm');
                        // print(checkName(tokens, checkCost(tokens)));
                        // print(checkCost(tokens));
                        _fireStore
                            .collection('wallet')
                            .document('uOLtbBvDP9lJ2UDfP1GU')
                            .collection('transaction')
                            .add({
                          'class': checkClass(_currentIndex),
                          'cost': double.parse(checkCost(tokens)) ?? 0,
                          'createdOn': FieldValue.serverTimestamp(),
                          'name': checkName(tokens, checkCost(tokens)),
                          'type': checkType(tokens[0]) ?? 'null'
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConfirmedMainPage()),
                        ); // confirm to add transaction
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

int _currentIndex = 0;

class ClassSlider extends StatefulWidget {
  @override
  _ClassSliderState createState() => _ClassSliderState();
}

class _ClassSliderState extends State<ClassSlider> {
  List cardList = [
    ClassItem('Food'),
    ClassItem('Daily use'),
    ClassItem('Household'),
    ClassItem('Travel'),
    ClassItem('Health'),
    ClassItem('Entertainment'),
    ClassItem('Housing')
  ];
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 160.0,
        autoPlay: false,
        // autoPlayInterval: Duration(seconds: 3),
        // autoPlayAnimationDuration: Duration(milliseconds: 800),
        // autoPlayCurve: Curves.fastOutSlowIn,
        pauseAutoPlayOnTouch: true,
        aspectRatio: 2.0,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      items: cardList.map((card) {
        return Builder(builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width,
            child: Container(
              color: Color(0xff9967B2),
              child: card,
            ),
          );
        });
      }).toList(),
    );
  }
}

class ClassItem extends StatelessWidget {
  @override
  final class_name;
  ClassItem(this.class_name);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 26),
      child: Column(children: [
        SvgPicture.asset(
          'images/' + class_name + '.svg',
          height: 71.0,
          width: 85.0,
        ),
        Container(
          margin: EdgeInsets.only(top: 14),
          child: Text(class_name),
        )
      ]),
    );
  }
}

checkType(input) {
  String _type;
  if (input == 'ได้') {
    _type = 'income';
  } else if (input == 'ซื้อ') {
    _type = 'expense';
  } else if (input == 'โอน') {
    _type = 'transfer';
  } else {
    _type = 'none';
  }
  return _type;
}

checkCost(array) {
  var costLoc = -1;
  for (var loc = array.length - 1; loc >= 0; loc--) {
    if (_isNumeric(array[loc])) {
      costLoc = loc;
      break;
    }
  }
  print(array[costLoc]);
  return array[costLoc];
}

bool _isNumeric(String str) {
  if (str == null) {
    return false;
  }
  return double.tryParse(str) != null;
}

checkName(array, costLoc) {
  print(array);
  for (var i = 0; i <= 3; i++) {
    array.removeLast();
    print(array);
  }
  var name = StringBuffer();

  array.forEach((item) {
    name.write(item);
  });
  return name.toString();
}

checkClass(_index) {
  String className;
  switch (_index) {
    case 0:
      {
        className = 'food';
      }
      break;

    case 1:
      {
        className = 'daily_use';
      }
      break;
    case 2:
      {
        className = 'household';
      }
      break;
    case 3:
      {
        className = 'travel';
      }
      break;
    case 4:
      {
        className = 'health';
      }
      break;
    case 5:
      {
        className = 'entertainment';
      }
      break;
    case 6:
      {
        className = 'housing';
      }
      break;
    default:
      {
        className = 'food';
      }
      break;
  }
  return className;
}
