import 'package:flutter/material.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({Key? key}) : super(key: key);

  @override
  _TimeTablePageState createState() => _TimeTablePageState();
}

List week = ['月', '火', '水', '木', '金'];
var kColumnLength = 22;
double kFirstColumnHeight = 20;
double kBoxSize = 52;

class _TimeTablePageState extends State<TimeTablePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: kColumnLength / 2 * kBoxSize + kColumnLength,
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
                height: 20,
                child: Text(
                  '${week[index]}',
                ),
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
                    child: Container(),
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
