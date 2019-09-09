import 'package:flutter/material.dart';
import 'package:unlimit/components/iconfont.dart';
import 'package:unlimit/views/Subscription/subscription.dart';
import 'package:unlimit/views/User/user.dart';
import 'package:unlimit/views/Search/search.dart';
import 'package:unlimit/public/public.dart' show TabList;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<TabList> tabs = [
    TabList(name: '订阅', key: 'sub', icon: Icon(IconFont.wenjian), page: SafeArea(child: Subscription(),)),
    TabList(name: '搜索', key: 'search', icon: Icon(IconFont.sousuo), page: Search()),
    TabList(name: '我的', key: 'user', icon: Icon(IconFont.wode), page: User()),
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   _tabController = TabController(length: tabs.length, vsync: this);
  // }
  int _navIndex = 0;
  void handleNavChange(index) {
    setState(() {
      _navIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: tabs[_navIndex].page,
        bottomNavigationBar: navigationBar());
  }

  Widget navigationBar() {
    return SafeArea(
      child: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: handleNavChange,
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        iconSize: 18.0,
        selectedItemColor: Colors.redAccent,
        items: tabs
            .map((item) => BottomNavigationBarItem(
                icon: item.icon, title: Text(item.name)))
            .toList(),
      ),
    );
  }
}
