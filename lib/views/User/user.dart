import 'package:flutter/material.dart';
import 'package:unlimit/components/baseContainer.dart';

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      child: Container(
        child: Text('我的'),
      ),
    );
  }
}
