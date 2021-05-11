import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'search_model.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchModel>(
      create: (_) => SearchModel()..listenMembers(),
      builder: (context, child) {
        return Consumer<SearchModel>(builder: (context, model, child) {
          // メンバー
          final members = model.members;
          // 検索されたメンバー
          final searchedMembers = model.searchedMembers;

          return Scaffold(
            appBar: AppBar(
              title: Text('Flutter大学メンバー一覧'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  /// 検索TextField
                  TextFormField(
                    controller: model.searchController,
                    textInputAction: TextInputAction.done,
                    onChanged: (text) async {
                      if (text.isNotEmpty) {
                        // テキストが入力された
                        model.startFiltering();
                        await model.searchMembers(text);
                      } else {
                        // テキストが空になった
                        model.isSearching = false;
                        model.endFiltering();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: '名前を入力してください（2文字以上）',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  /// メンバーのリスト
                  Column(
                    children: model.isSearching
                        ?
                        // 検索中は searchedMembers を表示
                        searchedMembers
                            .map((user) => ListTile(
                                  title: Text(user.name),
                                ))
                            .toList()
                        :
                        // 検索中でない場合は通常の members を表示
                        members
                            .map((user) => ListTile(
                                  title: Text(user.name),
                                ))
                            .toList(),
                  )
                ],
              ),
            ),

            /// メンバー追加ボタン
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                await model.addMember(context);
              },
            ),
          );
        });
      },
    );
  }
}
