import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({Key? key}) : super(key: key);

  @override
  _TimeTablePageState createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  final List<String> days = ['月', '火', '水', '木', '金'];
  final List<String> numbers = ['1', '2', '3', '4', '5'];
  final Map<int, Map<String, String>> classes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: days.map((day) => Text(day)).toList(),
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: numbers.map((number) => Text(number)).toList(),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 40.0, left: 30.0, right: 20.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: 25,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        final result = await showDialog<Map<String, String>>(
                          context: context,
                          builder: (context) {
                            String className = '';
                            String roomName = '';
                            int period = index ~/ 5 + 1;
                            String day = ''; // index % 5 -> room name
                            switch (index % 5) {
                              case 0:
                                day = '月曜';
                                break;
                              case 1:
                                day = '火曜';
                                break;
                              case 2:
                                day = '水曜';
                                break;
                              case 3:
                                day = '木曜';
                                break;
                              case 4:
                                day = '金曜';
                                break;
                            }
                            return AlertDialog(
                              title: Text('$day,$period限',
                                  textAlign: TextAlign.center),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    decoration:
                                        InputDecoration(hintText: 'Class name'),
                                    onChanged: (value) {
                                      className = value;
                                    },
                                  ),
                                  TextField(
                                    decoration:
                                        InputDecoration(hintText: 'Room name'),
                                    onChanged: (value) {
                                      roomName = value;
                                    },
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop({
                                      'class': className,
                                      'room': roomName,
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        setState(() {
                          classes[index] = result!;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5.0),
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                classes[index]?['class'] ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(classes[index]?['room'] ?? ''),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
