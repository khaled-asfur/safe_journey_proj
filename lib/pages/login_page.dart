//import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import '../models/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final Map<String, dynamic> _formData = {
    "email": null,
    "password": null,
  };

  /*final Map<String, dynamic> pageContext = {
    "pageContext": null,
    'loginFormKey':GlobalKey<FormState>(),
  };*/

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // if (MediaQuery.of(context).orientation == Orientation.landscape)
    //   print("landscape");
    /* double deviceWidth = MediaQuery.of(context).size.width;

    final double targetWidth =
        deviceWidth > 550 ? deviceWidth * 0.7 : deviceWidth * 0.85;*/
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
                    RaisedButton(
                        child: Text("Login"),
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                        onPressed: () {
                          _submitForm(context);
                        }),
                    FlatButton(
                      child: Text(
                        "swith to signup page",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "signupPage");
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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