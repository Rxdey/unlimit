import 'package:flutter/material.dart';
import 'package:unlimit/public/public.dart' show TabList;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unlimit/model/model.dart';

class Subscription extends StatefulWidget {
  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription>
    with SingleTickerProviderStateMixin {
  List<TabList> tabs = [
    TabList(name: '追漫', key: 'save', page: Container(child: Text('追漫'))),
    TabList(name: '历史', key: 'history', page: Container(child: Text('历史'))),
  ];
  TabController _controller;
  List subscriptionList;
  String userName = 'jyh1994@qq.com';
  String userId = '1';
  bool isLogin = false;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
    _getData(userId, userName);
  }

  Future<void> _getData(id, name) async {
    setState(() {
      loading = true;
    });
    var res = ResponseData.fromJson(await Model.save({'userId': id, 'username': name}));
    setState(() {
      loading = false;
    });
    if (res.state != 1) {
      Fluttertoast.showToast(msg: res.msg, textColor: Colors.red, gravity: ToastGravity.CENTER);
      return false;
    }
    setState(() {
      subscriptionList = res.data;
    });
    print(res.data);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: 150.0,
            child: TabBar(
              indicatorWeight: 2.0,
              labelColor: Colors.black87,
              // labelPadding: EdgeInsets.only(top: 5, bottom: 5),
              unselectedLabelColor: Colors.black54,
              unselectedLabelStyle: TextStyle(fontSize: 14, height: 0.2),
              labelStyle: TextStyle(fontSize: 16),
              controller: _controller, //控制器
              indicatorColor: Colors.black87, //下划线颜色
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.zero,
              tabs: tabs
                  .map((item) => Tab(
                        text: item.name,
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            flex: 1,
            child: TabBarView(
              controller: _controller,
              children: tabs
                  .map((item) => Stack(
                        children: <Widget>[item.page],
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

class Books extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
