import 'package:flutter/material.dart';

class GraphDay extends StatefulWidget {
  @override
  _GraphDayState createState() => _GraphDayState();
}

class _GraphDayState extends State<GraphDay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 70,
          left: 13,
          child: Text(
            "Payment \nChart",
            style: TextStyle(
                color: Color(0xff706D6D),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.2),
          ),
        ),
        Positioned(
          top: 65,
          right: 19,
          child: Column(
            children: [
              Card("Income", 2000),
              SizedBox(height: 10),
              Card("Expense", -500),
              SizedBox(height: 10),
              Text(
                "Change : Na/Na",
                style: TextStyle(color: Color(0xffA1A1A1), fontSize: 11),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class Card extends StatelessWidget {
  final String title;
  final double money;
  Card(this.title, this.money);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      height: 48,
      width: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            spreadRadius: 1.0,
            blurRadius: 3.5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
                color:
                    title == 'Income' ? Color(0xff3FD371) : Color(0xffCB3F3F),
                fontSize: 11),
          ),
          Text(
            money.toString(),
            style: TextStyle(
                color:
                    title == 'Income' ? Color(0xff3FD371) : Color(0xffCB3F3F),
                fontSize: 11),
          )
        ],
      ),
    );
  }
}
