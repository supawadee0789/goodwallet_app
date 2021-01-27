import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as Http;
import 'dart:convert' as utf8;
import 'package:carousel_slider/carousel_slider.dart';
import 'components/WalletSlider.dart';
import "dart:async";

import 'package:goodwallet_app/ConfirmedPage.dart';
import 'package:goodwallet_app/Voice_Input.dart';
import 'components/Header.dart';

class ConfirmationMainPage extends StatelessWidget {
  final String text;
  final index;
  final firebaseInstance;
  ConfirmationMainPage(
      {Key key, @required this.text, this.index, this.firebaseInstance})
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
        child: SafeArea(
            child: ConfirmationPage(
          resultText: text,
          index: index,
          firebaseInstance: firebaseInstance,
        )),
      ),
    );
  }
}

class ConfirmationPage extends StatefulWidget {
  final String resultText;
  final index;
  final firebaseInstance;
  ConfirmationPage(
      {Key key, @required this.resultText, this.index, this.firebaseInstance})
      : super(key: key);

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState(
      resultText: resultText, index: index, firebaseInstance: firebaseInstance);
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  final String resultText;
  final index;
  final firebaseInstance;
  String _screenType = '';
  var carouselAbsorb = false;
  var iconOpacity = 1.0;
  _ConfirmationPageState(
      {Key key, @required this.resultText, this.index, this.firebaseInstance});

  // ignore: deprecated_member_use
  final _fireStore = Firestore.instance;
  var currentTransaction;
  @override
  void initState() {
    super.initState();
    WordSegmentation(resultText);
    _currentIndex = 0;
    // print(currentTransaction.tokens);
    print(index);
  }

  // ignore: non_constant_identifier_names
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
          carouselAbsorb = true;
          iconOpacity = 0;

          buttonCarouselController.animateToPage(7,
              duration: Duration(milliseconds: 300), curve: Curves.linear);
        } else if (_screenType == 'Transfer') {
          carouselAbsorb = true;
          iconOpacity = 0;
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
            child: WalletSlider(firebaseInstance),
          ),
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
            child: AbsorbPointer(
              absorbing: carouselAbsorb,
              child: Column(
                children: [
                  Container(
                      child: Text(
                    _screenType ?? 'none',
                    style: TextStyle(fontSize: 28),
                  )),
                  Container(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      child: Stack(
                    children: [
                      ClassSlider(buttonCarouselController, _screenType),
                      Positioned(
                          left: 5,
                          top: 45,
                          child: Opacity(
                            opacity: iconOpacity,
                            child: Icon(
                              Icons.keyboard_arrow_left_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          )),
                      Positioned(
                          right: 5,
                          top: 45,
                          child: Opacity(
                            opacity: iconOpacity,
                            child: Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          )),
                    ],
                  ))
                ],
              ),
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
            height: 43,
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
                        Navigator.pop(context); // cancel confirmation
                      },
                      child: SvgPicture.asset(
                        'images/cross-mark-on-a-black-circle-background.svg', // cancel svg
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
                            // ignore: deprecated_member_use
                            .document(firebaseInstance.walletID.toString())
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
                            .doc(firebaseInstance.walletID.toString())
                            .update({
                              'money':
                                  FieldValue.increment(currentTransaction.cost)
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
                        'images/check-mark.svg', // confirm svg
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
  final _screenType;
  ClassSlider(this.buttonCarouselController, this._screenType);
  @override
  _ClassSliderState createState() =>
      _ClassSliderState(buttonCarouselController, _screenType);
}

class _ClassSliderState extends State<ClassSlider> {
  final buttonCarouselController;
  final _screenType;
  _ClassSliderState(this.buttonCarouselController, this._screenType);
  List cardList = [
    ClassItem('Food'),
    ClassItem('Shopping'),
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
            class_name == 'Income'
                ? ''
                : class_name == 'Transfer'
                    ? ''
                    : class_name,
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
    var input = this.tokens;
    String _type;
    var income = ['ได้เงิน', 'ได้'];
    var expense = ['ซื้อ', 'จ่าย'];
    var transfer = ['โอน'];

    if (income.any((e) => input.contains(e))) {
      _type = 'Income';
    } else if (expense.any((e) => input.contains(e))) {
      _type = 'Expense';
    } else if (transfer.any((e) => input.contains(e))) {
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
    if (this.type == 'Expense') {
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
    print(this.name);
    print(this.type);
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
        className = 'shopping';
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
