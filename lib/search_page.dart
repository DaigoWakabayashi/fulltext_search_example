import 'package:flutter/material.dart';
import 'package:fulltext_search_example/search_model.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchModel>(
      create: (_) => SearchModel(),
      builder: (context, child) {
        return Consumer<SearchModel>(builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('KBOYのFlutter大学'),
            ),
            body: Center(
              child: Text('検索するよ'),
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
  //             // メンター量産ボタン（レビュー終わったら消します）
  //             // BootstrapRow(
  //             //   height: 0,
  //             //   children: [
  //             //     BootstrapCol(
  //             //       child: RaisedButton(
  //             //           color: Colors.blue,
  //             //           child: Text('クローン生産'),
  //             //           onPressed: () async {
  //             //             await model.mentorIncrease();
  //             //           }),
  //             //     ),
  //             //   ],
  //             // ),
  //             /// 承認直後の講師に対するメッセージ
  //             teacherStatus == kTeacherStatusApproved
  //                 ? Center(
  //                 child: Padding(
  //                   padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
  //                   child: RichText(
  //                     textAlign: TextAlign.center,
  //                     text: TextSpan(
  //                       children: <TextSpan>[
  //                         TextSpan(
  //                             text: 'プラン作成済み・本人確認済み',
  //                             style: TextStyle(
  //                                 color: AppColors.themeAccentColor,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 15)),
  //                         TextSpan(
  //                             text:
  //                             'の講師が一覧に表示されます。\n自分のプランが表示されない場合は、右上のユーザーアイコン→講師モードから確認してください。',
  //                             style: TextStyle(
  //                               color: AppColors.themeAccentColor,
  //                             )),
  //                       ],
  //                     ),
  //                   ),
  //                 ))
  //                 : SizedBox(),
  //
  //             /// 検索tag
  //             SingleChildScrollView(
  //               scrollDirection: Axis.horizontal,
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: tags
  //                     .map((tag) => Container(
  //                   padding: EdgeInsets.only(right: 5.0),
  //                   child: ChoiceChip(
  //                     label: Text(tag.tagName),
  //                     labelStyle: TextStyle(
  //                         color: tag.isSelected
  //                             ? Colors.white
  //                             : Colors.black),
  //                     selectedColor: AppColors.themeAccentColor,
  //                     selected: tag.isSelected,
  //                     onSelected: (selected) async {
  //                       model.showFilteredTeacher = true;
  //                       if (selected) {
  //                         // 選択された場合クエリ追加
  //                         await model.addTagsQuery(tag);
  //                         await model.filterTeachers();
  //                       } else {
  //                         // 選択解除された場合クエリ削除
  //                         await model.removeTagsQuery(tag);
  //                         await model.filterTeachers();
  //                       }
  //                     },
  //                   ),
  //                 ))
  //                     .toList(),
  //               ),
  //             ),
  //             SizedBox(height: 10),
  //
  //             /// 検索TextField
  //             TextFormField(
  //               controller: model.searchController,
  //               textInputAction: TextInputAction.done,
  //               onChanged: (text) async {
  //                 if (text.isNotEmpty) {
  //                   // テキストが入力された
  //                   model.showFilteredTeacher = true;
  //                   await model.addTextQuery(text);
  //                   await model.filterTeachers();
  //                 } else {
  //                   // テキストが空になった
  //                   model.showFilteredTeacher = false;
  //                   await model.init();
  //                   model.endFiltering();
  //                 }
  //               },
  //               maxLines: 1,
  //               decoration: InputDecoration(
  //                 hintText: '言語名、講師名などを入力してください（2文字以上）',
  //                 prefixIcon: Icon(
  //                   Icons.search,
  //                   color: AppColors.headingBorder,
  //                 ),
  //                 focusedBorder: OutlineInputBorder(
  //                     borderSide: BorderSide(color: AppColors.headingBorder)),
  //                 border: OutlineInputBorder(
  //                     borderSide: BorderSide(color: AppColors.headingBorder)),
  //                 enabledBorder: OutlineInputBorder(
  //                     borderSide: BorderSide(color: AppColors.headingBorder)),
  //                 suffixIcon: model.searchController.text.isEmpty
  //                     ? SizedBox()
  //                     : IconButton(
  //                   icon: Icon(
  //                     Icons.clear,
  //                     color: AppColors.headingBorder,
  //                     size: 18,
  //                   ),
  //                   onPressed: () {
  //                     model.searchController.clear();
  //                     model.init();
  //                     model.endFiltering();
  //                   },
  //                 ),
  //               ),
  //               style: MultiLineStyle(),
  //             ),
  //           ],
  //         ),
  //       ));
  // }

  // Widget _body(HomeModel model) {
  //   final teachers = model.teachers;
  //   final filteredTeachers = model.filteredTeachers;
  //
  //   // ローディング表示
  //   if (teachers == null || !model.existsTeacher) {
  //     final dummyCard = BootstrapCol(
  //       sizes: 'col-lg-12 col-xl-6',
  //       child: UsefulCard.dummy(),
  //     );
  //     return Column(
  //       children: [
  //         BootstrapRow(
  //           height: 0,
  //           children: [
  //             dummyCard,
  //             dummyCard,
  //             dummyCard,
  //             dummyCard,
  //           ],
  //         ),
  //       ],
  //     );
  //   }
  //
  //   // 講師リスト
  //   final listTiles = teachers
  //       .map((teacher) => BootstrapCol(
  //     sizes: 'col-lg-12 col-xl-6',
  //     child: TeacherListCard(
  //       teacher,
  //           () async {
  //         await model.push(
  //           kRouteTeacherDetail,
  //           data: {
  //             'teacherId': teacher.teacherId,
  //           },
  //         );
  //         model.init();
  //       },
  //     ),
  //   ))
  //       .toList();
  //
  //   // 検索された講師リスト
  //   final filteredListTiles = filteredTeachers
  //       .map(
  //         (teacher) => BootstrapCol(
  //       sizes: 'col-lg-12 col-xl-6',
  //       child: TeacherListCard(
  //         teacher,
  //             () async {
  //           await model.push(
  //             kRouteTeacherDetail,
  //             data: {
  //               'teacherId': teacher.teacherId,
  //             },
  //           );
  //           model.init();
  //         },
  //       ),
  //     ),
  //   )
  //       .toList();
  //
  //   return Column(
  //     children: [
  //       // 講師カード
  //       BootstrapRow(
  //         height: 0,
  //         children: model.showFilteredTeacher ? filteredListTiles : listTiles,
  //       ),
  //       // ボタン表示
  //       BootstrapRow(
  //         height: 0,
  //         children: [
  //           BootstrapCol(
  //             sizes: 'col-3',
  //             offsets: 'col-3',
  //             child: SizedBox(),
  //           ),
  //           BootstrapCol(
  //             sizes: 'col-6',
  //             child: Container(
  //               height: 50,
  //               child: TextButton(
  //                 /// ボタンの文字
  //                 child: model.isFiltering
  //                     ?
  //                 // 検索実行中
  //                 Text('検索中...')
  //                     : model.showFilteredTeacher
  //                     ?
  //                 // 検索ステータスである
  //                 model.canLoadMoreFiltered
  //                     ?
  //                 // まだ講師がいる
  //                 Text('検索結果をさらに読み込む')
  //                     : model.existsFilteredTeacher
  //                     ?
  //                 //
  //                 Text('検索結果は以上です')
  //                     : Text('検索結果はありません')
  //                     :
  //                 // 検索ステータスでない
  //                 model.canLoadMore
  //                     ? Text('さらに読み込む')
  //                     : model.existsTeacher
  //                     ? Text('以上です')
  //                     : Text('$kTeacherがいません'),
  //
  //                 /// ボタンの機能
  //                 onPressed: model.showFilteredTeacher
  //                     ?
  //                 // 検索中
  //                 model.canLoadMoreFiltered
  //                     ? () async {
  //                   await model.loadMoreFilteredTeachers();
  //                 }
  //                     : null
  //                     :
  //                 // 検索中でない
  //                 model.canLoadMore
  //                     ? () async {
  //                   await model.fetchMoreTeachers();
  //                 }
  //                     : null,
  //               ),
  //             ),
  //           ),
  //           BootstrapCol(
  //             sizes: 'col-3',
  //             offsets: 'col-3',
  //             child: SizedBox(),
  //           ),
  //         ],
  //       ),
  //       SizedBox(
  //         height: 200,
  //       )
  //     ],
  //   );
  // }
}
