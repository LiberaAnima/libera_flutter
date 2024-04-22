import 'package:flutter/material.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({Key? key}) : super(key: key);

  @override
  _TimeTablePageState createState() => _TimeTablePageState();
}

List week = ['月', '火', '水', '木', '金'];
var kColumnLength = 10;
double kFirstColumnHeight = 40;
double kBoxSize = 120;

class _TimeTablePageState extends State<TimeTablePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            height: kColumnLength / 2 * kBoxSize + kColumnLength + 40,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                buildTimeColumn(),
                ...List.generate(
                  5,
                  (index) => Expanded(
                    flex: 4,
                    child: Column(
                      children: buildDayColumn(index),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

Expanded buildTimeColumn() {
  return Expanded(
    child: Column(
      children: [
        SizedBox(
          height: kFirstColumnHeight,
        ),
        ...List.generate(
          kColumnLength,
          (index) {
            if (index % 2 == 0) {
              return const Divider(
                color: Colors.grey,
                height: 0,
              );
            }
            return SizedBox(
              height: kBoxSize,
              child: Center(child: Text('${index ~/ 2 + 1}')),
            );
          },
        ),
      ],
    ),
  );
}

List<Widget> buildDayColumn(int index) {
  return [
    const VerticalDivider(
      color: Colors.grey,
      width: 0,
    ),
    Expanded(
      flex: 4,
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: kFirstColumnHeight,
                child: Center(
                  child: Text(
                    '${week[index]}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ...List.generate(
                kColumnLength.toInt(),
                (index) {
                  if (index % 2 == 0) {
                    return const Divider(
                      color: Colors.grey,
                      height: 0,
                    );
                  }
                  return GestureDetector(
                    onTap: () {
                      print('tapped');
                    },
                    child: SizedBox(
                      height: kBoxSize,
                      child: Text("a"),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    ),
  ];
}
