import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({Key? key}) : super(key: key);

  @override
  _TimeTablePageState createState() => _TimeTablePageState();
}

class TimeTableItem {
  String title;
  Color color;

  TimeTableItem({this.title = '', this.color = Colors.white});
}

class _TimeTablePageState extends State<TimeTablePage> {
  List<List<TimeTableItem>> timeTable = List.generate(
    5,
    (_) => List.generate(5, (_) => TimeTableItem()),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 500,
            child: Table(
              border: TableBorder.all(),
              children: List.generate(
                5,
                (row) => TableRow(
                  children: List.generate(
                    5,
                    (col) => InkWell(
                      onTap: () async {
                        final title = await showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Enter lecture title'),
                            content: TextField(),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop('Lecture title');
                                },
                              ),
                            ],
                          ),
                        );
                        setState(() {
                          timeTable[row][col].title = title ?? '';
                          timeTable[row][col].color = Colors.yellow;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        color: timeTable[row][col].color,
                        child: Text(timeTable[row][col].title),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
