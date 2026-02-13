import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ummy_app/features/workshop/presentation/pages/splash_page.dart'; 


class WorkshopApp extends StatelessWidget {
 const WorkshopApp({super.key});


 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     debugShowCheckedModeBanner: false,
     title: 'Workshop Flutter & Cyber Security',
     //theme data untuk thema aplikasi secara keseluruhan
     theme: ThemeData(
       useMaterial3: true,
       colorScheme: ColorScheme.fromSeed(
         seedColor: const Color.fromARGB(255, 201, 47, 20),
         brightness: Brightness.light,
       ),
       textTheme: GoogleFonts.spaceGroteskTextTheme(),
       scaffoldBackgroundColor: const Color(0xFFF4F7FE),
     ),
     home: const SplashPage(),
   );
 }
}
