import 'package:flutter/material.dart';
import 'package:unlimit/public/public.dart' show TabList;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unlimit/model/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:unlimit/views/Detail/detail.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Subscription extends StatefulWidget {
  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _controller;
  List subscriptionList = [];
  List historyList = [];
  List<TabList> tabs = [
    TabList(name: '追漫', key: '0'),
    TabList(name: '历史', key: '1'),
  ];
  String userName = 'jyh1994@qq.com';
  String userId = '1';
  bool isLogin = false;
  bool loading = false;
  String loadingText = '暂无订阅';
  int _tabIndex = 0;
  bool get wantKeepAlive => true;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await _getData(userId, userName, _tabIndex);
    await Future.delayed(Duration(milliseconds: 1000));
    // print('_onRefresh');
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  // void _onLoading() async {
  //   // monitor network fetch
  //   // await Future.delayed(Duration(milliseconds: 1000));
  //   // await _getData(userId, userName, _tabIndex);
  //   // if failed,use loadFailed(),if no data return,use LoadNodata()
  //   if (mounted)
  //     // setState(() {

  //     // });
  //     _refreshController.loadComplete();
  // }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
    _controller.addListener(() {
      loadingText = '加载中...';
      setState(() {
        if (_tabIndex != _controller.index) {
          _tabIndex = _controller.index;
          if (_tabIndex == 0 && subscriptionList.length == 0) {
            _getData(userId, userName, _tabIndex);
          }
          if (_tabIndex == 1 && historyList.length == 0) {
            _getData(userId, userName, _tabIndex);
          }
          print(_tabIndex);
        }
      });
    });
    _getData(userId, userName, 0);
  }

  Future<void> _getData(id, name, type) async {
    setState(() {
      loading = true;
      loadingText = '加载中...';
    });
    var res = ResponseData.fromJson(
        await Model.save({'userId': id, 'username': name, 'type': type}));
    setState(() {
      loading = false;
    });
    if (res.state == 0) {
      Fluttertoast.showToast(
          msg: res.msg, textColor: Colors.red, gravity: ToastGravity.CENTER);
      return false;
    }
    setState(() {
      if (_tabIndex == 0) {
        subscriptionList = res.data;
      } else {
        historyList = res.data;
      }

      loadingText = '暂无订阅';
    });
    print(res.data);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: MaterialClassicHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Container(
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
                            children: <Widget>[
                              Books(
                                  subscriptionList: item.key == '0'
                                      ? subscriptionList
                                      : historyList,
                                  loadingText: loadingText)
                            ],
                          ))
                      .toList(),
                ),
              )
            ],
          ),
        ));
  }
}

class Books extends StatelessWidget {
  final List subscriptionList;
  final String loadingText;
  Books({this.subscriptionList, this.loadingText});
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: double.infinity,
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
        child: subscriptionList.length == 0
            ? Text(
                loadingText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.lightBlue, height: 10),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 每行三列
                  childAspectRatio: 0.65, // 显示区域宽高相等
                  crossAxisSpacing: 0, // 水平间距
                  mainAxisSpacing: 0, // 垂直间距
                ),
                padding: EdgeInsets.all(5.0),
                itemCount: subscriptionList.length,
                itemBuilder: (BuildContext context, idx) {
                  return SubscriptionCard(subscriptionList[idx]);
                },
              ),
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final Map card;
  SubscriptionCard(this.card);
  final double width = 105.0;
  handleTap(context) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return Detail(id: card['manhua'].toString());
    }));
  }

  @override
  Widget build(BuildContext context) {
    String lastChaperName = card['last_chapter'] > 0
        ? '看到' + card['last_chapter_name'].toString()
        : '未看';
    return GestureDetector(
      onTap: () {
        handleTap(context);
      },
      child: Container(
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                width: width,
                height: 140.0,
                child: FadeInImage.assetNetwork(
                  placeholder: 'lib/assets/image/v.png',
                  image: card['cover'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(bottom: 3.0),
              width: width,
              child: Text(
                card['name'],
                maxLines: 1,
                style: TextStyle(height: 1.5),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              width: width,
              child: Text(
                lastChaperName,
                maxLines: 1,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
