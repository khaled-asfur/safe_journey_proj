import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:safe_journey/models/auth.dart';
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/models/user.dart';

class ChangePass extends StatefulWidget {
  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Change password",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //0x .. FF: for full obacity .. 197278: hexadecimal number for the color
        primaryColor: Color(0xFF197278),
        accentColor: Color(0xffAB1717),
      ),
      home: Editpass(),
    );
  }
}

class Editpass extends StatefulWidget {
  @override
  _EditpassState createState() => _EditpassState();
}

var emailuser;

class _EditpassState extends State<Editpass> {
  final databaseReference = Firestore.instance;

  Future<void> fillUserData() async {
    User user = Global.user;
    // print(doc.data['name']);
    // print(user);
    databaseReference
        .collection("users")
        .document(user.id)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        // print(doc.data);
        setState(() {
          emailuser = user.email;
        });
      }
    });
  }

  @override
  void initState() {
    fillUserData();
    super.initState();
  }

  var currentpassController = new TextEditingController();
  var currentpassController1 = new TextEditingController();

  var newpassController = new TextEditingController();
  var newemailController = new TextEditingController();
  final Map<String, dynamic> _formData = {
    "name": null,
    "phoneNumber": null,
    "email": null,
    "password": null,
    "confirm_password": null
  };
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
        final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
bool cnewpass=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(),
      body:  
        Container(
          
               // key: _formKey,

      child:  ListView(children: <Widget>[
        SizedBox(height: 15.0),
        //******************************************************* */
        Form(
                    key: _formKey,

          child:new Column(
          children:[ 
        new ListTile(
          title: new TextFormField(
            controller: currentpassController,
            decoration: new InputDecoration(
                labelText: "Current Password",
                labelStyle: TextStyle(
                    fontFamily: "Caveat",
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
                suffixIcon:
                    IconButton(icon: Icon(Icons.cancel), onPressed: () {
                      currentpassController.clear();
                    }),
                ),
            obscureText: true,
                   validator: (String value) {
        _formData["password"] = value;
        if(value.isEmpty){return " current passwoed must be enter";}
      else  if (value.length < 5){return "Passwords value must be 5+ characters";}
        
        else return null;
      },
      onSaved: (String value) {
        _formData["password"] = value;
      },
            
          ),
        ),
        //***************************************************************** */
        SizedBox(height: 15.0),

        new ListTile(
          title: new TextFormField(
            controller: newpassController,
            decoration: new InputDecoration(
                labelText: "new Password",
                labelStyle: TextStyle(
                    fontFamily: "Caveat",
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
                suffixIcon:
                    IconButton(icon: Icon(Icons.cancel), onPressed: () {
                      newpassController.clear();
                    }),
                    
                    ),
            obscureText: true,
            validator: (String value) {
        _formData["password"] = value;
        if(value.isEmpty){return " new passwoed must be enter";}
      else  if (value.length < 5){return "Passwords value must be 5+ characters";}
        
        else return null;
      },
      onSaved: (String value) {
        _formData["password"] = value;
      },
          ),
        ),
        //***************************************************************** */
        new FlatButton.icon(
            icon: Icon(
              Icons.vpn_key,
              color: Colors.blueAccent,
            ),
            label: Text("Change passsword "),
            onPressed: () {
              
                 if (_formKey.currentState.validate() != true) return;
    _formKey.currentState.save();
    
              if (currentpassController.text.isEmpty ||
                  newpassController.text.isEmpty) {
                _onAlertButtonPressed1(context);
              } else {
                new Auth()
                    .cheak(emailuser, currentpassController.text, context)
                    .then((bool result) {
                  if (result == true) {
                    setState(() async {
                      FirebaseUser user =
                          await FirebaseAuth.instance.currentUser();

                      user.updatePassword(newpassController.text);
                    });
                  }else {cnewpass=false;}
                });
              }
            }),])),
        SizedBox(height: 15.0),
        //******************************************************************************* */
       
       Form( 
                             key: _formKey1,

         child:new Column(
           children:[
        new ListTile(
          title: new TextFormField(
            controller: newemailController,
            decoration: new InputDecoration(
                labelText: "new Email",
                labelStyle: TextStyle(
                    fontFamily: "Caveat",
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
                suffixIcon:
                    IconButton(icon: Icon(Icons.cancel), onPressed: () {})),
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
          ),
        ),
        new FlatButton.icon(
            icon: Icon(
              Icons.email,
              color: Colors.blueAccent,
            ),
            label: Text("Change Email "),
            onPressed: () async {

                 if (_formKey1.currentState.validate() != true) return;
   _formKey1.currentState.save();
              Alert(
                  context: context,
                  title: "Enter Current password",
                  content: Column(
                    children: <Widget>[
                      TextField(
                        controller: currentpassController1,
                        obscureText: true,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          labelText: 'current Password',
                        ),
                      ),
                    ],
                  ),
                  buttons: [
                    DialogButton(
                      onPressed: () {
                     
                        new Auth()
                            .cheak(
                                emailuser, currentpassController1.text, context)
                            .then((bool result) {
                          if (result == true) {
                            setState(() async {
                              FirebaseUser user =
                                  await FirebaseAuth.instance.currentUser();

                              user.updateEmail(newemailController.text);
                            });
                          }
                        });
                       /* Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChangePass()),
                        );*/
                      },
                      child: Text(
                        "confirm",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ]).show();

              // FirebaseUser user = await FirebaseAuth.instance.currentUser();

              // user.updateEmail(newemailController.text);
            }),]))
      ])
      ),
    );
  }

  _onAlertButtonPressed1(context) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Error",
      desc: "Some fields are required please full them",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }
}
