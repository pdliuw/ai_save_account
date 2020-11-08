import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

///
/// SaveAccountPasswordManager
/// 记住帐号密码工具
class SaveAccountPasswordManager {
  static const String ACCOUNT_NUMBER = "account_number";
  static const String USERNAME = "username";
  static const String PASSWORD = "password";
  static const String ACCOUNT_KEY = "ACCOUNT_KEY_SaveAccountPasswordManager";

  ///删掉单个账号
  static void delUser(UserAccount user) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<UserAccount> list = await getUsers();
    list.remove(user);
    saveUsers(list, sp);
  }

  ///保存账号，如果重复，就将最近登录账号放在第一个
  static void saveUser(UserAccount user) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<UserAccount> list = await getUsers();
    addNoRepeat(list, user);
    saveUsers(list, sp);
  }

  ///去重并维持次序
  static void addNoRepeat(List<UserAccount> users, UserAccount user) {
    if (users.contains(user)) {
      users.remove(user);
    }
    users.insert(0, user);
  }

  ///获取已经登录的账号列表
  static Future<List<UserAccount>> getUsers() async {
    List<UserAccount> list = new List();
    SharedPreferences sp = await SharedPreferences.getInstance();
    String jsonString = sp.getString(ACCOUNT_KEY);
    if (jsonString != null) {
      List<UserAccount> accountList =
          UserAccount.fromList(jsonDecode(jsonString));
      if (accountList != null && accountList.isNotEmpty) {
        list = accountList;
      }
    }

    return list;
  }

  ///保存账号列表
  static saveUsers(List<UserAccount> users, SharedPreferences sp) {
    String jsonString = jsonEncode(users);
    sp.setString(ACCOUNT_KEY, jsonString);
  }
}

///
/// UserAccount
class UserAccount {
  String _username;
  String _password;
  UserAccount(String username, String password) {
    _username = username;
    _password = password;
  }
  String get username => _username;
  String get password => _password;

  @override
  String toString() {
    return "|$_username $_password|";
  }

  Map toJson() {
    Map map = new Map();
    map["username"] = this.username;
    map["password"] = this.password;
    return map;
  }

  /// jsonDecode(jsonStr)方法返回的是Map<String, dynamic>类型，需要这里将map转换成实体类
  static List<UserAccount> fromList(dynamic data) {
    List<UserAccount> userList = [];
    List list = data;
    list.forEach((element) {
      UserAccount userAccount =
          UserAccount(element['username'], element['password']);
      userList.add(userAccount);
    });

    return userList;
  }

  @override
  bool operator ==(other) {
    return (_username == other._username);
  }
}
