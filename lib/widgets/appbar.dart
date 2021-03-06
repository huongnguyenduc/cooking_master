import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar buildAppBar(BuildContext context,
    {String title, List<Widget> actions, Widget leading, Widget bottom}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    title: Text(
      title,
      style: GoogleFonts.roboto(color: Colors.black, fontSize: 18),
    ),
    leading: leading,
    actions: actions,
    bottom: bottom,
  );
}
