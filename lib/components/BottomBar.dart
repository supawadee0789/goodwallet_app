import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Voice_Input.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

class BottomBar extends StatelessWidget {
  final index;
  final firebaseInstance;
  BottomBar(this.index, this.firebaseInstance);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.078,
              decoration: BoxDecoration(
                  color: Color(0xffE5A9B6),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23))),
            ),
          ),
          Positioned(
            top: 0,
            right: 21,
            height: MediaQuery.of(context).size.height * 0.079,
            width: MediaQuery.of(context).size.height * 0.079,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(PageTransition(
                    type: PageTransitionType.fadeIn,
                    child: VoiceInput(index, firebaseInstance)));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 6,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  'images/VoiceIcon.svg',
                  color: Color(0xffDB8EA7),
                  alignment: Alignment.center,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height * 0.079) * 0.2,
            // left: (MediaQuery.of(context).size.width * 0.079) * 2,
            child: IconTransition(),
          )
        ],
      ),
    );
  }
}

class IconTransition extends StatelessWidget {
  List<Widget> _icon = [
    IconList("Wallet", Icons.account_balance_wallet_outlined,
        Icons.account_balance_wallet),
    IconList("Graph", Icons.leaderboard_outlined, Icons.leaderboard),
    IconList("Budget", Icons.monetization_on_outlined,
        Icons.monetization_on_rounded),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _icon,
      ),
    );
  }
}

class IconList extends StatefulWidget {
  final activeIcon;
  final inactiveIcon;
  final title;
  IconList(this.title, this.inactiveIcon, this.activeIcon);
  @override
  _IconListState createState() =>
      _IconListState(title, inactiveIcon, activeIcon);
}

class _IconListState extends State<IconList> {
  final activeIcon;
  final inactiveIcon;
  final title;
  _IconListState(this.title, this.inactiveIcon, this.activeIcon);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 0.2),
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          GestureDetector(
            onTap: () {
              print(title + ' pressed!');
            },
            child: Icon(
              activeIcon,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}
