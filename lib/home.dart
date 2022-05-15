

import 'package:flutter/material.dart';
import 'package:merenda_escolar/colors.dart';
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:merenda_escolar/web/body.dart';
import 'package:merenda_escolar/web/header.dart';
import 'package:merenda_escolar/web/menu.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Size get size => MediaQuery.of(context).size;

  bool get showMenu => size.width > 760;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: Column(
          children: <Widget>[
            _header(),
            _body(),
          ],
        ),
      ),
    );
  }

  _header() {
    return Container(
      padding: EdgeInsets.all(16),
      width: size.width,
      height: headerHeight,
      color: AppColors.blue,
      child: Header(),
    );
  }

  _body() {
    return Container(
      width: size.width,
      height: size.height - headerHeight,
      child: showMenu
          ? Row(
              children: <Widget>[
                _menu(),
                _right(),
              ],
            )
          : _right(),
    );
  }

  _menu() {
    return Container(
      width: menuWidth,
      color: Colors.grey[100],
      child: Menu(),
    );
  }

  _right() {
    return Container(
      padding: EdgeInsets.all(16),
      width: showMenu ? size.width - menuWidth : size.width,
      child: Body(),
//      child: Column(
//        children: <Widget>[
//          Container(
//            color: Colors.grey[100],
//            width: size.width,
//            height: 60,
//            child: BreadCrumb(),
//          ),
//          Expanded(
//            child: Body(),
//          ),
//        ],
//      ),
    );
  }
}
