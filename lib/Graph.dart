import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

class Graph extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  int _selectedItemPosition = 0;

  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    return Stack(children: [
      Center(
        child: Container(
          width: _screenWidth * 0.85,
          height: _screenHeight * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.white,
          ),
        ),
      ),
      SnakeNavigationBar.color(
        height: 41,
        behaviour: SnakeBarBehaviour.floating,
        padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
        snakeViewColor: Color(0xff8C35B1),
        snakeShape: SnakeShape.rectangle,
        // showUnselectedLabels: false,
        // showSelectedLabels: true,
        // selectedLabelStyle: TextStyle(color: Color(0xff8C35B1), fontSize: 8),
        // selectedItemColor: Colors.white,
        // unselectedLabelStyle: TextStyle(color: Color(0xff8C35B1), fontSize: 14),
        // unselectedItemColor: Color(0xff8C35B1),
        currentIndex: _selectedItemPosition,
        onTap: (index) => setState(() => _selectedItemPosition = index),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        items: [
          BottomNavigationBarItem(
              icon: Text("Day",
                  style: TextStyle(
                      color: _selectedItemPosition == 0
                          ? Colors.white
                          : Color(0xff8C35B1)))),
          BottomNavigationBarItem(
            icon: Text("Month",
                style: TextStyle(
                    color: _selectedItemPosition == 1
                        ? Colors.white
                        : Color(0xff8C35B1))),
          ),
          BottomNavigationBarItem(
              icon: Text("Year",
                  style: TextStyle(
                      color: _selectedItemPosition == 2
                          ? Colors.white
                          : Color(0xff8C35B1)))),
        ],
      ),
    ]);
  }
}
