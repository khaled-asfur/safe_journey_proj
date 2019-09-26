import "package:flutter/material.dart";
import '../models/auth.dart';

class SignupPage extends StatefulWidget {
  //TODO: add user data to firebase
  @override
  State<StatefulWidget> createState() {
    return SignupPageState();
  }
}

class SignupPageState extends State<SignupPage> {
  final Map<String, dynamic> _formData={
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
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            padding: EdgeInsets.all(10),
            children: <Widget>[
              SizedBox(
                height: 0.1 * deviceHeight,
              ),
              _buildNameTextField(),
              SizedBox(
                height: 10,
              ),
              _buildPhoneTextField(),
              SizedBox(
                height: 10,
              ),
              _buildEmailTextField(),
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
              //TODO:add choose image button
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
      initialValue: "Ahmad awwad",
      decoration: InputDecoration(
        labelText: "Name",
        filled: true,
        fillColor: Colors.blueGrey[50],
      ),
      validator: (String value) {
        //بستقبل بس حروف عربي وانجليزي وسبيسز 
        if (value.length < 4 || !RegExp('^[\\s\\u0600-\\u065F\\u066A-\\u06EF\\u06FA-\\u06FFa-zA-Z]+[\\u0600-\\u065F\\u066A-\\u06EF\\u06FA-\\u06FFa-zA-Z-_]*\$').hasMatch(value)) return "Please enter your full name";
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
      initialValue: "0597458621",
      decoration: InputDecoration(
        labelText: "Phone number",
        filled: true,
        fillColor: Colors.blueGrey[50],
      ),
      validator: (String value) {
        if (value.length != 10) return "Please enter a valid phone number";
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
      initialValue: "family_safe@hotmail.com",
      decoration: InputDecoration(
        
        labelText: "Email",
        filled: true,
        fillColor: Colors.blueGrey[50],
      ),
      validator: (String value) {
        if (value.length < 5 ||
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
        fillColor: Colors.blueGrey[50],
      ),
      keyboardType: TextInputType.text,
     /* onChanged:(String val){
        _formData["password"]=val;//لاني بفحص قيمة هذا الفاريابل في كونفيرم باسسورد
      },*/
      obscureText: true, //يخفي الاحرف لانها باسسوورد
      validator: (String value) {
        _formData["password"] = value;
        if (value.length < 5)
          return "Passwords value must be 5+ characters";
        return null;
      },
      onSaved: (String value) {
        _formData["password"] = value;
      },
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return TextFormField(
      initialValue: "123456",
      decoration: InputDecoration(
        labelText: "Confirm password",
        filled: true,
        fillColor: Colors.blueGrey[50],
      ),

      validator: (String value) {
        print('value= $value & form data= ${_formData["password"]}');
        if (value != _formData["password"])
          return "This doesn't equal password's value ";
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
    if (_formKey.currentState.validate() != true) return;
    _formKey.currentState.save();
    //Navigator.pushReplacementNamed(context, "homePage");
    Auth().signup(_formData['email'],_formData['password'],context);
  }

}
