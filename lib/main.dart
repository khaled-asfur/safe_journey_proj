import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/signup_page.dart';
import 'pages/show_journey.dart';
import 'pages/notifications.dart';
import 'pages/waiting_page.dart';
// import 'models/auth.dart';
//import 'package:flutter/rendering.dart';
void main(){
  //debugPaintSizeEnabled =true;
   runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
      
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Safe journey',
      theme: ThemeData(
        //0x .. FF: for full obacity .. 197278: hexadecimal number for the color
          primaryColor: Color(0xFF197278),
          accentColor: Color(0xffAB1717),
      ),
      routes: {
        //TODO:check if the user is logged in to determin main page
        '/': (BuildContext context) =>WaitingPage(),
       //'/': (BuildContext context) => AuthPage(),
        'homePage': (BuildContext context) => HomePage(),
        'loginPage': (BuildContext context) => LoginPage(),
        'signupPage': (BuildContext context) => SignupPage(),
        'notifications': (BuildContext context) => Notifications(),
      },
      onGenerateRoute: (RouteSettings settings) {
          //هون بضيف نيمد راوت جديدة شرط ما تكون موجودة فوق بالبروبرتي روتس
          List<String> pathElements = settings.name.split('/');
          // كاني ضفت نيمد راوت هيك  /showJourney/name اندكس هي رقم
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'showJourney') {
            String journeyName = pathElements[2];
            return MaterialPageRoute<bool>(
                builder: (BuildContext context) =>ShowJourney(journeyName));
          }
          return null;
        },

      // لما ادخل رابط خطأ شو يعمل
      onUnknownRoute: (RouteSettings settings) {
        //هيك بروح عالصفحة الرئيسية
        return MaterialPageRoute(builder: (BuildContext context) => HomePage());
      },
    );
  }
}
