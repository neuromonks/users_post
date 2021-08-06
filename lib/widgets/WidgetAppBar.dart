import 'package:flutter/material.dart';
import 'package:users_post/theme/ThemeColor.dart';

class WidgetAppBar extends StatefulWidget with PreferredSizeWidget {
  String title;
  List<Widget> listWidgets;
  WidgetAppBar({@required this.title, this.listWidgets});
  @override
  _WidgetAppBarState createState() => _WidgetAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _WidgetAppBarState extends State<WidgetAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0.0,
      elevation: 0.5,
      backgroundColor: ThemeColor.darkPink,
      centerTitle: true,
      leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 22,
          )),
      title: Text(
        '${widget.title}',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      actions: widget.listWidgets != null ? widget.listWidgets : [],
    );
  }
}
