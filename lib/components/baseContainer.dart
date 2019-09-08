import 'package:flutter/material.dart';
import 'package:unlimit/components/iconfont.dart';

class BaseContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double stateBarHeight = MediaQuery.of(context).padding.top;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: double.infinity,
      ),
      child: Container(
        
      )
    );
  }
}
