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
  bool isLogin = false;
  bool loading = false;
  String loadingText = '暂无数据';
  int _tabIndex = 0;
  int pageSize = 30;
  List<int> pageList = [1, 1];
  List<bool> loadingList = [true, true];
  bool get wantKeepAlive => true;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    setState(() {
      pageList[_tabIndex] = 0;
    });
    await Future.delayed(Duration(milliseconds: 1000));
    await _getData(_tabIndex);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    await _getData(_tabIndex, true);
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted)
      // setState(() {

      // });
      _refreshController.loadComplete();
  }

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
            _getData(_tabIndex);
          }
          if (_tabIndex == 1 && historyList.length == 0) {
            _getData(_tabIndex);
          }
          print(_tabIndex);
        }
      });
    });
    _getData(0);
  }

  Future<void> _getData(type, [bool isloading = false]) async {
    setState(() {
      loading = true;
      loadingText = '加载中...';
    });
    var res = ResponseData.fromJson(await Model.save({
      'type': type,
      'pageNo': pageList[_tabIndex],
      'pageSize': pageSize,
      'st': new DateTime.now().millisecondsSinceEpoch
    }));
    _refreshController.refreshCompleted();
    setState(() {
      loading = false;
      loadingText = '暂无数据';
    });
    if (res.state == 0) {
      Fluttertoast.showToast(
          msg: res.msg, textColor: Colors.red, gravity: ToastGravity.CENTER);
      return;
    }
    setState(() {
      if (_tabIndex == 0) {
        isloading
            ? subscriptionList.addAll(res.data)
            : subscriptionList = res.data;
      } else {
        isloading ? historyList.addAll(res.data) : historyList = res.data;
      }
      loadingText = '暂无订阅';
      if (res.data.length <= pageSize) {
        loadingList[_tabIndex] = false;
        return;
      }
      pageList[_tabIndex] += 1;
    });
    // print(res.data);
    return;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                        children: <Widget>[
                          booksWrap(
                              item.key == '0' ? subscriptionList : historyList)
                        ],
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget booksWrap(List currentList) {
    return Container(
      child: Scrollbar(
        child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: loadingList[_tabIndex],
            header: MaterialClassicHeader(),
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text("上拉加载");
                } else if (mode == LoadStatus.loading) {
                  body = CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("加载失败！点击重试！");
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("松手,加载更多!");
                } else {
                  body = Text("没有更多数据了!");
                }
                return Container(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: ListView(
              padding: EdgeInsets.all(24.0),
              children: <Widget>[
                currentList.length == 0
                    ? Text(
                        loadingText,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.lightBlue, height: 10),
                      )
                    : Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        alignment: WrapAlignment.start,
                        children: currentList
                            .asMap()
                            .map((key, item) => MapEntry(key, bookCard(item)))
                            .values
                            .toList(),
                      )
              ],
            )),
      ),
    );
  }

  Widget bookCard(Map card) {
    final double width = 105.0;
    String lastChaperName = card['last_chapter'] > -1
        ? '看到' + card['last_chapter_name'].toString()
        : '未看';
    return GestureDetector(
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) {
          return Detail(id: card['manhua'].toString());
        }));
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
