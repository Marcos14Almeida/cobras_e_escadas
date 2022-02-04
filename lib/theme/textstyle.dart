import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class EstiloTextoBranco {
  static const TextStyle text34 = TextStyle(
    fontFamily: 'Roboto',
    color: Colors.white,
    fontSize: 34,
  );
  static const TextStyle text20 = TextStyle(
    fontFamily: 'Roboto',
    color: Colors.white,
    fontSize: 20,
  );
}

abstract class EstiloTextoPreto {
  static const TextStyle text22 = TextStyle(
    fontFamily: 'Roboto',
    color: Colors.black,
    fontSize: 22,
  );
  static const TextStyle text16 = TextStyle(
    fontFamily: 'Roboto',
    color: Colors.black,
    fontSize: 16,
  );
}

abstract class EstiloTexto {
  static TextStyle titulo = GoogleFonts.wendyOne(
      textStyle: const TextStyle(
        fontSize: 40,
        color: Colors.purple,
      ),
  );
  static TextStyle borda = GoogleFonts.wendyOne(
    textStyle: TextStyle(
      fontSize: 40,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.green,
    ),
  );
  static TextStyle vitoria = GoogleFonts.wendyOne(
    textStyle: const TextStyle(
      fontSize: 40,
      color: Colors.white,
    ),
  );
}