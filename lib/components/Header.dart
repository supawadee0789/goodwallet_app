import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          12 / 360 * screenWidth,
          17 / 760 * screenHeight,
          22.5 / 360 * screenWidth,
          8 / 760 * screenHeight),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: 28 / (360 * 760) * (screenHeight * screenWidth),
            ),
          ),
          SizedBox(
            width: 50 / 360 * screenWidth,
          ),
          Text(
            "WALLET",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 25, letterSpacing: 0.66),
          ),
          Container(
            child: Row(
              children: [
                IconButton(
                  onPressed: () => {},
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 40 / (360 * 760) * (screenHeight * screenWidth),
                  ),
                ),
                // SizedBox(
                //   width: 15 / 360 * screenWidth,
                // ),
                IconButton(
                  onPressed: () => {},
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 40 / (360 * 760) * (screenHeight * screenWidth),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
