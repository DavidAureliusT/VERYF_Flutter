import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veryf_app/static/static.dart';

class TabButtonWidget extends StatelessWidget {
  final String text;
  final int selectedPage;
  final int pageNumber;
  final VoidCallback onPressed;
  // ignore: prefer_const_constructors_in_immutables
  TabButtonWidget({
    Key? key,
    required this.text,
    required this.selectedPage,
    required this.pageNumber,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color:
              selectedPage == pageNumber ? primaryColor : primaryVariantColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 7.0,
          horizontal: 9.0,
        ),
        child: Text(
          text,
          style: GoogleFonts.zenKakuGothicAntique(
            textStyle: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: selectedPage == pageNumber
                  ? primaryVariantColor
                  : primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
