import 'package:flutter/material.dart';
// import 'package:unlimit/components/iconfont.dart';

class BaseContainer extends StatelessWidget {
  final Widget child;
  final Widget header;
  final Color color;
  final Color background;
  BaseContainer(
      {Key key,
      this.child,
      this.color,
      this.header,
      this.background = Colors.white})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double stateBarH = MediaQuery.of(context).padding.top; // 获取标题栏高度
    return Scaffold(
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: double.infinity,
        ),
        child: Container(
          color: background,
          child: Column(
            children: <Widget>[
              Container(
                color: color,
                padding: EdgeInsets.only(top: stateBarH),
                child: header,
              ),
              Expanded(flex: 1, child: child)
            ],
          ),
        ),
      ),
    );
  }
}
