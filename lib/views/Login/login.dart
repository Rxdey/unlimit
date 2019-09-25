import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unlimit/util/util.dart';
import 'package:unlimit/model/model.dart';
import 'package:unlimit/views/Home/home.dart';
import 'package:flutter/cupertino.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = '';
  String password = '';
  bool isLoading = false;

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });
    var json = await Model.login({
      'username': username.trim(),
      'password': generateMd5(password.trim()),
      'st': new DateTime.now().millisecondsSinceEpoch
    });
    ResponseStringData res = ResponseStringData.fromJson(json);
    setState(() {
      isLoading = false;
    });
    // print(res);
    if (res.state == 0) {
      Fluttertoast.showToast(msg: res.msg, textColor: Colors.red, gravity: ToastGravity.CENTER);
      return;
    }
    await setStringItem('userName', res.data[0]['user_name']);
    await setStringItem('userId', res.data[0]['id'].toString());
    Fluttertoast.showToast(msg: res.msg,textColor: Colors.white, gravity: ToastGravity.CENTER);
    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) {
      return Home();
    }), (route) => route == null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Sign In',
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(40),
          color: Colors.white,
          child: Center(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                  // child: ,
                  ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: TextField(
                    autofocus: true,
                    onChanged: (v) {
                      setState(() {
                        username = v;
                      });
                    },
                    decoration: InputDecoration(hintText: '账号')),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: TextField(
                    obscureText: true,
                    onChanged: (v) {
                      setState(() {
                        password = v;
                      });
                    },
                    decoration: InputDecoration(hintText: '密码')),
              ),
              Container(
                width: double.infinity,
                height: 50,
                child: FlatButton(
                    color: Colors.redAccent,
                    child: Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    disabledColor: Colors.red[200],
                    onPressed: (username == '' || password == '') || isLoading ? null : _login),
              )
            ],
          )),
        ));
  }
}
