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
import 'CreateWallet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'Voice_Input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> with TickerProviderStateMixin {
  AnimationController _controller;
  double openNav = 0.0;
  final _auth = FirebaseAuth.instance;
  var name;
  var email;
  var pic;
  bool _notification = false;
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

  @override
  void initState() {
    setState(() {
      _controller = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      );
    });
    // TODO: implement initState
    super.initState();
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
                    padding: EdgeInsets.fromLTRB(
                        26 / 360 * screenWidth,
                        17 / 760 * screenHeight,
                        22.5 / 360 * screenWidth,
                        60 / 760 * screenHeight),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _controller.reverse();
                              openNav = 1.0;
                            });
                          },
                          icon: Icon(
                            Icons.account_circle_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        Text(
                          "WALLET",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              letterSpacing: 0.66),
                        ),
                        SizedBox(
                          width: 30 / 360 * screenWidth,
                        ),
                      ],
                    ),
                  ),
                  TotalCard(),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 30),
                      child: WalletList(this),
                      width: MediaQuery.of(context).size.width * 0.83,
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
                      height: MediaQuery.of(context).size.height * 0.078,
                      decoration: BoxDecoration(
                          color: Color(0xffE5A9B6),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(23),
                              topRight: Radius.circular(23))),
                      child: Center(
                        child: Text(
                          "Add new wallet",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
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
                              screenHeight * 0.05,
                              screenHeight * 0.05,
                              screenWidth * 0.02,
                              screenHeight * 0.05),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30)),
                            color: Colors.white,
                          ),
                          height: screenHeight,
                          width: screenWidth * 0.6,
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
                                                  width: 35,
                                                  color: Color(0xffC88EC5),
                                                ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: Text(
                                              name == null ? 'Guest' : name,
                                              style: TextStyle(
                                                  color: Color(0xff706D6D),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(
                                            email == null
                                                ? 'guest@mail.com'
                                                : email,
                                            style: TextStyle(
                                                color: Color(0xffA1A1A1),
                                                fontSize: 11,
                                                fontWeight: FontWeight.w100),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  SizedBox(height: screenHeight * 0.1),
                                  Text(
                                    'Other',
                                    style: TextStyle(
                                        color: Color(0xff706D6D), fontSize: 14),
                                  ),
                                  ListTile(
                                    onTap: () {},
                                    leading: Icon(
                                      Icons.receipt_long,
                                      color: Color(0xffC88EC5),
                                    ),
                                    title: Text(
                                      'Monthly Transactions',
                                      style: TextStyle(
                                          color: Color(0xffA1A1A1),
                                          fontSize: 11),
                                    ),
                                    horizontalTitleGap: 0.5,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 0),
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
                                              fontSize: 11),
                                        ),
                                        CupertinoSwitch(
                                          value: _notification,
                                          onChanged: (bool value) {
                                            setState(() {
                                              _notification = value;
                                            });
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return notifyPage();
                                            }));
                                          },
                                          activeColor: Color(0xffEA8D8D),
                                        )
                                      ],
                                    ),
                                    horizontalTitleGap: 0.5,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 0),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  ListTile(
                                    onTap: () {},
                                    leading: Icon(
                                      Icons.settings,
                                      color: Color(0xffC88EC5),
                                    ),
                                    title: Text(
                                      'Setting',
                                      style: TextStyle(
                                          color: Color(0xff706D6D),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    horizontalTitleGap: 0.5,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 0),
                                  ),
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
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    horizontalTitleGap: 0.5,
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
    await for (var snapshot in Firestore.instance
        .collection('users')
        .doc(uid)
        .collection('wallet')
        .snapshots()) {
      for (var wallet in snapshot.documents) {
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
      width: 314 / 360 * screenWidth,
      height: 147 / 760 * screenHeight,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(34)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15 / 760 * screenHeight),
            child: Text(
              "TOTAL",
              style: TextStyle(
                  color: Color(0xffA1A1A1),
                  fontSize: 20,
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
                      maxWidth: 300.0,
                      maxHeight: 54 / 760 * screenHeight,
                    ),
                    child: AutoSizeText(
                      money.toStringAsFixed(2).replaceAllMapped(reg, mathFunc),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 41.0,
                          color: Color(0xffA890FE),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }
            },
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 7 / 760 * screenHeight),
            child: Text(
              "BAHT",
              style: TextStyle(
                  color: Color(0xffA890FE),
                  fontSize: 14,
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
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              // ignore: deprecated_member_use
              DocumentSnapshot wallet = snapshot.data.documents[index];
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
                    height: MediaQuery.of(context).size.height * 0.096,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 7),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            wallet['name'],
                            style: TextStyle(
                                color: Color(0xffA1A1A1),
                                fontSize: 20,
                                decoration: TextDecoration.none,
                                fontFamily: 'Knit'),
                          ),
                          Text(
                            wallet['money']
                                .toStringAsFixed(2)
                                .replaceAllMapped(reg, mathFunc),
                            style: TextStyle(
                                color: Color(0xffA890FE),
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none),
                          )
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(34),
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
