import 'package:flutter/material.dart';

class SchoolPage extends StatefulWidget {
  const SchoolPage({Key? key}) : super(key: key);

  @override
  _SchoolPageState createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("授業画面"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.table_chart_outlined),
              text: "時間割",
            ),
            Tab(
              icon: Icon(Icons.auto_stories_sharp),
              text: "授業評価",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Center(
            child: Text("時間割"),
          ),
          Center(
            child: Text("授業評価"),
          ),
        ],
      ),
    );
  }
}
