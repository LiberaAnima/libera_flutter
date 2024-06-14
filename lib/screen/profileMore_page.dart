import 'package:flutter/material.dart';
import 'package:libera_flutter/screen/market/marketspecific_page.dart';
import 'package:libera_flutter/screen/post/post_specific.dart';

class ProfileMorePage extends StatelessWidget {
  final String title;
  final String userId;
  final dataSnapshot; // 스냅샷 데이터를 받아들일 변수를 추가

  ProfileMorePage(
      {super.key,
      required this.userId,
      required this.dataSnapshot,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: dataSnapshot.isNotEmpty
          ? Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: dataSnapshot.length,
                      itemBuilder: (context, index) {
                        final data = dataSnapshot[index];

                        return ListTile(
                          title: Text(
                            title == '自分の投稿'
                                ? data['title']
                                : data['bookname'] ?? '',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            title == '自分の投稿'
                                ? 'Likes: ${data['likes'].length}'
                                : '${data['price']}円',
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => title == '自分の投稿'
                                    ? PostSpecificPage(id: data['documentID'])
                                    : MarketSpecificPage(
                                        uid: data['documentId']),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: Text('データがありません')),
    );
    // 여기에서 userId와 data을 사용하여 컬렉션의 내용을 디스플레이합니다.
  }
}
