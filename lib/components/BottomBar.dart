import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Voice_Input.dart';

class BottomBar extends StatelessWidget {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VoiceInputMainPage()),
                );
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
//
// class IconTransition extends StatefulWidget {
//   @override
//   _IconTransitionState createState() => _IconTransitionState();
// }
//
// class _IconTransitionState extends State<IconTransition> {
//   List<bool> isSelected = List.generate(3, (index) => false);
//   @override
//   Widget build(BuildContext context) {
//     return ToggleButtons(
//       constraints: ,
//       renderBorder: false,
//       color: Colors.white60,
//       selectedColor: Colors.white,
//       disabledColor: null,
//       fillColor: Color(0000),
//       splashColor: Color(0000),
//       children: [
//         Icon(Icons.account_balance_wallet),
//         Icon(Icons.leaderboard),
//         Icon(Icons.monetization_on),
//       ],
//       onPressed: (int index) {
//         setState(() {
//           for (int buttonIndex = 0;
//               buttonIndex < isSelected.length;
//               buttonIndex++) {
//             if (buttonIndex == index) {
//               isSelected[buttonIndex] = true;
//             } else {
//               isSelected[buttonIndex] = false;
//             }
//           }
//         });
//       },
//       isSelected: isSelected,
//     );
//   }
// }

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
// IconList("Wallet", Icons.account_balance_wallet_outlined,
// Icons.account_balance_wallet),
// IconList("Graph", Icons.leaderboard_outlined, Icons.leaderboard),
// IconList("Budget", Icons.monetization_on_outlined,
// Icons.monetization_on_rounded),

class IconList extends StatefulWidget {
  @override
  _IconListState createState() => _IconListState();
}

class _IconListState extends State<IconList> {
  List<Map<String, Icon>> _icon = [
    {'Wallet': Icon(Icons.account_balance_wallet_outlined)},
    {'Graph': Icon(Icons.leaderboard_outlined)},
    {'Budget': Icon(Icons.monetization_on_outlined)},
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 0.2),
            child: Text(
              _icon[0].keys,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                active = true;
              });
            },
            child: Icon(
              active == true ? _active : _inactive,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}
