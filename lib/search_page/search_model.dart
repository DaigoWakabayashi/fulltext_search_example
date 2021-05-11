import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fulltext_search_example/domain/user.dart';
import 'package:fulltext_search_example/text_utils.dart';

class SearchModel extends ChangeNotifier {
  /// Firestore
  final _firestore = FirebaseFirestore.instance;
  List<User> users = []; // ユーザーたち

  /// 検索関連
  final searchController = TextEditingController();
  List<User> searchedUsers = []; // 検索してきたユーザーたち
  Query searchQuery; // 検索の条件
  List<dynamic> tokens = []; // n-gramのトークン
  bool isSearching = false; // 検索中かどうか
  bool showSearchedUser = false; // 検索モード（Page側で指定する）

  /// users の取得
  Future fetchUsers() async {
    try {
      // usersを取得
      final userSnap = await _firestore.collection('users').get();
      users = userSnap.docs.map((doc) => User(doc)).toList();
    } catch (e) {
      print(e.toString());
    } finally {
      notifyListeners();
    }
  }

//////////////////////////////////////// 検索用メソッド ////////////////////////////////////////

  /// 検索開始
  void startSearching() {
    this.isSearching = true;
    notifyListeners();
  }

  /// 検索終了
  void endSearching() {
    this.isSearching = false;
    notifyListeners();
  }

  /// テキストのクエリを追加する
  Future<void> addTextQuery(String input) async {
    // 検索文字数が2文字に満たない場合は検索を行わず、検索結果のリストを空にする
    if (input.length < 2) {
      this.searchedUsers = [];
      endSearching();
      return;
    }
    // 検索用フィールドに入力された文字列の前処理
    List<String> _words = input.trim().split(' ');
    // 文字列のリストを渡して、bi-gram を実行
    List preTokens = TextUtils.tokenize(_words);
    // 重複しているtokenがある場合、ひとつに纏める
    this.tokens = preTokens.toSet().toList();

    print(tokens);
  }

  /// 検索する
  Future searchUsers() async {
    startSearching();
    try {
      // テキスト検索where句を追加
      if (tokens.length != 0) {
        this.tokens.forEach((word) {
          print(word);
          searchQuery = _firestore
              .collection('users')
              .where('tokenMap.$word', isEqualTo: true);
        });
      }

      // print('【クエリ】');
      // print(searchQuery.parameters);

      // 検索に用いたクエリを変数に保存
      // this.searchQuery = _query;
      QuerySnapshot _snap = await searchQuery.get();

      this.searchedUsers = _snap.docs.map((doc) => User(doc)).toList();

      // 選択されたタグがゼロ＆＆テキスト検索をしていない場合、検索モードを解除
      if (tokens.length == 0) {
        endSearching();
        showSearchedUser = false;
      }
    } catch (e) {
      print(e.toString());
    } finally {
      endSearching();
      notifyListeners();
    }
  }

  //////////////////////////////////////// 追加用メソッド ////////////////////////////////////////

  /// ユーザーを追加する
  Future addUser(BuildContext context) async {
    try {
      // 名前を取得
      final inputtedName =
          await _showInputUserNameDialog(context, 'ユーザーを追加します', 'ユーザー名を入力');

      /// tokenMap を追加するための準備
      // 不要な空行を取り除く
      final noBlankName = TextUtils.removeUnnecessaryBlankLines(inputtedName);

      // tokenMap を作成するための入力となる文字列のリスト
      List _preTokenizedList = [];
      _preTokenizedList.add(noBlankName);
      List _tokenizedList = TextUtils.tokenize(_preTokenizedList);

      final tokenMap =
          Map.fromIterable(_tokenizedList, key: (e) => e, value: (_) => true);

      // 追加
      final newUserDoc = _firestore.collection('users').doc();
      await newUserDoc.set({
        'userId': newUserDoc.id,
        'name': inputtedName,
        'tokenMap': tokenMap,
      });
    } catch (e) {} finally {
      await fetchUsers();
      notifyListeners();
    }
  }

  /// ユーザ名入力用ダイアログ
  Future<String> _showInputUserNameDialog(
    BuildContext context,
    String title,
    String hint,
  ) async {
    final textEditingController = TextEditingController();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: SelectableText(
            title,
          ),
          content: TextFormField(
            controller: textEditingController,
            cursorColor: Colors.black,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: hint,
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                '追加',
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
    return textEditingController.text;
  }
}
