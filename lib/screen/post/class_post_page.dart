import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:libera_flutter/screen/post/post_page.dart';
import 'package:libera_flutter/models/user_model.dart';
import 'package:libera_flutter/services/user_service.dart';

class ClassPostPage extends StatefulWidget {
  final String uid;
  const ClassPostPage({Key? key, required this.uid}) : super(key: key);

  @override
  _ClassPostPageState createState() => _ClassPostPageState();
}

enum attendList {
  not_attendance,
  often_attendance,
  almost_attendance,
  always_attendance
} //取らない, 時々とる, ほぼ毎回取る, 毎回取る

enum textList { require_text, not_text } //必要, 不要

enum taskList { many, normal, few } //多い、普通、少ない

enum conditionList { full, retire, once } //最後まで受けた, 履修中止した, 一回だけ

class _ClassPostPageState extends State<ClassPostPage> {
  IconData? _selectedIcon;
  List<double> _rating = [0.0, 0.0];

  TextEditingController _subjectEditingController = TextEditingController();
  TextEditingController _commentEditingController = TextEditingController();
  final _subject = GlobalKey<FormState>();
  final _comment = GlobalKey<FormState>();
  bool _isAnonymous = false;

  attendList? selectedValue = attendList.not_attendance;
  textList? selectedValue2 = textList.require_text;
  taskList? selectedValue3 = taskList.normal;
  conditionList? selectedValue4 = conditionList.full;
  List<bool> score = [false, false, false, false, false];
  List<bool> contact = [
    false,
    false,
    false,
    false,
    false,
    false
  ]; //ポータルサイト(LUNAやうりぼーポータル), 教授HP, Teams, slack, email, その他

  List<String> attend = ["取らない", "時々とる", "ほぼ毎回取る", "毎回取る"];
  List<String> TextRequire = ["必要", "不要"];
  List<String> Tasks = ["多い", "普通", "少ない"];
  List<String> condition = ["最後まで受けた", "履修中止した", "一回だけ"];

  String? isSelectedValue;
  List<dynamic> _subjects = [];

  _onSubmitted(String content) {
    /// 入力欄をクリアにする
    _subjectEditingController.clear();
    _commentEditingController.clear();
    selectedValue = attendList.not_attendance;
    selectedValue2 = textList.require_text;
    selectedValue3 = taskList.normal;
    selectedValue4 = conditionList.full;
    score = [false, false, false, false, false];
    contact = [false, false, false, false, false, false];
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _rating = [0.0, 0.0];
  }

  final UserService _userService = UserService();
  UserModel? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _fetchUserData() async {
    try {
      UserModel userData = await _userService.getUserData(widget.uid);
      setState(() {
        _user = userData;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void _fetchSubjects() async {
    var subjectsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: widget.uid)
        .get();

    setState(() {
      _subjects = subjectsSnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    //ユーザーデータの準備
    Stream<QuerySnapshot> subjectlists;
    subjectlists = FirebaseFirestore.instance
        .collection('users')
        .where(widget.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text("授業評価"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("科目名"),
                      _inputText(
                          label: "科目名",
                          EditingController: _subjectEditingController,
                          Key_value: _subject),
                      _ratingBar(title: "楽単", rating: _rating[0], index: 0),
                      Text(
                        'あなたの評価: ${_rating[0]}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              Center(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _ratingBar(title: "授業評価", rating: _rating[1], index: 1),
                      Text(
                        'あなたの評価: ${_rating[1]}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              //Text(attendList.values.length.toString()),
              Text("出席"),
              _attendButton(),
              const SizedBox(
                height: 10,
              ),
              Text("教科書"),
              _textradioButton(),
              const SizedBox(
                height: 10,
              ),
              Text("課題"),
              _taskradioButton(),
              Text("コメント"),
              _inputText(
                  label: "コメント",
                  EditingController: _commentEditingController,
                  Key_value: _comment),
              Text("評価方法"),
              Score_review(),
              Text("あなたの履修状況"),
              _conditionradioButton(),
              Text("連絡手段"),
              Contact_review(),
              Row(
                children: [
                  const Text('匿名投稿'),
                  Checkbox(
                    overlayColor: MaterialStateProperty.all(Colors.blue),
                    value: _isAnonymous,
                    onChanged: (bool? value) {
                      setState(() {
                        _isAnonymous = value!;
                        print(_isAnonymous);
                      });
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          final User? user = FirebaseAuth.instance.currentUser;

          if (!_comment.currentState!.validate()) {
            return;
          }
          if (user != null) {
            print(selectedValue);
            final String uid = user.uid;
            final DocumentSnapshot userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .get();
            final post =
                FirebaseFirestore.instance.collection('class_review').doc();
            post.set({
              // 匿名投稿の場合は、名前を「名無し」とする　( if 得意名　checks -> true)
              //'subject': _titleEditingController.text,
              'date': FieldValue.serverTimestamp(),
              'name': userDoc['username'],
              'likes': [],
              'uid': uid,
              'documentID': post.id,
              'isAnonymous': _isAnonymous,
              'SubjectName': _subjectEditingController.text,
              'Rakudan': _rating[0],
              'Review': _rating[1],
              'Attendance': selectedValue.toString(),
              'Textbook': selectedValue2.toString(),
              'Tasks': selectedValue3.toString(),
              'Comment': _commentEditingController.text,
              'Review_Method': score,
              'Contact_Method': contact,
              'Condition': selectedValue4.toString(),
            });
            _onSubmitted(_commentEditingController.text);
            Navigator.pop(context);
          }
        },
        child: Icon(Icons.send, color: Colors.white),
      ),
    );
  }

  Widget _textradioButton() {
    return Center(
      child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: const Text("必要"),
                leading: Radio(
                    value: textList.require_text,
                    groupValue: selectedValue2,
                    onChanged: (val) {
                      setState(() {
                        selectedValue2 = val;
                      });
                    }),
              ),
              ListTile(
                title: const Text("不要"),
                leading: Radio(
                    value: textList.not_text,
                    groupValue: selectedValue2,
                    onChanged: (val) {
                      setState(() {
                        selectedValue2 = val;
                      });
                    }),
              ),
            ],
          )),
    );
  }

  Widget _attendButton() {
    return Center(
      child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: const Text("取らない"),
                leading: Radio(
                    value: attendList.not_attendance,
                    groupValue: selectedValue,
                    onChanged: (val) {
                      setState(() {
                        selectedValue = val;
                      });
                    }),
              ),
              ListTile(
                title: const Text("時々とる"),
                leading: Radio(
                    value: attendList.often_attendance,
                    groupValue: selectedValue,
                    onChanged: (val) {
                      setState(() {
                        selectedValue = val;
                      });
                    }),
              ),
              ListTile(
                title: const Text("ほぼ毎回取る"),
                leading: Radio(
                    value: attendList.almost_attendance,
                    groupValue: selectedValue,
                    onChanged: (val) {
                      setState(() {
                        selectedValue = val;
                      });
                    }),
              ),
              ListTile(
                title: const Text("毎回とる"),
                leading: Radio(
                    value: attendList.always_attendance,
                    groupValue: selectedValue,
                    onChanged: (val) {
                      setState(() {
                        selectedValue = val;
                      });
                    }),
              ),
            ],
          )),
    );
  }

  Widget _taskradioButton() {
    return Center(
      child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: const Text("多い"),
                leading: Radio(
                    value: taskList.many,
                    groupValue: selectedValue3,
                    onChanged: (val) {
                      setState(() {
                        selectedValue3 = val;
                      });
                    }),
              ),
              ListTile(
                title: const Text("普通"),
                leading: Radio(
                    value: taskList.normal,
                    groupValue: selectedValue3,
                    onChanged: (val) {
                      setState(() {
                        selectedValue3 = val;
                      });
                    }),
              ),
              ListTile(
                title: const Text("少ない"),
                leading: Radio(
                    value: taskList.few,
                    groupValue: selectedValue3,
                    onChanged: (val) {
                      setState(() {
                        selectedValue3 = val;
                      });
                    }),
              ),
            ],
          )),
    );
  }

  //履修中止か最後まで受けた
  Widget _conditionradioButton() {
    return Center(
      child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: const Text("最後まで受けた"),
                leading: Radio(
                    value: conditionList.full,
                    groupValue: selectedValue4,
                    onChanged: (val) {
                      setState(() {
                        selectedValue4 = val;
                      });
                    }),
              ),
              ListTile(
                title: const Text("履修中止した"),
                leading: Radio(
                    value: conditionList.retire,
                    groupValue: selectedValue4,
                    onChanged: (val) {
                      setState(() {
                        selectedValue4 = val;
                      });
                    }),
              ),
              ListTile(
                title: const Text("試しに受けた"),
                leading: Radio(
                    value: conditionList.once,
                    groupValue: selectedValue4,
                    onChanged: (val) {
                      setState(() {
                        selectedValue4 = val;
                      });
                    }),
              ),
            ],
          )),
    );
  }

  Widget _inputText(
      {required String label,
      required TextEditingController EditingController,
      required final Key_value}) {
    return Center(
      child: SizedBox(
        width: 300,
        child: Form(
          key: Key_value, // Create a unique key
          child: TextFormField(
            controller: EditingController,
            // onSubmitted: _onSubmitted,
            enabled: true,
            validator: (value) {
              if (value!.isEmpty) {
                return label + 'を入力してください';
              }
              return null;
            },
            //maxLengthEnforced: false, // 入力上限になったときに、文字入力を抑制するか
            style: TextStyle(color: Colors.black),
            obscureText: false,
            maxLines: 1,
            decoration: const InputDecoration(
              hintText: '入力してください',
            ),
          ),
        ),
      ),
    );
  }

  Widget _ratingBar(
      {required String title, required double rating, required int index}) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(title),
          SizedBox(height: 4),
          RatingBar.builder(
            initialRating: rating,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            unratedColor: Colors.amber.withAlpha(50),
            itemCount: 5,
            itemSize: 20.0,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              _selectedIcon ?? Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (newRating) {
              setState(() {
                _rating[index] = newRating;
              });
            },
            updateOnDrag: true,
          ),
        ],
      ),
    );
  }

  Widget Score_review() {
    return Center(
      child: SizedBox(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Checkbox(
                    value: score[0],
                    onChanged: (value) {
                      setState(() {
                        score[0] = value!; // チェックボックスに渡す値を更新する
                      });
                    }),
                SizedBox(
                  width: 10,
                ),
                Text("中間テスト"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: score[1],
                    onChanged: (value) {
                      setState(() {
                        score[1] = value!; // チェックボックスに渡す値を更新する
                      });
                    }),
                SizedBox(
                  width: 10,
                ),
                Text("定期テスト"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: score[2],
                    onChanged: (value) {
                      setState(() {
                        score[2] = value!; // チェックボックスに渡す値を更新する
                      });
                    }),
                SizedBox(
                  width: 10,
                ),
                Text("授業中テスト"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: score[3],
                    onChanged: (value) {
                      setState(() {
                        score[3] = value!; // チェックボックスに渡す値を更新する
                      });
                    }),
                SizedBox(
                  width: 10,
                ),
                Text("課題レポート"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: score[4],
                    onChanged: (value) {
                      setState(() {
                        score[4] = value!; // チェックボックスに渡す値を更新する
                      });
                    }),
                SizedBox(
                  width: 10,
                ),
                Text("期末レポート"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget Contact_review() {
    return Center(
      child: SizedBox(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Checkbox(
                    value: contact[0],
                    onChanged: (value) {
                      setState(() {
                        contact[0] = value!; // チェックボックスに渡す値を更新する
                      });
                    }),
                SizedBox(
                  width: 10,
                ),
                Text("ポータルサイト"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: contact[1],
                    onChanged: (value) {
                      setState(() {
                        contact[1] = value!; // チェックボックスに渡す値を更新する
                      });
                    }),
                SizedBox(
                  width: 10,
                ),
                Text("教授作成ページ"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: contact[2],
                    onChanged: (value) {
                      setState(() {
                        contact[2] = value!; // チェックボックスに渡す値を更新する
                      });
                    }),
                SizedBox(
                  width: 10,
                ),
                Text("Teams"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: contact[3],
                    onChanged: (value) {
                      setState(() {
                        contact[3] = value!; // チェックボックスに渡す値を更新する
                      });
                    }),
                SizedBox(
                  width: 10,
                ),
                Text("Slack"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: contact[4],
                    onChanged: (value) {
                      setState(() {
                        contact[4] = value!; // チェックボックスに渡す値を更新する
                      });
                    }),
                SizedBox(
                  width: 10,
                ),
                Text("Email"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: contact[5],
                    onChanged: (value) {
                      setState(() {
                        contact[5] = value!; // チェックボックスに渡す値を更新する
                      });
                    }),
                SizedBox(
                  width: 10,
                ),
                Text("その他"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
