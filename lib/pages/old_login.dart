//auth.dart
// import 'package:first_app/scoped_models/scoped_main.dart';
import "package:flutter/material.dart";
// import 'package:scoped_model/scoped_model.dart';

// import '../models/auth.dart';
class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AuthPageState();
  }
}

class AuthPageState extends State<AuthPage> {
  TextEditingController _passwordTextController = TextEditingController();
  Map<String, dynamic> _formData = {
    "email": null,
    "password": null,
    "acceptTerms": true
  };
  final Map<String, dynamic> pageContext = {
    "pageContext": null,
    'loginFormKey':GlobalKey<FormState>(),
  };
  @override
  void initState() {
    //_mod
    _passwordTextController.text = "123456789";
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    print("in auth page");
    pageContext['pageContext'] = context;
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
            //ScrollView هاي نفس السكرول فيو بس ما بتوخذ كل طول الصفحة وبتوخذ بس شايلد واحد
            child: SingleChildScrollView(
              child: Container(
                // width: targetWidth,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _buildEmailTextField(),
                      SizedBox(height: 10.0),
                      _buildPasswordTextField(),
                      SizedBox(height: 10.0),
                      //في السويتش لازم احددله انه لما تتغير قيمته بالضغط عليه شو تصير قيمته ترو او فولس لاااازم
                      _buildSwitch(),
                      SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(height: 10.0),

                      RaisedButton(
                        child: Text("Login"),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () => _submitForm(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  DecorationImage _buildBackground() {
    return DecorationImage(
      fit: BoxFit.cover,
      image: AssetImage("images/background.jpg"),
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      initialValue: "khalid@hotmail.com",
      decoration: InputDecoration(
        labelText: "Email",
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (String value) {
        if (value.isEmpty ||
            value.length < 5 ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) //هاي جاهزة لفحص اذا كان ايميل او لا
          return "please enter a valid email!";
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      onSaved: (String value) {
        _formData["email"] = value;
      },
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return TextFormField(
      initialValue: "123456789",
      decoration: InputDecoration(
        labelText: "confirm password",
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (String value) {
        if (value !=
            _passwordTextController.text) //هاي جاهزة لفحص اذا كان ايميل او لا
          return "Passwords don't match.";
        return null;
      },
      //  obscureText: true,
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      controller: _passwordTextController,
      // initialValue: "123456789",
      decoration: InputDecoration(
        labelText: "Password",
        filled: true,
        fillColor: Colors.white,
      ),

      validator: (String value) {
        if (value.isEmpty || value.length < 5)
          return "Password mustn't be empty and it's value must be 5+";
        return null;
      },
      keyboardType: TextInputType.text,

      ///  obscureText: true, //يخفي الاحرف لانها باسسوورد
      onSaved: (String value) {
        _formData["password"] = value;
      },
    );
  }

  Widget _buildSwitch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SwitchListTile(
          value: _formData["acceptTerms"],
          onChanged: (bool value) {
            setState(() {
              _formData["acceptTerms"] = value;
            });
          },
          title: Text("Accept terms")),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState.validate() != true || !_formData["acceptTerms"])
      return;
    _formKey.currentState.save();
    Map<String, dynamic> successInformation;
    Navigator.pushReplacementNamed(pageContext['pageContext'], 'signupPage');
    /*if (_authMode == AuthMode.Login) {
      successInformation =
          await authenticate(_formData["email"], _formData["password"],AuthMode.Login);
    } else {
      successInformation =
          await authenticate(_formData["email"], _formData["password"],AuthMode.Signup);
    }
    if (successInformation['success'] == true) {
      Navigator.pushReplacementNamed(context, "/");
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("An error occured"),
              content: Text(successInformation['message']),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }*/
  }
}
