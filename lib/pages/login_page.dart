//import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/widgets/my_raised_button.dart';
import '../models/auth.dart';
import 'package:rxdart/subjects.dart' as rx ;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}


class LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final Map<String, dynamic> _formData = {
    "email": null,
    "password": null,
  };

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('login page build');
    _setlodingObservable();
    return Scaffold(
      appBar: new AppBar(
        title: Text("Login page"),
      ),
      body: Container(
        decoration: BoxDecoration(image: _buildBackground()),
        padding: EdgeInsets.all(10.0),
        child: Center(
          //ScrollView هاي نفس السكرول فيو بس ما بتوخذ كل طول الصفحة وبتوخذ بس تشايلد واحد
          child: SingleChildScrollView(
            child: Container(
              // width: targetWidth,
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    _buildEmailTextField(),
                    SizedBox(height: 10.0),
                    _buildPasswordTextField(),
                    SizedBox(height: 10.0),
                    MyRaisedButton(
                        "Login",
                        _isLoading
                            ? null
                            : () {
                                _submitForm(context);
                                setState(() {
                                  _isLoading=true;
                                });
                              }),
                   _isLoading?Center(child:CircularProgressIndicator()):FlatButton(
                      child: Text(
                        "swith to signup page",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "signupPage");
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  _setlodingObservable(){
    Global.loadingObservable=rx.PublishSubject<bool>();
    Global.loadingObservable.listen((bool value) {
     if (this.mounted) {//if this page is opened now(still in the widget tree)
        setState(() {
          _isLoading=value;
        });
      }
    });
  }

  DecorationImage _buildBackground() {
    return DecorationImage(
      fit: BoxFit.cover,
      image: AssetImage("images/background.jpg"),
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      initialValue: "family_safe@hotmail.com",
      decoration: InputDecoration(
        labelText: "Email",
        filled: true,
        fillColor: Color(0xAAD8D5D3),
        enabledBorder: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(10.0),
          borderSide: new BorderSide(color: Colors.white),
        ),
      ),
      validator: (String value) {
        if (value.isEmpty ||
            value.length < 5 ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) //هاي جاهزة لفحص اذا كان ايميل او لا
          return "please enter a valid email!";
        return null; //لما يرجع نل معناها ما في مشكلة
      },
      keyboardType: TextInputType.emailAddress,
      onSaved: (String value) {
        _formData["email"] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      initialValue: "123456",
      decoration: InputDecoration(
          labelText: "Password",
          filled: true,
          fillColor: Color(0xAAD8D5D3),
          enabledBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(10.0),
            borderSide: new BorderSide(color: Colors.white),
          )),

      validator: (String value) {
        if (value.isEmpty || value.length < 5)
          return "Passwords value must be 5+ characters";
        return null;
      },
      keyboardType: TextInputType.text,
      obscureText: true, //يخفي الاحرف لانها باسسوورد
      onSaved: (String value) {
        _formData["password"] = value;
      },
    );
  }

  void _submitForm(BuildContext context) {
    if (formKey.currentState.validate() != true) return;
    formKey.currentState.save();
    //Navigator.pushReplacementNamed(context, 'homePage');
    new Auth().login(_formData['email'], _formData['password'], context);
  }
}
