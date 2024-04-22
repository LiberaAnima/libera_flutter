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
  final Map<int, String> classes = {};

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
                        final className = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            String input = '';
                            return AlertDialog(
                              title: Text('Enter class'),
                              content: TextField(
                                onChanged: (value) {
                                  input = value;
                                },
                              ),
                              actions: [
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop(input);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        setState(() {
                          classes[index] = className!;
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
                          child: Text(classes[index] ?? ''),
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
