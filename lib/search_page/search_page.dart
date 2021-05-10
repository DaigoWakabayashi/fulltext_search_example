import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'search_model.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchModel>(
      create: (_) => SearchModel()..fetchUsers(),
      builder: (context, child) {
        return Consumer<SearchModel>(builder: (context, model, child) {
          final users = model.users;
          final searchedUsers = model.searchedUsers;
          return Scaffold(
            appBar: AppBar(
              title: Text('Flutter大学生徒一覧'),
            ),
            body: Column(
              children: [
                /// 検索TextField
                TextFormField(
                  controller: model.searchController,
                  textInputAction: TextInputAction.done,
                  onChanged: (text) async {
                    if (text.isNotEmpty) {
                      // テキストが入力された
                      model.showSearchedUser = true;
                      await model.addTextQuery(text);
                      await model.searchUsers();
                    } else {
                      // テキストが空になった
                      model.showSearchedUser = false;
                      model.endSearching();
                      await model.fetchUsers();
                    }
                  },
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: '名前を入力してください（2文字以上）',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    suffixIcon: model.searchController.text.isEmpty
                        ? SizedBox()
                        : IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey,
                              size: 18,
                            ),
                            onPressed: () {
                              model.searchController.clear();
                              // model.init();
                              // model.endFiltering();
                            },
                          ),
                  ),
                ),
                Column(
                  children: model.showSearchedUser
                      ? searchedUsers
                          .map((user) => ListTile(
                                title: Text(user.name),
                              ))
                          .toList()
                      : users
                          .map((user) => ListTile(
                                title: Text(user.name),
                              ))
                          .toList(),
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                // 生徒を追加するダイアログ
                await model.addUser(context);
              },
            ),
          );
        });
      },
    );
  }

  // /// 検索部分のウィジェット
  // Widget _searchWidgets(HomeModel model) {
  //   final tags = model.tags;
  //   if (tags == null) {
  //     return Container(
  //       height: 35,
  //     );
  //   }
  //   return BootstrapCol(
  //       sizes: 'col-12',
  //       child: Container(
  //         padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             /// 検索tag
  //             SingleChildScrollView(
  //               scrollDirection: Axis.horizontal,
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: tags
  //                     .map((tag) => Container(
  //                           padding: EdgeInsets.only(right: 5.0),
  //                           child: ChoiceChip(
  //                             label: Text(tag.tagName),
  //                             labelStyle: TextStyle(
  //                                 color: tag.isSelected
  //                                     ? Colors.white
  //                                     : Colors.black),
  //                             selectedColor: AppColors.themeAccentColor,
  //                             selected: tag.isSelected,
  //                             onSelected: (selected) async {
  //                               model.showFilteredTeacher = true;
  //                               if (selected) {
  //                                 // 選択された場合クエリ追加
  //                                 await model.addTagsQuery(tag);
  //                                 await model.filterTeachers();
  //                               } else {
  //                                 // 選択解除された場合クエリ削除
  //                                 await model.removeTagsQuery(tag);
  //                                 await model.filterTeachers();
  //                               }
  //                             },
  //                           ),
  //                         ))
  //                     .toList(),
  //               ),
  //             ),
  //             SizedBox(height: 10),
  //           ],
  //         ),
  //       ));
  // }

  // Widget _body(HomeModel model) {
  //   final teachers = model.teachers;
  //   final filteredTeachers = model.filteredTeachers;
  //
  //   // 講師リスト
  //   final listTiles = teachers
  //       .map((teacher) => BootstrapCol(
  //             sizes: 'col-lg-12 col-xl-6',
  //             child: TeacherListCard(
  //               teacher,
  //               () async {
  //                 await model.push(
  //                   kRouteTeacherDetail,
  //                   data: {
  //                     'teacherId': teacher.teacherId,
  //                   },
  //                 );
  //                 model.init();
  //               },
  //             ),
  //           ))
  //       .toList();
  //
  //   // 検索された講師リスト
  //   final filteredListTiles = filteredTeachers
  //       .map(
  //         (teacher) => BootstrapCol(
  //           sizes: 'col-lg-12 col-xl-6',
  //           child: TeacherListCard(
  //             teacher,
  //             () async {
  //               await model.push(
  //                 kRouteTeacherDetail,
  //                 data: {
  //                   'teacherId': teacher.teacherId,
  //                 },
  //               );
  //               model.init();
  //             },
  //           ),
  //         ),
  //       )
  //       .toList();
  // }
}
