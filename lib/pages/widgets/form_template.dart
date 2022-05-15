import 'package:merenda_escolar/colors.dart';
import 'package:flutter/material.dart';

class FormTemplate extends StatelessWidget {
  final String title;
  final Widget form;

  FormTemplate(this.title, this.form);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cinza_background,
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: ListView(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 22, color: AppColors.blue),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: form,
          )
        ],
      ),
    );
  }
}
