import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:goodwallet_app/components/Graph_day.dart';

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
          height: _screenHeight * 0.53,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.white,
          ),
          child: GraphDay(),
        ),
      ),
      SnakeNavigationBar.color(
        height: 30,
        behaviour: SnakeBarBehaviour.floating,
        padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
        snakeViewColor: Color(0xff8C35B1),
        snakeShape: SnakeShape.rectangle,
        currentIndex: _selectedItemPosition,
        onTap: (index) => setState(() => _selectedItemPosition = index),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        items: [
          BottomNavigationBarItem(
              icon: Text(
            "Day",
            style: TextStyle(
              color:
                  _selectedItemPosition == 0 ? Colors.white : Color(0xff8C35B1),
              fontSize: 16,
            ),
          )),
          BottomNavigationBarItem(
            icon: Text("Month",
                style: TextStyle(
                  color: _selectedItemPosition == 1
                      ? Colors.white
                      : Color(0xff8C35B1),
                  fontSize: 16,
                )),
          ),
          BottomNavigationBarItem(
              icon: Text("Year",
                  style: TextStyle(
                    color: _selectedItemPosition == 2
                        ? Colors.white
                        : Color(0xff8C35B1),
                    fontSize: 16,
                  ))),
        ],
      ),
    ]);
  }
}
