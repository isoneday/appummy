import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ummy_app/features/workshop/presentation/pages/workshop_home_page.dart';

class SplashPage extends StatefulWidget {
 const SplashPage({Key? key}) : super(key: key);


 @override
 _SplashPageState createState() => _SplashPageState();
}


class _SplashPageState extends State<SplashPage> {
 //method yang pertama x dijalankan ketika mengakses suatu halaman dengan widget statefullwidget
 @override
 void initState() {
   // TODO: implement initState
   super.initState();
   setLoading();
 }


 @override
 Widget build(BuildContext context) {
   return Scaffold(
     body: Center(
         child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         Image.asset(
           "assets/image/ummy.png",
          //  color: Colors.red,
           width: 200,
           height: 200,
         ),
         const Padding(
           padding: EdgeInsets.only(top: 20),
           child: Text(
             "Ummy App",
             style: TextStyle(
                 fontSize: 35,
                 color: Colors.red,
                 fontWeight: FontWeight.bold,
                 fontFamily: "batmfo__"),
           ),
         ),
         const SizedBox(
           height: 200,
         ),
         const CircularProgressIndicator(
           color: Colors.red,
         )
       ],
     )),
   );
 }


 setLoading() {
   var duration = const Duration(seconds: 5);
   return Timer(duration, () async {
    //perpindahan halaman dari splashpage ke halaman home
       Navigator.pushReplacement(
           context, MaterialPageRoute(builder: (context) => WorkshopHomePage()));
 
   });
 }
}
