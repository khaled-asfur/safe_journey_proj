import "package:flutter/material.dart";
//from vs
class SignupPage extends StatefulWidget {
  //from web
  @override
  State<StatefulWidget> createState() {
    return SignupPageState();
  }
}

class SignupPageState extends State<SignupPage> {
  

  final Map<String, dynamic> _formData = {
    "name": null,
    "phoneNumber": null,
    "email": null,
    "password": null,
    "confirm_password": null
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.width;
    print("in signup build");
    return Scaffold(
      appBar: new AppBar(
        title: Text("Signup page"),
      ),
      body: Form(
        //TODO: ضيف فورم كي
        
       key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            padding: EdgeInsets.all(10),
            children: <Widget>[
              SizedBox(
                height: 0.1*deviceHeight,
              ),
              _buildNameTextField(),
              SizedBox(
                height: 10,
              ),
              _buildPhoneTextField(),
              SizedBox(
                height: 10,
              ),
             /* _buildEmailTextField(),
              SizedBox(
                height: 10,
              ),
              _buildPasswordTextField(),
              SizedBox(
                height: 10,
              ),
              _buildConfirmPasswordTextField(),
              SizedBox(
                height: 10,
              ),
              _buildConfirmPasswordTextField(),
              SizedBox(
                height: 10,
              ),
              _buildConfirmPasswordTextField(),
              SizedBox(
                height: 10,
              ),
              _buildConfirmPasswordTextField(),
              SizedBox(
                height: 10,
              ),
              _buildConfirmPasswordTextField(),
              SizedBox(
                height: 10,
              ),*/
              RaisedButton(
                  child: Text("Signup"),
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  onPressed: _submitForm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Name",
        filled: true,
        fillColor: Colors.blueGrey[50],
      ),
      validator: (String value) {
        if (value.isEmpty || value.length < 4)
          return "name value must be 4+ characters";
        return null;
      },
      keyboardType: TextInputType.text,
      onSaved: (String value) {
        _formData["name"] = value;
      },
    );
  }

  Widget _buildPhoneTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Phone number",
        filled: true,
        fillColor: Colors.blueGrey[50],
      ),
      validator: (String value) {
        if (value.isEmpty || value.length != 10)
          return "Please enter a valid form number";
        return null;
      },
      keyboardType: TextInputType.phone,
      onSaved: (String value) {
        _formData["phoneNumber"] = value;
      },
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email",
        filled: true,
        fillColor: Colors.blueGrey[50],
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
      decoration: InputDecoration(
        labelText: "Password",
        filled: true,
        fillColor: Colors.blueGrey[50],
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

  Widget _buildConfirmPasswordTextField() {
    //TODO: تأكد انه الباسوورد والكونفيرم باسسورد الهن نفس القيمة
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Confirm password",
        filled: true,
        fillColor: Colors.blueGrey[50],
      ),

      validator: (String value) {
        if (value.isEmpty || value.length < 5)
          return "Passwords value must be 5+ characters";
        return null;
      },
      keyboardType: TextInputType.text,
      obscureText: true, //يخفي الاحرف لانها باسسوورد
      onSaved: (String value) {
        _formData["confirm_password"] = value;
      },
    );
  }

  void _submitForm() {
    //TODO:اعمل فاليديشن للفورم
    /*if (_formKey.currentState.validate() != true) return;
    _formKey.currentState.save();*/
    Navigator.pushReplacementNamed(context, "homePage");
  }
}
