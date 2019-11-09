import 'package:flutter/material.dart';
import '../models/user.dart';

class UserSearchItem extends StatelessWidget {
  final User _user;
  final Function _addButtonPressed;
  final Map<String,dynamic> searchItemConfig;

  UserSearchItem(this._user, this._addButtonPressed, this.searchItemConfig,);

  @override
  Widget build(BuildContext context) {
    print('in search build ');
    TextStyle boldStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );

    return GestureDetector(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(_user.imageURL),
            backgroundColor: Colors.grey,
          ),
          title: Text(_user.name, style: boldStyle),
          subtitle: Text(_user.id),
          trailing: IconButton(
            icon: searchItemConfig['icon'],
            disabledColor: Colors.grey[300],
            color: Colors.black,
            //if on pressed = null disabled color is applied to the icon
            onPressed: !searchItemConfig['buttonEnabled']
                ? null
                : () {
                    _addButtonPressed(_user.id);
                  },
          ),
        ),
        onTap: () {
          // openProfile(context, user.id);
        });
  }
  // Map<String, dynamic> _fillSearchItemConfig() {
  //   Map<String, dynamic> searchItemConfig = {
  //     'icon': null,
  //     'message': '',
  //     'buttonEnabled': false
  //   };
  //   if (_invitedUsers != null && _invitedUsers.contains(_user.id)) {
  //     searchItemConfig['icon'] = Icon(
  //       Icons.hourglass_full,
  //       size: 30,
  //     );
  //     searchItemConfig['message'] = 'Invitation was sent before';
  //   } else if (_usersJoinThisJorney.contains(_user.id)) {
  //     searchItemConfig['icon'] = Icon(
  //       Icons.done,
  //       size: 30,
  //     );
  //     searchItemConfig['message'] =
  //         'This user is already a member in this journey';
  //   } else {
  //     searchItemConfig['icon'] = Icon(
  //       Icons.person_add,
  //       size: 30,
  //     );
  //     searchItemConfig['message'] = 'Successfullly sended invitation ';
  //     searchItemConfig['buttonEnabled'] = true;
  //   }

  //   return searchItemConfig;
  // }

  
}
