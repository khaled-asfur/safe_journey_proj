import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/signup_page.dart';
import 'package:flutter/rendering.dart';
//from web
void main(){
  //debugPaintSizeEnabled =true;
   runApp(MyApp());
}

//from vs
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe journey',
      theme: ThemeData(
          primaryColor: Colors.deepOrange,
          accentColor: Colors.purple,
      ),
      routes: {
        '/': (BuildContext context) =>HomePage() /*LoginPage()*/,
       //'/': (BuildContext context) => AuthPage(),
        'homePage': (BuildContext context) => HomePage(),
        'signupPage': (BuildContext context) => SignupPage(),
      },

      // لما ادخل رابط خطأ شو يعمل
      onUnknownRoute: (RouteSettings settings) {
        //هيك بروح عالصفحة الرئيسية
        return MaterialPageRoute(builder: (BuildContext context) => HomePage());
      },
    );
  }
}
