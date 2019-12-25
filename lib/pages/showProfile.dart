import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_journey/models/global.dart';
import 'package:safe_journey/models/user.dart';
import 'package:safe_journey/widgets/header.dart';
import './InfoCard.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
const url = 'http://thinkdiff.net';
//const email = 'lana@example.com';
//const phone = '0595666233';



class ShowProfile extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<ShowProfile> {
  //final String _fullName = "person Name";

 // final String _status = "mobile id";

 // final String _bio = "\"Bio\"";
//************************************************************************ */
  void _showDialog(BuildContext context, {String title, String msg}) {
    final dialog = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: <Widget>[
        RaisedButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Close',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
    showDialog(context: context, builder: (x) => dialog);
  }
//********************************************************************************************** */
  Widget _buildCoverImage(Size screenSize) {
    bool havaAvalidUrl =
        (userData['background'] != null && userData['background'] != 'noURL');
    return Container(
      height: screenSize.height / 4,
      decoration: BoxDecoration(
        image: DecorationImage(
          image:  havaAvalidUrl == false
                  ? AssetImage("")
                  : NetworkImage(userData['background']),
          fit: BoxFit.cover,
        ),),







//////////////////////////////////////////////////
      
    );
  }
  //*************************************************************************************** */profile pic

  Widget _buildProfileImage() {
    bool havaAvalidUrl =
        (userData['imageURL'] != null && userData['imageURL'] != 'noURL');
    return Center(
      child: Container(
        
        width: 140.0,
        height: 140.0,
        //color: Color(0xffAB1717),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: havaAvalidUrl == false
                  ? AssetImage("images/profile.png")
                  : NetworkImage(userData['imageURL']),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 10.0,
          ),
        ),
      ),
    );
  }
//***************************************************************************************** */
  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      userData["name"].toString(),
      style: _nameTextStyle,
    );
  }
//*************************************************************************************** */
 /* Widget _buildStatus(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        _status,
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }*/
//****************************************************************************************************** */
  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400, //try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      child: Text(
           userData['bio'],
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }
//*********************************************************************************** */
  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }
//****************************************************************************************** */
 final Map<String, dynamic> userData = {
    'name': 'fetching..',
    'email': 'fetching..',
    'phoneNumber':"fetching",
     'bio':"fetching",
    'imageURL': null,
    'background':null
  };

  final databaseReference = Firestore.instance;

  @override
  void initState() {
    fillUserData();
    super.initState();
  }
//******************************************************************************************** */
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Header(
      //********************************************************************** */
      body: Stack(
        children: <Widget>[
          _buildCoverImage(screenSize),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height / 6.4),
                  _buildProfileImage(),
                                    SizedBox(height: 30.0),
                           
                   
                  _buildFullName(),
                //  _buildStatus(context),
                  _buildBio(context),
                 _buildSeparator(screenSize),
                 SizedBox(height: 30.0),
                  InfoCard(
                    text: userData["email"],
                    icon: Icons.email,
                    onPressed: () async {
                      final emailAddress = 'mailto:$userData["email"]';

                      if (await launcher.canLaunch(emailAddress)) {
                        await launcher.launch(emailAddress);
                      } else {
                        _showDialog(
                          context,
                          title: 'Sorry',
                          msg: 'Email can not be send. Please try again!',
                        );
                      }
                    },
                  ),

                  InfoCard(
                    text: userData["phoneNumber"],
                    icon: Icons.phone,
                    
                    onPressed: () async {
                      String removeSpaceFromPhoneNumber =
                          userData["phoneNumber"].replaceAll(new RegExp(r"\s+\b|\b\s"), "");
                      final phoneCall = 'tel:$removeSpaceFromPhoneNumber';

                      if (await launcher.canLaunch(phoneCall)) {
                        await launcher.launch(phoneCall);
                      } else {
                        _showDialog(
                          context,
                          title: 'Sorry',
                          msg:
                              'Phone number can not be called. Please try again!',
                        );
                      }
                    },
                  ),
                  SizedBox(height: 8.0),

                 // _buildButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  //************************************************************************************************** */

  Future<void> fillUserData() async {
   User user= Global.user;
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
          userData['name'] = doc.data['name'];
          userData['email'] = user.email;
          userData['imageURL'] = doc.data['imageURL'];
          userData['background'] = doc.data['background'];

          userData['phoneNumber'] = doc.data['phoneNumber'];
          userData['bio'] = doc.data['bio'];



          
        });
      }
    });
  }
}
