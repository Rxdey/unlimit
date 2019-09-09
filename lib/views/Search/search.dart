import 'package:flutter/material.dart';
import 'package:unlimit/components/baseContainer.dart';
import 'package:unlimit/components/iconfont.dart';
import 'package:unlimit/model/model.dart';
import 'package:unlimit/components/cartoonCard.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin {
  final Color color = Colors.redAccent;
  bool loading = false;
  String loadText = '没有了';
  List resultList;
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BaseContainer(
        color: color, header: searchInput(), child: searcResultList());
  }

  Future<void> _handleSearch(val) async {
    if (val == null || loading) return;
    var data = {'start': val};
    setState(() {
      loading = true;
      loadText = '加载中...';
    });
    ResponseData res = ResponseData.fromJson(await Model.search(data));
    setState(() {
      loading = false;
      loadText = '没有了';
    });
    if (res.state == 0) return;
    setState(() {
      resultList = res.data;
    });
  }

  Widget searcResultList() {
    return Scrollbar(
        child: resultList != null && !loading
            ? ListView.builder(
                padding: EdgeInsets.all(5.0),
                itemCount: resultList.length,
                itemBuilder: (context, idx) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: CartoonCard(
                        data: resultList[idx],
                        onTap: () {
                          print(resultList[idx]['id']);
                        }),
                  );
                })
            : Text(loadText,
                style: TextStyle(height: 10, color: Colors.black45)));
  }

  Widget searchInput() {
    return Container(
      color: color,
      padding: EdgeInsets.all(15.0),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(50)),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10, left: 10, bottom: 4),
                child: Icon(
                  IconFont.sousuo,
                  size: 18,
                ),
              ),
              Expanded(
                flex: 1,
                child: TextField(
                  textInputAction: TextInputAction.search,
                  onSubmitted: _handleSearch,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                      hintText: '从这里开始搜索吧', border: InputBorder.none),
                ),
              )
            ],
          )),
    );
  }
}
