import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:paschaloliver/feature/splash/splash_view.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paschal Oliver',
      theme: ThemeData(
        useMaterial3: true,

        // ✅ Urbanist everywhere
        textTheme: GoogleFonts.urbanistTextTheme(
          ThemeData.light().textTheme,
        ),
        // optional (helps some widgets that rely on fontFamily)
        fontFamily: GoogleFonts.urbanist().fontFamily,

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
    );
  }
}
