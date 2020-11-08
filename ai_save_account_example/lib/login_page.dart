import 'package:ai_awesome_message/ai_awesome_message.dart';
import 'package:ai_save_account/ai_save_account.dart';
import 'package:air_design/air_design.dart';
import 'package:airoute/airoute.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// LoginPage
/// 登录页面
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  ///
  /// 记住密码
  bool _saveAccountAndPassword = false;
  dynamic _requestLoginData = {
    "username": "",
    "password": "",
  };

  GlobalKey _globalKey = new GlobalKey(); //用来标记控件
  bool _expand = false; //是否展示历史账号
  List<UserAccount> _users = new List(); //历史账号

  String get _username => _requestLoginData['username'];
  set _username(String username) {
    _requestLoginData['username'] = username;
  }

  String get _password => _requestLoginData['password'];
  set _password(String password) {
    _requestLoginData['password'] = password;
  }

  @override
  void initState() {
    super.initState();
    //user account list
    _gainUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("记住帐号/密码"),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 18.0, right: 18.0, top: 10.0, bottom: 10.0),
                    margin: EdgeInsets.only(top: 15.0, left: 12.0, right: 12.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        border: Border.all(color: Colors.white, width: 0.5),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(1.0, 1.0),
                              blurRadius: 5.0,
                              spreadRadius: 2.0)
                        ]),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        _buildUsername(),
                        Stack(
                          children: [
                            Column(
                              children: [
                                _buildPassword(),
                                _buildLoginButton(),
                              ],
                            ),
                            _expand ? _buildListView() : Container(),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _saveAccountAndPassword =
                                      !_saveAccountAndPassword;
                                });
                              },
                              child: Row(
                                children: [
                                  Checkbox(
                                      value: _saveAccountAndPassword,
                                      onChanged: (checked) {
                                        setState(() {
                                          _saveAccountAndPassword = checked;
                                        });
                                      }),
                                  AirTextWidget.defaultStyle(
                                    data: "记住密码",
                                    lineHeight: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  /// login submit
  /// 登录
  _requestLogin() async {
    if (_saveAccountAndPassword) {
      //保存帐号密码
      SaveAccountPasswordManager.saveUser(UserAccount(_username, _password));
    }
    Airoute.pushReplacementNamed(routeName: "/MainPage");
    Airoute.push(
        route: AwesomeMessageRoute(
            theme: null,
            awesomeMessage: AwesomeHelper.createAwesome(
              message: "成功",
              tipType: TipType.COMPLETE,
            )));
  }

  ///构建账号输入框
  Widget _buildUsername() {
    return TextField(
      key: _globalKey,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide()),
        contentPadding: EdgeInsets.all(8),
        fillColor: Colors.white,
        filled: true,
        hintText: "请输入帐号/手机号",
        prefixIcon: Icon(Icons.person_outline),
        suffixIcon: GestureDetector(
          onTap: () {
            if (_users.isNotEmpty) {
              //如果个数大于1个或者唯一一个账号跟当前账号不一样才弹出历史账号
              setState(() {
                _expand = !_expand;
              });
            }
          },
          child: _expand
              ? Icon(
                  Icons.arrow_drop_up,
                  color: Colors.red,
                )
              : Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
        ),
      ),
      controller: TextEditingController.fromValue(
        TextEditingValue(
          text: _username,
          selection: TextSelection.fromPosition(
            TextPosition(
              affinity: TextAffinity.downstream,
              offset: _username == null ? 0 : _username.length,
            ),
          ),
        ),
      ),
      onChanged: (value) {
        _username = value;
      },
    );
  }

  ///构建密码输入框
  Widget _buildPassword() {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide()),
          fillColor: Colors.white,
          filled: true,
          hintText: "请输入密码",
          prefixIcon: Icon(Icons.lock),
          contentPadding: EdgeInsets.all(8),
        ),
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: _password,
            selection: TextSelection.fromPosition(
              TextPosition(
                affinity: TextAffinity.downstream,
                offset: _password == null ? 0 : _password.length,
              ),
            ),
          ),
        ),
        onChanged: (value) {
          _password = value;
        },
        obscureText: true,
      ),
    );
  }

  ///构建历史账号ListView
  Widget _buildListView() {
    if (_expand) {
      return Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              UserAccount user = _users[index];
              return GestureDetector(
                child: Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.only(
                    left: 8,
                    top: 8,
                    right: 8,
                    bottom: 8,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("${user.username}"),
                          GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: Icon(
                                Icons.remove_circle_outline,
                                color: Colors.grey,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _users.remove(user);
                                SaveAccountPasswordManager.delUser(user);
                                //处理最后一个数据，假如最后一个被删掉，将Expand置为false
                                //如果个数大于1个或者唯一一个账号跟当前账号不一样才弹出历史账号
                                _expand = _users.isNotEmpty;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    _username = user.username;
                    _password = user.password;
                    _expand = false;
                  });
                },
              );
            },
            itemCount: _users.length,
          )
        ],
      );
    }
    return Container();
  }

  ///构建登录按钮
  Widget _buildLoginButton() {
    return Container(
      padding: EdgeInsets.only(top: 30),
      width: double.infinity,
      child: MaterialButton(
        onPressed: () {
          //登录
          _requestLogin();
        },
        child: Text("登录"),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
      ),
    );
  }

  ///获取历史用户
  void _gainUsers() async {
    _users.clear();
    _users.addAll(await SaveAccountPasswordManager.getUsers());
    //默认加载第一个账号
    if (_users.isNotEmpty) {
      setState(() {
        _username = _users[0].username;
        _password = _users[0].password;
      });
    }
  }
}
