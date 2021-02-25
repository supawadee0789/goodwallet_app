import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';

class BudgetComponent extends StatefulWidget {
  @override
  _BudgetComponentState createState() => _BudgetComponentState();
}

class _BudgetComponentState extends State<BudgetComponent> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
      },
      child: AnimatedContainer(
        margin: EdgeInsets.symmetric(vertical: 6),
        height: selected ? (_screenHeight * 0.40) : (_screenHeight * 0.15),
        duration: Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 13.0, horizontal: 23.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Name Budget",
                          style: TextStyle(
                              color: Color(0xffEA8D8D),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              height: 1.0),
                        ),
                        SizedBox(width: 5),
                        Row(
                          children: classIcon,
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "660 Bath",
                          style: TextStyle(
                              color: Color(0xff379243),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "left",
                          style: TextStyle(
                              color: Color(0xffA1A1A1),
                              fontSize: 12,
                              fontWeight: FontWeight.w100),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 15),
                LinearPercentIndicator(
                    width: _screenWidth * 0.72, //width for progress bar
                    animation: true, //animation to show progress at first
                    animationDuration: 1000,
                    lineHeight: 30.0, //height of progress bar

                    percent: 0.1, // 30/100 = 0.3
                    center: Text("30.0%",
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                    linearStrokeCap: LinearStrokeCap
                        .roundAll, //make round cap at start and end both
                    progressColor:
                        Colors.red[300], //percentage progress bar color
                    backgroundColor: Color.fromARGB(
                        60, 161, 161, 161) //background progressbar color
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<Widget> classIcon = [
  svgHandle('Entertainment'),
  svgHandle('Entertainment'),
];

Widget svgHandle(type) {
  return Container(
    width: 25,
    child: SvgPicture.asset(
      './images/$type.svg',
      width: 15,
      color: Color(0xffEA8D8D),
    ),
  );
}
