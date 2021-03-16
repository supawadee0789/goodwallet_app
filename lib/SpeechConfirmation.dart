import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:goodwallet_app/ConfirmedPage.dart';
import 'package:goodwallet_app/Voice_Input.dart';
import 'components/Header.dart';
import 'components/walletSelector.dart';
import 'package:goodwallet_app/classes/classes.dart';

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
  var transferOpacity = 0.0;
  _ConfirmationPageState(
      {Key key, @required this.resultText, this.index, this.firebaseInstance});

  // ignore: deprecated_member_use
  final _fireStore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser.uid;
  var currentTransaction;
  var manualType;
  @override
  void initState() {
    super.initState();
    WordSegmentation(resultText);
    _currentIndex = 0;
    // print(currentTransaction.tokens);
    print(index);
    currentTransaction = new Transactions();
    _fireStore
        .collection('users')
        .doc(uid)
        .collection('wallet').where('name',)
  }

  // ignore: non_constant_identifier_names
  Future WordSegmentation(_text) async {
    // "https://api.aiforthai.in.th/lextoplus?text=" + _text
    var url = Uri.parse("https://api.aiforthai.in.th/lextoplus?text=" + _text);
    await Http.get(url, headers: {"Apikey": "elHOb4Ksl715HkIu6Leq5ZdcnYX39SPP"})
        .then((response) async {
      print("Response status: ${response.body}");
      var parsedJson = utf8.jsonDecode(response.body);
      print(parsedJson);
      currentTransaction.setTokens(parsedJson['tokens'], parsedJson['types']);
      // currentTransaction =
      //     new Transaction(parsedJson['tokens'], parsedJson['types']);
      print(currentTransaction.tokens);
      await currentTransaction.setAllVariables(manualType);
      setState(() {
        if (manualType != null) {
          currentTransaction.type = manualType;
        } else {
          _screenType = currentTransaction.type;
        }

        if (_screenType == 'Income') {
          carouselAbsorb = true;
          iconOpacity = 0;
          buttonCarouselController.animateToPage(7,
              duration: Duration(milliseconds: 300), curve: Curves.linear);
        } else if (_screenType == 'Transfer') {
          carouselAbsorb = true;
          iconOpacity = 0;
          transferOpacity = 1;
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
          SizedBox(height: 10.h, width: _screenWidth),
          Container(
            child: WalletSlider(firebaseInstance),
          ),
          Container(
            height: 217.h,
            width: 211.h,
            decoration: BoxDecoration(
              color: Color(0xff9967B2),
              borderRadius: BorderRadius.all(Radius.circular(21.0.r)),
            ),
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: 8.0.h, left: 8.0.w, right: 8.0.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff6A2388),
                      borderRadius: BorderRadius.all(Radius.circular(15.0.r)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _screenType = 'Expense';
                                manualType = 'Expense';

                                print(manualType);

                                carouselAbsorb = false;
                                iconOpacity = 1;
                                transferOpacity = 0;
                                buttonCarouselController.animateToPage(0,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.linear);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0.r)),
                                  color: _screenType == 'Expense'
                                      ? Colors.white
                                      : Color(0)),
                              child: Text(
                                'Expense',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    color: _screenType == 'Expense'
                                        ? Color(0xff6A2388)
                                        : Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _screenType = 'Income';
                                manualType = 'Income';
                                print(manualType);
                                carouselAbsorb = true;
                                iconOpacity = 0;
                                transferOpacity = 0;
                                buttonCarouselController.animateToPage(7,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.linear);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0.r)),
                                  color: _screenType == 'Income'
                                      ? Colors.white
                                      : Color(0)),
                              child: Text(
                                'Income',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    color: _screenType == 'Income'
                                        ? Color(0xff6A2388)
                                        : Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _screenType = 'Transfer';
                                manualType = 'Transfer';
                                print(manualType);
                                carouselAbsorb = true;
                                iconOpacity = 0;
                                transferOpacity = 1;
                                buttonCarouselController.animateToPage(8,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.linear);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0.r)),
                                  color: _screenType == 'Transfer'
                                      ? Colors.white
                                      : Color(0)),
                              child: Text(
                                'Transfer',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    color: _screenType == 'Transfer'
                                        ? Color(0xff6A2388)
                                        : Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    child: Stack(
                  children: [
                    AbsorbPointer(
                        absorbing: carouselAbsorb,
                        child:
                            ClassSlider(buttonCarouselController, _screenType)),
                    Positioned(
                        left: 5.w,
                        top: 45.h,
                        child: Opacity(
                          opacity: iconOpacity,
                          child: Icon(
                            Icons.keyboard_arrow_left_rounded,
                            color: Colors.white,
                            size: 40.w,
                          ),
                        )),
                    Positioned(
                        right: 5.w,
                        top: 45.h,
                        child: Opacity(
                          opacity: iconOpacity,
                          child: Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: Colors.white,
                            size: 40.w,
                          ),
                        )),
                    Positioned(
                        left: 25,
                        bottom: 5,
                        child: Opacity(
                          opacity: transferOpacity,
                          child: Row(
                            children: [
                              Text('To : '),
                              WalletSelector(currentTransaction)
                            ],
                          ),
                        ))
                  ],
                ))
              ],
            ),
          ),
          SizedBox(
            height: 53.h,
          ),
          Container(
            width: 0.8.sw,
            child: Text(
              resultText ?? 'waiting for text',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28.sp),
            ),
          ),
          SizedBox(
            height: 43.h,
          ),
          Container(
            width: 0.7.sw,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Listener(
                      onPointerDown: (detail) {
                        print('cancel');
                        print(currentTransaction.targetWallet);
                        print(classCarousel(_currentIndex));
                        Navigator.pop(context); // cancel confirmation
                      },
                      child: SvgPicture.asset(
                        'images/cross-mark-on-a-black-circle-background.svg', // cancel svg
                        height: 85.0.h,
                        width: 85.0.h,
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
                        // await WordSegmentation(resultText);
                        print('confirm');
                        print(_screenType);
                        print(currentTransaction.type);
                        // print(checkName(tokens, checkCost(tokens)));
                        // print(checkCost(tokens));
                        var cost = currentTransaction.cost;
                        var type = currentTransaction.type;
                        if (manualType != null) {
                          if (manualType == 'Expense' ||
                              manualType == 'Transfer') {
                            if (cost > 0) {
                              cost = -cost;
                            }
                          } else {
                            if (cost < 0) {
                              cost = -cost;
                            }
                          }
                          type = manualType;
                        }
                        _fireStore
                            .collection('users')
                            .doc(uid)
                            .collection('wallet')
                            // ignore: deprecated_member_use
                            .doc(firebaseInstance.walletID.toString())
                            .collection('transaction')
                            .add({
                          'class': classCarousel(_currentIndex),
                          'cost': cost ?? 0,
                          'createdOn': FieldValue.serverTimestamp(),
                          'name': currentTransaction.name,
                          'type': type.toLowerCase() ?? 'null'
                        });
                        //transfer target

                        if (type.toLowerCase() == 'transfer') {
                          _fireStore
                              .collection('users')
                              .doc(uid)
                              .collection('wallet')
                              // ignore: deprecated_member_use
                              .doc(currentTransaction.targetWalletID.toString())
                              .collection('transaction')
                              .add({
                            'class': classCarousel(_currentIndex),
                            'cost': -currentTransaction.cost ?? 0,
                            'createdOn': FieldValue.serverTimestamp(),
                            'name': currentTransaction.name,
                            'type': 'transfer'
                          });

                          CollectionReference wallet = FirebaseFirestore
                              .instance
                              .collection('users')
                              .doc(uid)
                              .collection('wallet');
                          wallet
                              .doc(currentTransaction.targetWalletID.toString())
                              .update({
                                'money': FieldValue.increment(
                                    -currentTransaction.cost)
                              })
                              .then((value) => print("Wallet Updated"))
                              .catchError((error) =>
                                  print("Failed to update wallet: $error"));
                        }

                        CollectionReference wallet = FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('wallet');
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
                        height: 85.0.h,
                        width: 85.0.h,
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
    ClassItem('Residence'),
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
        height: 160.0.h,
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
            height: 0.30.sh,
            width: 1.sw,
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
      margin: EdgeInsets.only(top: 26.h),
      child: Column(children: [
        SvgPicture.asset(
          'images/' + class_name + '.svg',
          height: 71.0.h,
          width: 85.0.w,
          color: Colors.white,
        ),
        Container(
          margin: EdgeInsets.only(top: 14.h),
          child: Text(
            class_name == 'Income'
                ? ''
                : class_name == 'Transfer'
                    ? ''
                    : class_name,
            style: TextStyle(fontSize: 18.sp),
          ),
        )
      ]),
    );
  }
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
        className = 'residence';
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
