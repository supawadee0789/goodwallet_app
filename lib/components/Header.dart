import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 17, 22.5, 8),
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
              size: 28,
            ),
          ),
          SizedBox(
            width: 50,
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
                    size: 40,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                IconButton(
                  onPressed: () => {},
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 40,
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
