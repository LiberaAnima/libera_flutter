import 'package:flutter/material.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({Key? key}) : super(key: key);

  @override
  _TimeTablePageState createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  final List<String> days = ['월', '화', '수', '목', '금'];
  final List<String> numbers = ['1', '2', '3', '4', '5'];
  final Map<int, String> classes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("授業画面"),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
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
            left: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: numbers.map((number) => Text(number)).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
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
                    margin: const EdgeInsets.all(8.0),
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
    );
  }
}
