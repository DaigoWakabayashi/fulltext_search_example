import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fulltext_search_example/domain/member.dart';
import 'package:fulltext_search_example/utils/text_utils.dart';

class SearchModel extends ChangeNotifier {
  /// Firestore
  final _firestore = FirebaseFirestore.instance;
  List<Member> members = []; // ユーザーたち

  /// 検索関連
  List<Member> searchedMembers = []; // 検索してきたユーザーたち
  Query searchQuery; // 検索の条件
  List<dynamic> tokens = []; // n-gramのトークン
  bool isSearching = false; // 検索モード（Page側で指定する）
  final searchController = TextEditingController();

  /// members をリアルタイム取得
  void listenMembers() {
    try {
      // Firestore の members コレクションを取得
      final snapshots = _firestore.collection('members').snapshots();
      snapshots.listen((snapshot) {
        final docs = snapshot.docs;
        this.members = docs.map((doc) => Member(doc)).toList();
        notifyListeners();
      });
    } catch (e) {
      print(e.toString());
    } finally {
      notifyListeners();
    }
  }

//////////////////////////////////////// 検索用メソッド ////////////////////////////////////////

  /// 検索開始
  void startFiltering() {
    this.isSearching = true;
    notifyListeners();
  }

  /// 検索終了
  void endFiltering() {
    this.isSearching = false;
    notifyListeners();
  }

  /// メンバーを検索する
  Future searchMembers(String input) async {
    try {
      /// 検索文字数が2文字に満たない場合は検索を行わず、検索結果のリストを空にする
      if (input.length < 2) {
        this.searchedMembers = [];
        return;
      }

      /// 空白除去して配列にする
      List<String> _words = input.trim().split(' ');

      /// 文字列のリストを渡して、bi-gram を実行
      List preTokens = TextUtils.tokenize(_words);

      /// 重複しているtokenがある場合、ひとつに纏める
      this.tokens = preTokens.toSet().toList();

      /// テキスト検索where句を追加
      if (tokens.length != 0) {
        this.tokens.forEach((word) {
          searchQuery = _firestore
              .collection('members')
              .where('tokenMap.$word', isEqualTo: true);
        });
      }

      /// 作成したクエリで取得する
      QuerySnapshot _snap = await searchQuery.get();
      this.searchedMembers = _snap.docs.map((doc) => Member(doc)).toList();
    } catch (e) {
      print(e.toString());
    } finally {
      notifyListeners();
    }
  }

  //////////////////////////////////////// 追加用メソッド ////////////////////////////////////////

  /// メンバーを追加する
  Future addMember(BuildContext context) async {
    try {
      /// 名前を取得
      final inputtedName =
          await _showInputDialog(context, 'メンバーを追加します', '名前を入力（2文字以上）');

      /// tokenMap の作成
      // ①空行を取り除く
      final noBlankName = TextUtils.removeUnnecessaryBlankLines(inputtedName);

      // ②tokenMap を作成するための文字リストを作成
      List _preTokenizedList = [];
      _preTokenizedList.add(noBlankName);
      List _tokenizedList = TextUtils.tokenize(_preTokenizedList);

      // ③trueMap 型の tokenMap を作成
      final tokenMap =
          Map.fromIterable(_tokenizedList, key: (e) => e, value: (_) => true);

      /// Firestore に追加
      final newMemberDoc = _firestore.collection('members').doc();
      await newMemberDoc.set({
        'id': newMemberDoc.id,
        'name': inputtedName,
        'tokenMap': tokenMap,
      });
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  /// メンバー名入力用ダイアログ
  Future _showInputDialog(
    BuildContext context,
    String title,
    String hint,
  ) async {
    // ダイアログ内TextFieldのコントローラー
    final textEditingController = TextEditingController();
    // ダイアログ
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: SelectableText(title),
          content: TextFormField(
              controller: textEditingController,
              maxLines: 1,
              decoration: InputDecoration(
                labelText: hint,
                border: OutlineInputBorder(),
              )),
          actions: <Widget>[
            TextButton(
              child: Text('追加'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
    if (textEditingController.text.length >= 2) {
      return textEditingController.text;
    }
  }
}
