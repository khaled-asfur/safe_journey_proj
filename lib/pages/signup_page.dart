import 'dart:io';

import "package:flutter/material.dart";
import 'package:safe_journey/models/global.dart';
import '../models/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/subjects.dart' as rx ;

class SignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignupPageState();
  }
}

class SignupPageState extends State<SignupPage> {
  bool _isLoading=false;
  File sampleImage;
 
  final Map<String, dynamic> _formData = {
    "name": "",
    "phoneNumber": null,
    "email": null,
    "password": null,
    "confirm_password": null
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  initState(){
    //_setlodingObservable();
    super.initState();
  }
  Widget build(BuildContext context) {
    _setlodingObservable();
   print(_isLoading);
    double deviceHeight = MediaQuery.of(context).size.width;
   // print("in signup build");
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
              _buldChooseImageButton(),
             Center(
                child: sampleImage == null
                    ? Text("")
                    : Container(
        
        width: 140.0,
        height: 140.0,
        //color: Color(0xffAB1717),
        decoration: BoxDecoration(
          image: DecorationImage(
            image:FileImage(
                        sampleImage,
                      ) ,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 10.0,
          ),
        ),
      )
                    
              ),
               SizedBox(
                height: 10,
              ),
              _buildSignupButton(),
              Center(child:_isLoading==true?CircularProgressIndicator():Container() ,)
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameTextField() {
    return TextFormField(
      initialValue: _formData["name"],
      decoration: InputDecoration(
        labelText: "Name",
        filled: true,
        fillColor: Color(0xAAB0BEC5),
        enabledBorder: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(10.0),
          borderSide: new BorderSide(color: Colors.white),
        ),
      ),
      validator: (String value) {
        //بستقبل بس حروف عربي وانجليزي وسبيسز
        if (value.length < 4 ||
            !RegExp('^[\\s\\u0600-\\u065F\\u066A-\\u06EF\\u06FA-\\u06FFa-zA-Z]+[\\u0600-\\u065F\\u066A-\\u06EF\\u06FA-\\u06FFa-zA-Z-_]*\$')
                .hasMatch(value)) return "Please enter your full name";
        return null;
      },
      keyboardType: TextInputType.text,
      onChanged: (String value) {
        _formData["name"] = value;
      },
    );
  }

  Widget _buildPhoneTextField() {
    return TextFormField(
     // initialValue: "0597458621",
      decoration: InputDecoration(
        labelText: "Phone number",
        filled: true,
        fillColor: Color(0xAAB0BEC5),
        enabledBorder: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(10.0),
          borderSide: new BorderSide(color: Colors.white),
        ),
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
    // initialValue: "family_safe@hotmail.com",
      decoration: InputDecoration(
        labelText: "Email",
        filled: true,
        fillColor: Color(0xAAB0BEC5),
        enabledBorder: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(10.0),
          borderSide: new BorderSide(color: Colors.white),
        ),
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
     // initialValue: "123456",
      decoration: InputDecoration(
        labelText: "Password",
        filled: true,
        fillColor: Color(0xAAB0BEC5),
        enabledBorder: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(10.0),
          borderSide: new BorderSide(color: Colors.white),
        ),
      ),
      keyboardType: TextInputType.text,
      obscureText: true, //يخفي الاحرف لانها باسسوورد
      validator: (String value) {
        _formData["password"] = value;
        if (value.length < 5) return "Passwords value must be 5+ characters";
        return null;
      },
      onSaved: (String value) {
        _formData["password"] = value;
      },
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return TextFormField(
     // initialValue: "123456",
      decoration: InputDecoration(
        labelText: "Confirm password",
        filled: true,
        fillColor: Color(0xAAB0BEC5),
        enabledBorder: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(10.0),
          borderSide: new BorderSide(color: Colors.white),
        ),
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

  Widget _buldChooseImageButton() {
    return Center(
     // padding: EdgeInsets.only(right: 50.0),
     // alignment: Alignment.centerLeft,
      child: ButtonTheme(
  child:FlatButton.icon(
                      icon: Icon(
                        Icons.add_photo_alternate,
                        color: Color(0xFF197278),
                      ),
                      label: Text("choose profile Picture "),
                      onPressed:getImage)
  
  /*RaisedButton(
          child: Row(children: <Widget>[
            Text("Choose profile image "),
            Icon(Icons.add_photo_alternate)
          ]),
          color: Color(0xFF197278),
          textColor: Colors.white,
          onPressed: getImage)*/,),
    );
  }

  void _submitForm() {
    if (_formKey.currentState.validate() != true){
     Global.loadingObservable.add(false);
      return;

    } 
    _formKey.currentState.save();
    Auth().signup(
        _formData['name'],_formData['phoneNumber'],_formData['email'], _formData['password'], context, sampleImage);
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = image;
    });
  }

  Widget showImage() {
    return Column(
      children: <Widget>[
        RaisedButton(
            child: Text("upload image"),
            color: Colors.grey,
            textColor: Colors.white,
            onPressed: () async {
              final StorageReference storageRef =
                  FirebaseStorage.instance.ref().child('new pic');
              /*final StorageUploadTask task = */storageRef.putFile(sampleImage);
            //  print(task);
            }),
      ],
    );
  }

  Widget _buildSignupButton() {
    return  Center(
      child:SizedBox(
         width: 150.0,
                      height: 50.0,
    child:  RaisedButton(
        child: Text("Signup"),
        color: Color(0xFF197278),
        textColor: Colors.white,
        onPressed:_isLoading?null :(){
          _submitForm();
          setState(() {
            _isLoading=true;
          });
          })));
  }
    _setlodingObservable(){
    Global.loadingObservable=rx.PublishSubject<bool>();
    Global.loadingObservable.listen((bool value) {
     if (this.mounted) {//if this page is  opened now(still in the widget tree)
        setState(() {
          _isLoading=value;
          print('from observable $_isLoading');
        });
      }
    });
  }
}
