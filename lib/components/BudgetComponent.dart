import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodwallet_app/Graph.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:goodwallet_app/classes/SearchClassForBudget.dart';

class BudgetComponent extends StatefulWidget {
  final budget;
  final firebaseInstance;

  BudgetComponent(
    this.budget,
    this.firebaseInstance,
  );
  @override
  _BudgetComponentState createState() =>
      _BudgetComponentState(budget, firebaseInstance);
}

class _BudgetComponentState extends State<BudgetComponent> {
  final budget;
  final firebaseInstance;
  _BudgetComponentState(this.budget, this.firebaseInstance);
  bool selected = false;
  List<Color> graphColor = [
    Color(0xffB32C05),
    Color(0xffB049B0),
    Color(0xffFF8B6A),
    Color(0xff4EBD82),
    Color(0xffDEF766),
    Color(0xff708700),
    Color(0xff5B005B)
  ];

  calPie(Map exp, expClass) {
    Map<String, double> trans = {};
    double total = 0;
    exp.forEach((key, value) {
      total += value;
    });
    if (exp[expClass] != null) {
      trans['pie'] = (exp[expClass] * (-1) * 100) / total;
      trans['total'] = total;
      return trans;
    } else {
      trans.addAll({'pie': 0.0, 'total': 0});
    }

    return trans;
  }

  List<Widget> classIcon = [];
  var exp = {};
  @override
  void initState() {
    // TODO: implement initState

    sumExpClass(firebaseInstance, budget).then((value) {
      exp = value;
    });
    for (var element in budget['BudgetClass']) {
      var str = element[0].toUpperCase() + element.substring(1).toLowerCase();
      classIcon.add(svgHandle(str));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    double total = 0;

    List<Widget> indicatorList = [];
    List<PieChartSectionData> sectionPie = [];

    var i = 0;
    for (var element in budget['BudgetClass']) {
      var str = element[0].toUpperCase() + element.substring(1).toLowerCase();
      var cal = calPie(exp, element);
      double pie = cal['pie'];
      total = cal['total'];
      indicatorList.add(indicator(
          str, graphColor[i], pie.toStringAsFixed(1) + '%', exp[element]));
      sectionPie.add(PieChartSectionData(
          value: pie, color: graphColor[i], radius: 50, showTitle: false));
      i++;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
      },
      child: AnimatedContainer(
        margin: EdgeInsets.symmetric(vertical: 6),
        height: selected
            ? (_screenHeight *
                (budget['BudgetClass'].length >= 5 ? 0.55 : 0.42))
            : (_screenHeight * 0.18),
        duration: Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 13.0, horizontal: 23.0),
          child: Stack(children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        budget['BudgetName'],
                        style: TextStyle(
                            color: Color(0xffEA8D8D),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            height: 1.0),
                      ),
                      Row(
                        children: [
                          Text(
                            (budget['Amount'] + total).toStringAsFixed(2),
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
                  SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: classIcon,
                        mainAxisAlignment: MainAxisAlignment.start,
                      ),
                      Text(
                        budget['Recurrence'],
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.purple.shade200,
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                  SizedBox(height: 7),
                  LinearPercentIndicator(
                      width: _screenWidth * 0.72, //width for progress bar
                      animation: true, //animation to show progress at first
                      animationDuration: 1000,
                      lineHeight: 30.0, //height of progress bar

                      percent:
                          ((((-1) * total * 100) / budget['Amount']) / 100) >= 1
                              ? 1.0
                              : ((((-1) * total * 100) / budget['Amount']) /
                                  100), // 30/100 = 0.3
                      center: Text(
                          (((-1) * total * 100) / budget['Amount'])
                                  .toStringAsFixed(2) +
                              '%',
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
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedOpacity(
                opacity: selected ? 1 : 0,
                duration: Duration(milliseconds: 100),
                curve: Curves.easeIn,
                child: OverflowBox(
                  minWidth: 0.0,
                  maxWidth: 300.0,
                  minHeight: 0.0,
                  maxHeight: _screenHeight * 0.55,
                  child: Column(
                    children: [
                      SizedBox(height: _screenHeight * 0.182),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: _screenHeight * 0.2,
                              width: _screenHeight * 0.2,
                              margin: EdgeInsets.symmetric(
                                  vertical: _screenHeight * 0.05,
                                  horizontal: 10),
                              child: PieChart(
                                PieChartData(
                                  sections: sectionPie,
                                  borderData: FlBorderData(show: false),
                                ),
                                swapAnimationDuration:
                                    Duration(milliseconds: 300),
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Budget  ' +
                                        budget['Amount'].toString() +
                                        ' THB',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xffA1A1A1),
                                        height: 1.0),
                                  ),
                                  Text(
                                    'Spent  ' + total.toString() + 'THB',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xffE80404),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.005),
                                  Column(
                                    children: indicatorList,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

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

Widget indicator(title, color, percentage, amount) {
  return Container(
    width: 90,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              height: 10,
              width: 10,
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(fontSize: 11, color: Color(0xff706D6D)),
            )
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 15),
            Text(
              percentage,
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff706D6D),
                  height: 1.0),
            ),
            Text(
              amount.toString() + ' THB',
              style:
                  TextStyle(fontSize: 9, color: Color(0xffF75454), height: 1.0),
              textAlign: TextAlign.right,
            )
          ],
        )
      ],
    ),
  );
}
