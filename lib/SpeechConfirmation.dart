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
  final index;
  ConfirmationMainPage({Key key, @required this.text, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //Background Gradient Color
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffAE90F4), Color(0xffDF8D9F)],
          ),
        ),
        child:
            SafeArea(child: ConfirmationPage(resultText: text, index: index)),
      ),
    );
  }
}

class ConfirmationPage extends StatefulWidget {
  final String resultText;
  final index;
  ConfirmationPage({Key key, @required this.resultText, this.index})
      : super(key: key);

  @override
  _ConfirmationPageState createState() =>
      _ConfirmationPageState(resultText: resultText, index: index);
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  final String resultText;
  final index;
  String _screenType = '';
  _ConfirmationPageState({Key key, @required this.resultText, this.index});

  final _fireStore = Firestore.instance;
  var currentTransaction;
  @override
  void initState() {
    super.initState();
    WordSegmentation(resultText);
    // print(currentTransaction.tokens);
    print(index);
  }

  Future WordSegmentation(_text) async {
    var url = "https://api.aiforthai.in.th/lextoplus?text=" + _text;
    await Http.get(url, headers: {"Apikey": "elHOb4Ksl715HkIu6Leq5ZdcnYX39SPP"})
        .then((response) async {
      print("Response status: ${response.body}");
      var parsedJson = utf8.jsonDecode(response.body);
      print(parsedJson);
      currentTransaction =
          new Transaction(parsedJson['tokens'], parsedJson['types']);
      print(currentTransaction.tokens);
      await currentTransaction.setAllVariables();
      setState(() {
        _screenType = currentTransaction.type;
        if (_screenType == 'Income') {
          buttonCarouselController.animateToPage(7,
              duration: Duration(milliseconds: 300), curve: Curves.linear);
        } else if (_screenType == 'Transfer') {
          buttonCarouselController.animateToPage(8,
              duration: Duration(milliseconds: 300), curve: Curves.linear);
        }
      });
    });
  }

  CarouselController buttonCarouselController = CarouselController();

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
                  _screenType ?? 'none',
                  style: TextStyle(fontSize: 28),
                )),
                ClassSlider(buttonCarouselController),
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
                        print(classCarousel(_currentIndex));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VoiceInput('')),
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
                            .document(index)
                            .collection('transaction')
                            .add({
                          'class': classCarousel(_currentIndex),
                          'cost': currentTransaction.cost ?? 0,
                          'createdOn': FieldValue.serverTimestamp(),
                          'name': currentTransaction.name,
                          'type':
                              currentTransaction.type.toLowerCase() ?? 'null'
                        });

                        CollectionReference wallet =
                            FirebaseFirestore.instance.collection('wallet');
                        wallet
                          ..doc(index)
                              .update({
                                'money': FieldValue.increment(
                                    currentTransaction.cost)
                              })
                              .then((value) => print("Wallet Updated"))
                              .catchError((error) =>
                                  print("Failed to update wallet: $error"));

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConfirmedMainPage(index)),
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
  final buttonCarouselController;
  ClassSlider(this.buttonCarouselController);
  @override
  _ClassSliderState createState() =>
      _ClassSliderState(buttonCarouselController);
}

class _ClassSliderState extends State<ClassSlider> {
  final buttonCarouselController;
  _ClassSliderState(this.buttonCarouselController);
  List cardList = [
    ClassItem('Food'),
    ClassItem('Daily use'),
    ClassItem('Household'),
    ClassItem('Travel'),
    ClassItem('Health'),
    ClassItem('Entertainment'),
    ClassItem('Housing'),
    ClassItem('Income'),
    ClassItem('Transfer')
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
      carouselController: buttonCarouselController,
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
          color: Colors.white,
        ),
        Container(
          margin: EdgeInsets.only(top: 14),
          child: Text(
            class_name,
            style: TextStyle(fontSize: 18),
          ),
        )
      ]),
    );
  }
}

class Transaction {
  var tokens;
  var textType;
  String type; // type of transaction eg. income expense transfer
  String _class; // class of transaction eg. health food
  String name; // name of transaction eg. ซื้อข้าวกระเพรา
  var cost; // cost of transaction
  String targetWallet; // target wallet to transfer money

  Transaction(this.tokens, this.textType);

  void setAllVariables() async {
    print('tokens = ');
    print(this.tokens);
    await this.deleteSpace();
    this.checkType();
    this.checkCost();
    this.checkName();
  }

  void deleteSpace() {
    for (var index = 0; index < this.tokens.length; index++) {
      if (this.textType[index] == 3) {
        this.tokens.removeAt(index);
        this.textType.removeAt(index);
      }
    }
    print(tokens);
  }

  void checkType() {
    var input = this.tokens[0];
    String _type;
    if (input == 'ได้เงิน') {
      _type = 'Income';
    } else if (input == 'ซื้อ') {
      _type = 'Expense';
    } else if (input == 'โอน') {
      _type = 'Transfer';
    } else {
      _type = 'none';
    }
    this.type = _type;
  }

  void checkCost() async {
    var array = this.tokens;
    var costLoc = -1;
    for (var loc = array.length - 1; loc >= 0; loc--) {
      print(array[loc]);
      if (this.textType[loc] == 2) {
        costLoc = loc;
        print('number found!');
        break;
      }
    }
    print(array[costLoc]);
    var localCost = array[costLoc].replaceAll(',', '');
    print(localCost);
    this.cost = double.parse(localCost);
    if (this.type == 'Expense') {
      this.cost = -this.cost;
    }
  }

  void checkName() {
    var array = this.tokens;
    if (this.type == 'expense') {
      array.removeAt(0);
    }
    print(array);
    for (var i = 0; i < 2; i++) {
      array.removeLast();
      print(array);
    }

    var name = StringBuffer();

    array.forEach((item) {
      name.write(item);
    });
    this.name = name.toString();
  }
}

bool _isNumeric(String str) {
  if (str == null) {
    return false;
  }
  return double.tryParse(str) != null;
}

classCarousel(_index) {
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
    case 7:
      {
        className = 'income';
      }
      break;
    case 8:
      {
        className = 'transfer';
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
