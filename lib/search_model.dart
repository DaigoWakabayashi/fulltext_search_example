import 'package:flutter/material.dart';

class SearchModel extends ChangeNotifier {
//   /// 検索関連
//   final searchController = TextEditingController();
//   List<Teacher> filteredTeachers = []; // 検索してきた講師群
//   List<Tag> tags = []; // 検索タグ
//   List<String> selectedTags = []; // 検索対象になっているタグ
//   List<dynamic> tokens = []; // n-gramのトークン
//   bool existsFilteredTeacher = false;
//   bool canLoadMoreFiltered = false;
//   Query filterQuery = null;
//   bool isFiltering = false; // 検索中
//   bool showFilteredTeacher = false; // 検索モード（Page側で指定する）
//   bool isProcessing = false;
//
//   /// GitHubアカウントでログインする
//   Future signInWithGitHub() async {
//     try {
//       // 処理開始
//       _setIsProcessing(true);
//       await _usersRepository.signInWithGitHub();
//       await pop();
//       window.location.reload();
//     } on ApplicationException catch (e) {
//       notifyExceptionOnSlack(context, errorMessage: e.errorMessages.first);
//     } catch (e) {
//       notifyExceptionOnSlack(context, errorMessage: e.toString());
//     } finally {
//       // 処理終了
//       _setIsProcessing(false);
//     }
//   }
//
//   /// 処理の開始、終了を設定する
//   void _setIsProcessing(bool isProcessing) {
//     this.isProcessing = isProcessing;
//     notifyListeners();
//   }
//
//   @override
//   Future init() async {
//     try {
//       /// 講師・タグを取得する
//       teachers = await _teachersRepository.fetchTeachers(loadLimit);
//       tags = await _teachersRepository.fetchTags();
//
//       /// 取得した講師数によってボタンの表示を切り替える
//       if (teachers.length == 0) {
//         // ゼロの場合
//         this.existsTeacher = false;
//         this.canLoadMore = false;
//       } else if (teachers.length < this.loadLimit) {
//         // 1件以上20件未満の場合（底が来た場合）
//         this.existsTeacher = true;
//         this.canLoadMore = false;
//       } else {
//         // 20件以上ある場合（まだ読み込める場合）
//         this.existsTeacher = true;
//         this.canLoadMore = true;
//       }
//     } on ApplicationException catch (e) {
//       errorMessages.clear();
//       errorMessages.addAll(e.errorMessages);
//       notifyExceptionOnSlack(context, errorMessage: e.errorMessages.first);
//     } catch (e) {
//       errorMessages.clear();
//       errorMessages.addAll(e.errorMessages);
//       notifyExceptionOnSlack(context, errorMessage: e.toString());
//     } finally {
//       notifyListeners();
//     }
//   }
//
//   /// さらに読み込む
//   Future fetchMoreTeachers() async {
//     startLoading();
//     try {
//       // 追加のメンターを取得し、既存のメンターに追加
//       final moreTeachers =
//           await _teachersRepository.fetchMoreTeacher(loadLimit);
//
//       // 取得したメンター数によってボタンの表示を切り替える
//       if (moreTeachers.length == 0) {
//         // ゼロの場合
//         this.existsTeacher = false;
//         this.canLoadMore = false;
//       } else if (moreTeachers.length < this.loadLimit) {
//         // 1件以上20件未満の場合（底が来た場合）
//         this.existsTeacher = true;
//         this.canLoadMore = false;
//         teachers.addAll(moreTeachers);
//       } else {
//         // 20件以上ある場合（まだ読み込める場合）
//         this.existsTeacher = true;
//         this.canLoadMore = true;
//         teachers.addAll(moreTeachers);
//       }
//     } on ApplicationException catch (e) {
//       errorMessages.clear();
//       errorMessages.addAll(e.errorMessages);
//       notifyExceptionOnSlack(context, errorMessage: e.errorMessages.first);
//     } catch (e) {
//       errorMessages.clear();
//       errorMessages.addAll(e.errorMessages);
//       notifyExceptionOnSlack(context, errorMessage: e.toString());
//     } finally {
//       endLoading();
//     }
//   }
//
//   //////////////////////////////////////// 検索用メソッド ////////////////////////////////////////
//
//   /// 検索開始
//   void startFiltering() {
//     this.isFiltering = true;
//     notifyListeners();
//   }
//
//   /// 検索終了
//   void endFiltering() {
//     this.isFiltering = false;
//     notifyListeners();
//   }
//
//   /// 検索する
//   Future filterTeachers() async {
//     startFiltering();
//     try {
//       // 最低限のクエリ
//       Query _query = FirebaseFirestore.instance
//           .collection('teachers')
//           .where('hasPlan', isEqualTo: true)
//           .where('status', isEqualTo: kTeacherStatusVerified)
//           .limit(loadLimit);
//
//       // タグ群の数だけwhere句を追加
//       if (selectedTags.length != 0) {
//         this.selectedTags.forEach((tag) {
//           _query = _query.where('tagMap.$tag', isEqualTo: true);
//         });
//       }
//       // テキスト検索where句を追加
//       if (tokens.length != 0) {
//         this.tokens.forEach((word) {
//           _query = _query.where('tokenMap.$word', isEqualTo: true);
//         });
//       }
//
//       print('【クエリ】');
//       print(_query.parameters);
//
//       // 検索に用いたクエリを変数に保存
//       this.filterQuery = _query;
//       QuerySnapshot _snap = await _query.get();
//
//       // 取得した講師の数から「さらに読み込めるか」を判断
//       // そして「次の読み込み開始点」を設定
//       if (_snap.docs.length == 0) {
//         this.existsFilteredTeacher = false;
//         this.canLoadMoreFiltered = false;
//         this.filteredTeachers = [];
//       } else if (_snap.docs.length < this.loadLimit) {
//         this.existsFilteredTeacher = true;
//         this.canLoadMoreFiltered = false;
//         _teachersRepository.filteredLastVisible =
//             _snap.docs[_snap.docs.length - 1];
//         this.filteredTeachers = _snap.docs.map((doc) => Teacher(doc)).toList();
//       } else {
//         this.existsFilteredTeacher = true;
//         this.canLoadMoreFiltered = true;
//         _teachersRepository.filteredLastVisible =
//             _snap.docs[_snap.docs.length - 1];
//         this.filteredTeachers = _snap.docs.map((doc) => Teacher(doc)).toList();
//       }
//       // 選択されたタグがゼロ＆＆テキスト検索をしていない場合、検索モードを解除
//       if (selectedTags.length == 0 && tokens.length == 0) {
//         isFiltering = false;
//         showFilteredTeacher = false;
//       }
//     } on ApplicationException catch (e) {
//       errorMessages.clear();
//       errorMessages.addAll(e.errorMessages);
//     } finally {
//       endFiltering();
//       notifyListeners();
//     }
//   }
//
//   /// タグクエリを追加する
//   Future addTagsQuery(Tag tag) async {
//     // タグを選択状態にする
//     tag.isSelected = true;
//     // tagをクエリに追加
//     this.selectedTags.add(tag.tagName);
//   }
//
//   /// タグのクエリを取り除く
//   Future removeTagsQuery(Tag tag) async {
//     // 選択状態にする
//     tag.isSelected = false;
//     // tagをクエリから削除
//     this.selectedTags.remove(tag.tagName);
//   }
//
//   /// 講師を検索する
//   Future<void> addTextQuery(String input) async {
//     // 検索文字数が2文字に満たない場合は検索を行わず、検索結果のリストを空にする
//     if (input.length < 2) {
//       this.filteredTeachers = [];
//       endFiltering();
//       return;
//     }
//     // 検索用フィールドに入力された文字列の前処理
//     List<String> _words = input.trim().split(' ');
//     // 文字列のリストを渡して、bi-gram を実行
//     List preTokens = TextUtils.tokenize(_words);
//     // 重複しているtokenがある場合、ひとつに纏める
//     List tokens = preTokens.toSet().toList();
//     this.tokens = tokens;
//   }
//
//   /// 検索した講師をさらに読み込む
//   Future loadMoreFilteredTeachers() async {
//     startLoading();
//     try {
//       /// 前回の検索クエリを元にスナップショットを取得
//       QuerySnapshot _snap = await this
//           .filterQuery
//           .startAfterDocument(_teachersRepository.filteredLastVisible)
//           .get();
//
//       // 取得したメンター数によってボタンの表示を切り替える
//       if (_snap.docs.length == 0) {
//         // ゼロの場合
//         this.canLoadMoreFiltered = false;
//       } else if (_snap.docs.length < this.loadLimit) {
//         // loadLimit 未満の場合
//         this.canLoadMoreFiltered = false;
//         _teachersRepository.filteredLastVisible =
//             _snap.docs[_snap.docs.length - 1];
//         final _filteredTeachers =
//             _snap.docs.map((doc) => Teacher(doc)).toList();
//         this.filteredTeachers.addAll(_filteredTeachers);
//       } else {
//         // loadLimit 以上の場合
//         this.canLoadMoreFiltered = true;
//         _teachersRepository.filteredLastVisible =
//             _snap.docs[_snap.docs.length - 1];
//         final _filteredTeachers =
//             _snap.docs.map((doc) => Teacher(doc)).toList();
//         this.filteredTeachers.addAll(_filteredTeachers);
//       }
//     } on ApplicationException catch (e) {
//       errorMessages.clear();
//       errorMessages.addAll(e.errorMessages);
//     } finally {
//       endLoading();
//     }
//   }

}
