import 'package:flutter/material.dart';
import 'package:unlimit/components/baseContainer.dart';
import 'package:unlimit/components/iconfont.dart';
import 'package:unlimit/util/util.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Cell {
  String label;
  String value;
  Icon icon;
  bool arrow;
  double margin;
  Function onClick;
  Cell({this.label = '', this.value = '', this.icon, this.arrow = true, this.margin = 0, this.onClick});
}

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  List<Cell> cellList = [
    Cell(label: '修改资料'),
    Cell(
        label: '清空缓存',
        onClick: () async {
          bool isClear = await clearAll();
          Fluttertoast.showToast(msg: isClear ? '缓存已清空' : '清空失败', textColor: Colors.white, gravity: ToastGravity.CENTER);
        }),
    Cell(label: '设置'),
    Cell(label: '退出登录', arrow: false, margin: 10.0)
  ];

  Widget cellWidget(Cell cell) {
    return Container(
      margin: EdgeInsets.only(top: cell.margin),
      child: Material(
          color: Colors.white,
          child: Ink(
              child: InkWell(
            onTap: cell.onClick,
            child: Container(
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: .2, color: Colors.black26), top: cell.margin != 0 ? BorderSide(width: .2, color: Colors.black26) : BorderSide.none),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text(cell.label),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(cell.value),
                        Container(
                          child: cell.arrow
                              ? Icon(
                                  IconFont.gengduo,
                                  color: Colors.black54,
                                  size: 14.0,
                                )
                              : cell.icon,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      background: Color(0XF7F7F7),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Material(
              color: Colors.white,
              child: Ink(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 50.0, bottom: 30.0),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(width: .2, color: Colors.black26))),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 15.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(color: Colors.black87)
                              ]),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'lib/assets/image/v.png',
                                image: 'http://ww1.sinaimg.cn/large/005O2C54gy1g6u7h0jzyhj308r08nmyq.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Text('洞洞洞洞洞', style: TextStyle(color: Colors.black87, fontSize: 18.0, height: 1.2)),
                        ),
                        Container(
                          child: Text('账号: jyh1994@qq.com', style: TextStyle(color: Colors.black45, fontSize: 12.0, height: 1.5)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(border: Border(top: BorderSide(width: .2, color: Colors.black26))),
              child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: cellList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return cellWidget(cellList[index]);
                  }),
            ),
          )
        ],
      ),
    );
  }
}
