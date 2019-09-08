import 'package:flutter/material.dart';
import 'package:unlimit/components/iconfont.dart';

class TabList {
  String name;
  String key;
  Icon icon;
  Widget page;
  TabList(this.name, this.key, this.icon, this.page);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  // 自定义navigationBar
  TabController _tabController;
  List<TabList> tabs = [
    TabList('订阅', 'sub', Icon(IconFont.wenjian), Container(child: Text('订阅'))),
    TabList('我的', 'user', Icon(IconFont.wode), Container(child: Text('我的'))),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: TabBarView(
            controller: _tabController,
            children: tabs
                .map((item) => Stack(
                      children: <Widget>[item.page],
                    ))
                .toList(),
          ),
        ),
        bottomNavigationBar: navigationBar());
  }

  Widget navigationBar() {
    return SafeArea(
      child: TabBar(
          indicatorWeight: 1,
          indicator: BoxDecoration(),
          labelColor: Colors.orange,
          labelPadding: EdgeInsets.only(top: 5, bottom: 5),
          unselectedLabelColor: Colors.black,
          unselectedLabelStyle: TextStyle(fontSize: 12, height: 0.2),
          labelStyle: TextStyle(fontSize: 12),
          controller: _tabController,
          tabs: tabs.map((item) => Tab(icon: item.icon)).toList()),
    );
  }
}
