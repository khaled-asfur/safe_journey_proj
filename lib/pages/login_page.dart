import "package:flutter/material.dart";

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
  final Map<String, dynamic> pageContext = {
    "pageContext": null,
    'loginFormKey':GlobalKey<FormState>(),
  };
  

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
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
                key: pageContext['loginFormKey'],
                child: Column(
                  children: <Widget>[
                    _buildEmailTextField(),
                    SizedBox(height: 10.0),
                    _buildPasswordTextField(),
                    SizedBox(height: 10.0),
                    RaisedButton(
                        child: Text("Login"),
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                        onPressed: _submitForm),
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
      initialValue: "family@hotmail.com",
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
      initialValue: "123456789",
      decoration: InputDecoration(
        labelText: "Password",
        filled: true,
        fillColor: Colors.white,
      ),

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

  void _submitForm() {
    if (pageContext['loginFormKey'].currentState.validate() != true) return;
    pageContext['loginFormKey'].currentState.save();
    Navigator.pushReplacementNamed(context, 'homePage');
    pageContext['loginFormKey']=null;
  }
  
}
/*      showDialog(
          context: pageContext,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("An error occured"),
              content: Text("logged in successfully"),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pushReplacementNamed(pageContext, "/");
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });*/
