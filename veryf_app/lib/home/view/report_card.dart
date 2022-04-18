// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veryf_app/static/static.dart';

class ReportCard extends StatelessWidget {
  final Image image;
  final String invoice_number;
  const ReportCard({
    Key? key,
    required this.image,
    required this.invoice_number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        image: DecorationImage(fit: BoxFit.fill, image: image.image),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 200, 100, 10),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 7.0,
          horizontal: 9.0,
        ),
        child: Text(
          invoice_number,
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: blackColor,
            ),
          ),
        ),
      ),
    );
  }
}
