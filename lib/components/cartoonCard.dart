import 'package:flutter/material.dart';

class CartoonCard extends StatelessWidget {
  final Map data;
  final Function onTap;
  CartoonCard({this.data, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: 85,
              height: 110,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: FadeInImage.assetNetwork(
                  placeholder: 'lib/assets/image/default.png',
                  image: data['cover'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 110,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0, top: 4.0),
                      child: Text(
                        data['name'].toString().trim(),
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black87, height: 1.3, fontSize: 16.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '作者: ' + data['author'].toString().trim(),
                      maxLines: 1,
                      style: TextStyle(
                        height: 1.3,
                        fontSize: 14.0,
                        color: Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      data['type'].join(' ').toString().trim(),
                      maxLines: 1,
                      style: TextStyle(
                        height: 1.3,
                        fontSize: 14.0,
                        color: Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 7.0),
                      child: Text(
                      '连载至: ' + data['chapter'].toString().trim(),
                      maxLines: 1,
                      style: TextStyle(
                        height: 1.3,
                        color: Colors.red[300],
                        fontSize: 14.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    )
                    // Text(
                    //   data['date'],
                    //   maxLines: 1,
                    //   style: TextStyle(height: 1.3, color: Colors.black54),
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
