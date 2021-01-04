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

class IconTransition extends StatefulWidget {
  @override
  _IconTransitionState createState() => _IconTransitionState();
}

class _IconTransitionState extends State<IconTransition> {
  List<bool> isSelected = List.generate(3, (index) => false);
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      children: [
        IconList("Wallet", Icons.account_balance_wallet_outlined),
        IconList("Graph", Icons.leaderboard_outlined),
        IconList("Budget", Icons.monetization_on_outlined),
      ],
      onPressed: (int index) {
        setState(() {
          isSelected[index] = !isSelected[index];
        });
      },
      isSelected: isSelected,
    );
  }
}

//
// class IconTransition extends StatelessWidget {
//   List<Widget> _icon = [
//     IconList("Wallet", Icons.account_balance_wallet_outlined,
//         Icons.account_balance_wallet),
//     IconList("Graph", Icons.leaderboard_outlined, Icons.leaderboard),
//     IconList("Budget", Icons.monetization_on_outlined,
//         Icons.monetization_on_rounded),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.8,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: _icon,
//       ),
//     );
//   }
// }

class IconList extends StatelessWidget {
  final String _title;
  final _icon;
  IconList(this._title, this._icon);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 0.2),
            child: Text(
              this._title,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          Icon(
            this._icon,
            color: Colors.white,
            size: 26,
          ),
        ],
      ),
    );
  }
}

//
// class IconList extends StatefulWidget {
//   final String _title;
//   final _inactive;
//   final _active;
//   IconList(this._title, this._inactive, this._active);
//   @override
//   _IconListState createState() => _IconListState(_title, _inactive, _active);
// }
//
// class _IconListState extends State<IconList> {
//   final String _title;
//   final _inactive;
//   final _active;
//   _IconListState(this._title, this._inactive, this._active);
//   bool active = false;
//   bool inactive = true;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.only(bottom: 0.2),
//             child: Text(
//               this._title,
//               style: TextStyle(color: Colors.white, fontSize: 12),
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 active = true;
//               });
//             },
//             child: Icon(
//               active == true  ? _active : _inactive,
//               color: Colors.white,
//               size: 26,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
