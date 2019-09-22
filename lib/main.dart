import 'package:flutter/material.dart';
import 'package:safe_journey/pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/signup_page.dart';

void main() => runApp(MyApp());
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
        '/': (BuildContext context) => LoginPage(),
       // '/': (BuildContext context) => AuthPage(),
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
