import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildTheme(context, brightness) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color.fromRGBO(13, 129, 65, 1),
      primary: Color.fromRGBO(13, 129, 65, 1),

      brightness: brightness,
    ),
    scaffoldBackgroundColor: Color.fromRGBO(239, 246, 238, 1),
    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.white,
      backgroundColor: Color.fromRGBO(13, 129, 65, 1),

      elevation: 1,
    ),
    pageTransitionsTheme: PageTransitionsTheme(),
    textTheme: GoogleFonts.poppinsTextTheme(),
  );
}
