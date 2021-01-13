import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  final index;
  Calendar(this.index);
  @override
  _CalendarState createState() => _CalendarState(index);
}

class _CalendarState extends State<Calendar> {
  final index;
  _CalendarState(this.index);
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _start = DateTime.now();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  var _dateSelect;
  var _start;
  var _end;
  String _dateString = '';
  final wallets = FirebaseFirestore.instance;
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(18, 10, 18, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
            ),
            child: TableCalendar(
              calendarController: _calendarController,
              initialCalendarFormat: CalendarFormat.week,
              calendarStyle: CalendarStyle(
                  selectedColor: Color(0xffB58FE7),
                  todayColor: Color(0xff6A2388),
                  markersColor: Colors.brown[700],
                  outsideDaysVisible: true,
                  weekdayStyle: TextStyle(color: Color(0xffA1A1A1)),
                  weekendStyle: TextStyle(color: Color(0xffA1A1A1)),
                  holidayStyle: TextStyle(color: Color(0xffA1A1A1)),
                  eventDayStyle: TextStyle(color: Color(0xffA1A1A1))),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Color(0xffB58FE7)),
                weekendStyle: TextStyle(color: Color(0xffB58FE7)),
              ),
              headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(color: Color(0xff6A2388)),
                  formatButtonTextStyle: TextStyle(color: Colors.white),
                  formatButtonDecoration: BoxDecoration(
                      color: Color(0xffB58FE7),
                      borderRadius: BorderRadius.circular(25))),
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
                CalendarFormat.week: 'Week',
              },
              onDaySelected: (date, events, holidays) {
                setState(() {
                  _dateSelect = date;
                  _dateString = _dateSelect.toString();
                  _start = Timestamp.fromMillisecondsSinceEpoch(_dateSelect
                      .add(new Duration(hours: -12))
                      .millisecondsSinceEpoch);
                  _end = Timestamp.fromMillisecondsSinceEpoch(_dateSelect
                      .add(new Duration(hours: 12))
                      .millisecondsSinceEpoch);
                  print(_dateString);
                  // print(_dateSelect.add(new Duration(hours: -12)));
                  // print(_dateSelect.add(new Duration(hours: 12)));
                  print(_start);
                  print(_end);
                });
              },
            ),
          ),
          new SizedBox(
            height: 30,
            child: Text(_dateString),
          ),
          new Expanded(
              child: Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: wallets
                    .collection('wallet')
                    .document(index)
                    .collection('transaction')
                    .orderBy('createdOn', descending: false)
                    .startAt([_start]).endAt([_end]).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot trans = snapshot.data.documents[index];
                        var time = DateFormat.yMMMd()
                            .add_jm()
                            .format(DateTime.parse(
                                trans['createdOn'].toDate().toString()))
                            .split(" ");
                        print(DateFormat.yMMMd().add_jm().format(DateTime.parse(
                            trans['createdOn'].toDate().toString())));
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: screenHeight * 66 / 760),
                          child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  15 / 360 * screenWidth,
                                  5 / 760 * screenHeight,
                                  15 / 360 * screenWidth,
                                  5 / 760 * screenHeight),
                              // height: screenHeight * 66 / 760,
                              width: screenWidth * 281 / 360,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 8 / 360 * screenWidth,
                                                right: 8 / 360 * screenWidth),
                                            child: Icon(
                                              Icons.add_photo_alternate,
                                              color: Color(0xffC88EC5),
                                              size: 40 /
                                                  (360 * 760) *
                                                  (screenHeight * screenWidth),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.33),
                                                child: Text(
                                                  trans['name'],
                                                  style: TextStyle(
                                                      fontFamily: 'Knit',
                                                      color: Color(0xff6A2388),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                              SizedBox(
                                                  height:
                                                      2 / 760 * screenHeight),
                                              Text(
                                                time[3] + " " + time[4],
                                                style: TextStyle(
                                                    color: Color(0xffBCBCBC),
                                                    fontSize: 11),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(
                                        "฿ " +
                                            trans['cost']
                                                .toStringAsFixed(2)
                                                .replaceAllMapped(
                                                    reg, mathFunc),
                                        style: TextStyle(
                                            color: Color(0xff6A2388),
                                            fontSize: 14 /
                                                (760 * 360) *
                                                (screenHeight * screenWidth),
                                            fontWeight: FontWeight.w700),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        );
                      });
                }),
          ))
        ],
      ),
    );
  }
}

class TransList extends StatefulWidget {
  final arg;
  final _date;
  TransList(this.arg, this._date);
  @override
  _TransListState createState() => _TransListState(arg, _date);
}

class _TransListState extends State<TransList> {
  final index;
  final String _dateSelected;
  _TransListState(this.index, this._dateSelected);
  final wallets = FirebaseFirestore.instance;
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: wallets
              .collection('wallet')
              .document(index)
              .collection('transaction')
              .orderBy('createdOn', descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot trans = snapshot.data.documents[index];
                  var time = DateFormat.yMMMd()
                      .add_jm()
                      .format(DateTime.parse(
                          trans['createdOn'].toDate().toString()))
                      .split(" ");
                  return ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: screenHeight * 66 / 760),
                    child: Container(
                        margin: EdgeInsets.fromLTRB(
                            15 / 360 * screenWidth,
                            5 / 760 * screenHeight,
                            15 / 360 * screenWidth,
                            5 / 760 * screenHeight),
                        // height: screenHeight * 66 / 760,
                        width: screenWidth * 281 / 360,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 8 / 360 * screenWidth,
                                          right: 8 / 360 * screenWidth),
                                      child: Icon(
                                        Icons.add_photo_alternate,
                                        color: Color(0xffC88EC5),
                                        size: 40 /
                                            (360 * 760) *
                                            (screenHeight * screenWidth),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.33),
                                          child: Text(
                                            trans['name'],
                                            style: TextStyle(
                                                fontFamily: 'Knit',
                                                color: Color(0xff6A2388),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        SizedBox(
                                            height: 2 / 760 * screenHeight),
                                        Text(
                                          time[3] + " " + time[4],
                                          style: TextStyle(
                                              color: Color(0xffBCBCBC),
                                              fontSize: 11),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  "฿ " +
                                      trans['cost']
                                          .toStringAsFixed(2)
                                          .replaceAllMapped(reg, mathFunc),
                                  style: TextStyle(
                                      color: Color(0xff6A2388),
                                      fontSize: 14 /
                                          (760 * 360) *
                                          (screenHeight * screenWidth),
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        )),
                  );
                });
          }),
    );
  }
}
