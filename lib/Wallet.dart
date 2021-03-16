import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodwallet_app/AddWallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:goodwallet_app/components/Notification.dart';
import 'package:goodwallet_app/main.dart';
import 'package:intl/intl.dart';
import 'CreateWallet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'Voice_Input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> with TickerProviderStateMixin {
  String message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";

  AnimationController _controller;
  double openNav = 0.0;
  final _auth = FirebaseAuth.instance;
  var name;
  var email;
  var pic;
  bool _notification = false;

  @override
  void dispose() {
    super.dispose();
  }

  Future userHandler() async {
    try {
      name = await _auth.currentUser.displayName;
      email = await _auth.currentUser.email;
      pic = await _auth.currentUser.photoURL;
      print(pic);
    } catch (e) {
      print(e);
    }
  }

  checkNotificationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool notificationStatus = prefs.getBool('NotificationStatus');
    print(notificationStatus);
    if (notificationStatus == null) {
      _notification = false;
    } else {
      _notification = notificationStatus;
    }
  }

  sendNotification(id, hour, minute, second) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('10000',
        'FLUTTER_NOTIFICATION_CHANNEL', 'FLUTTER_NOTIFICATION_CHANNEL_DETAIL',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.showDailyAtTime(
        id,
        'Hello, spender.',
        'This is a your notifications. ',
        Time(hour, minute, second),
        platformChannelSpecifics,
        payload: 'I just haven\'t Met You Yet');
  }

  @override
  void initState() {
    print('-----');
    checkNotificationStatus();
    print('======');
    setState(() {
      _controller = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      );
    });
    super.initState();
    message = "No message.";
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOS = IOSInitializationSettings(
        // ignore: missing_return
        onDidReceiveLocalNotification: (id, title, body, payload) {
      print("onDidReceiveLocalNotification called.");
    });
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        // ignore: missing_return
        onSelectNotification: (payload) {
      // when user tap on notification.
      print("onSelectNotification called.");
      setState(() {
        message = payload;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
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
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(26.w, 17.h, 22.5.w, 60.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _controller.reverse();
                              openNav = 1.0;
                            });
                          },
                          child: Icon(Icons.account_circle_rounded,
                              color: Colors.white, size: 35.w),
                        ),
                        Text(
                          "WALLET",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25.sp,
                              letterSpacing: 0.66),
                        ),
                        SizedBox(
                          width: 30.w,
                        ),
                      ],
                    ),
                  ),
                  TotalCard(),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 30.h),
                      child: WalletList(this),
                      width: 0.83.sw,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AddWallet();
                      }));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 0.078.sh,
                      decoration: BoxDecoration(
                          color: Color(0xffE5A9B6),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(23.r),
                              topRight: Radius.circular(23.r))),
                      child: Center(
                        child: Text(
                          "Add new wallet",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                child: SlideTransition(
                  position:
                      Tween<Offset>(begin: Offset(0, 0), end: Offset(-1.5, 0))
                          .animate(CurvedAnimation(
                    parent: _controller,
                    curve: Curves.easeIn,
                  )),
                  child: IgnorePointer(
                    ignoring: openNav == 0 ? true : false,
                    child: AnimatedOpacity(
                      opacity: openNav,
                      duration: Duration(milliseconds: 400),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _controller.forward();
                            openNav = 0.0;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                              0.05.sw, 0.05.sh, 0.02.sw, 0.05.sh),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30.r)),
                            color: Colors.white,
                          ),
                          height: screenHeight,
                          width: 0.6.sw,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder(
                                    future: userHandler(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          pic != null
                                              ? CircleAvatar(
                                                  backgroundImage:
                                                      NetworkImage(pic),
                                                )
                                              : SvgPicture.asset(
                                                  'images/account.svg',
                                                  width: 35.w,
                                                  color: Color(0xffC88EC5),
                                                ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 8.h),
                                            child: Text(
                                              name == null ? 'Guest' : name,
                                              style: TextStyle(
                                                  color: Color(0xff706D6D),
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(
                                            email == null
                                                ? 'guest@mail.com'
                                                : email,
                                            style: TextStyle(
                                                color: Color(0xffA1A1A1),
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w100),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  SizedBox(height: 0.1.sh),
                                  Text(
                                    'Other',
                                    style: TextStyle(
                                        color: Color(0xff706D6D),
                                        fontSize: 14.sp),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.notifications_active_rounded,
                                      color: Color(0xffC88EC5),
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Notification',
                                          style: TextStyle(
                                              color: Color(0xffA1A1A1),
                                              fontSize: 11.sp),
                                        ),
                                        CupertinoSwitch(
                                          value: _notification ?? false,
                                          onChanged: (bool value) async {
                                            final SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            setState(() {
                                              _notification = value;
                                              prefs.setBool(
                                                  'NotificationStatus', value);
                                            });
                                            if (_notification) {
                                              sendNotification(0, 12, 42, 0);
                                              sendNotification(1, 12, 44, 0);
                                              sendNotification(2, 12, 46, 0);

                                              // sendNotification();
                                              print("Turned on notification");
                                            } else {
                                              flutterLocalNotificationsPlugin
                                                  .cancelAll();
                                              print(
                                                  "All notifications are canceled");
                                            }
                                          },
                                          activeColor: Color(0xffEA8D8D),
                                        )
                                      ],
                                    ),
                                    horizontalTitleGap: 0.5.w,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 0),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  ListTile(
                                    onTap: () async {
                                      final SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setStringList('user', null);
                                      prefs.setString('token', null);
                                      try {
                                        await _auth.signOut();
                                      } catch (e) {
                                        print(e);
                                      }
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return MyApp();
                                      }));
                                    },
                                    leading: Icon(
                                      Icons.logout,
                                      color: Color(0xffC88EC5),
                                    ),
                                    title: Text(
                                      'Log out',
                                      style: TextStyle(
                                          color: Color(0xff706D6D),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    horizontalTitleGap: 0.5.w,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 0),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TotalCard extends StatelessWidget {
  @override
  // string format for money (comma)
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  final _auth = FirebaseAuth.instance;
  double money = 0;
  getTotal() {
    return fetchTotal().then((value) {
      money = value;
      return value;
    }).catchError((error) => throw (error));
  }

  Future<double> fetchTotal() async {
    double money = 0;
    final uid = _auth.currentUser.uid;
    await for (var snapshot in FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('wallet')
        .snapshots()) {
      for (var wallet in snapshot.docs) {
        final cost = wallet.get('money');
        money = money + cost;
      }
      return money;
    }
  }

  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: 314.w,
      height: 147.h,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(34.r)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: Text(
              "TOTAL",
              style: TextStyle(
                  color: Color(0xffA1A1A1),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
          FutureBuilder(
            future: getTotal(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                getTotal();
                return Text('0');
              } else {
                return Container(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 300.0.w,
                      maxHeight: 54.h,
                    ),
                    child: AutoSizeText(
                      money.toStringAsFixed(2).replaceAllMapped(reg, mathFunc),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 41.0.sp,
                          color: Color(0xffA890FE),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }
            },
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 7.h),
            child: Text(
              "BAHT",
              style: TextStyle(
                  color: Color(0xffA890FE),
                  fontSize: 14.sp,
                  letterSpacing: 0.42,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class WalletList extends StatelessWidget {
  _WalletState parent;
  WalletList(this.parent);
  @override
  // string format for money (comma)
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final uid = _auth.currentUser.uid;
    dynamic firebaseInstance = FirebaseInstance(uid);
    firebaseInstance.fetchWallet();
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: firebaseInstance.wallets.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return ListView.builder(
            // ignore: deprecated_member_use
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              // ignore: deprecated_member_use
              DocumentSnapshot wallet = snapshot.data.docs[index];
              return Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: GestureDetector(
                  onTap: () {
                    firebaseInstance.walletIndex = index;
                    firebaseInstance.walletID = wallet.id;
                    Navigator.of(context).push(PageTransition(
                        type: PageTransitionType.fadeIn,
                        duration: Duration(milliseconds: 100),
                        child: new CreateWallet(firebaseInstance)));
                  },
                  child: Container(
                    height: 0.096.sh,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 7.h),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            wallet['name'],
                            style: TextStyle(
                                color: Color(0xffA1A1A1),
                                fontSize: 20.sp,
                                decoration: TextDecoration.none,
                                fontFamily: 'Knit'),
                          ),
                          Text(
                            wallet['money']
                                .toStringAsFixed(2)
                                .replaceAllMapped(reg, mathFunc),
                            style: TextStyle(
                                color: Color(0xffA890FE),
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none),
                          )
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(34.r),
                      color: Colors.white,
                    ),
                  ),
                ),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Delete',
                    icon: Icons.delete,
                    foregroundColor: Colors.white,
                    color: Color(0x00000000),
                    onTap: () async {
                      await wallet.reference.delete();
                      parent.setState(() {});
                      // Navigator.pop(context);
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return new Wallet();
                      // }));
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class FirebaseInstance {
  var uid;
  var wallets;

  FirebaseInstance(this.uid);

  // WalletInstance(this.wallets);
  var walletIndex;
  var walletID;

  void fetchWallet() {
    this.wallets = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('wallet')
        .orderBy('createdOn', descending: false);
  }
}
