import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BreadCrumb extends StatefulWidget {
  final Widget child;
  final List<Widget> actions;

  BreadCrumb({@required this.child, this.actions});

  @override
  _BreadCrumbState createState() => _BreadCrumbState();
}

class _BreadCrumbState extends State<BreadCrumb> {
  @override
  Widget build(BuildContext context) {
    PagesModel app = Provider.of<PagesModel>(context);

    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          color: Colors.grey[100],
//            width: size.width,
          height: 60,
          child: _listView(app),
        ),
        Expanded(
          child: widget.child,
        ),
      ],
    );
  }

  _listView(PagesModel app) {
    return LayoutBuilder(
      builder: (context, constraints) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ListView.builder(
            itemCount: app.pages.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              PageInfo info = app.pages[index];

              return InkWell(
                onTap: () => _onClickPage(index),
                child: Row(
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints.expand(width: 32),
                      child: Icon(
                        index == 0
                            ? FontAwesomeIcons.home
                            : FontAwesomeIcons.chevronRight,
                        color: AppColors.blue,
                      ),
                    ),
                    Text(
                      info.title,
                      style: TextStyle(fontSize: 15,),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              );
            },
          ),
          // Actions na direita
          widget.actions != null
              ? Row(
                  children: widget.actions,
                )
              : Container()
        ],
      ),
    );
  }

  _onClickPage(int index) {
    PagesModel app = Provider.of<PagesModel>(context);

    if (index == 0) {
      app.popAll();
    } else {
      app.popTo(index);
    }
  }
}
/* js.context['pdfData'] = base64.encode(bytes);
    js.context['filename'] = 'Output.pdf';
    Timer.run(() {
      js.context.callMethod('download');
    });

 */