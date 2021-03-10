import 'package:flutter/material.dart';
import 'package:wifi_scanning_flutter/data/user_preference.dart';
import 'package:wifi_scanning_flutter/models/customised_user.dart';
import 'package:wifi_scanning_flutter/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scanning_flutter/screens/loading.dart';
import 'package:wifi_scanning_flutter/screens/user/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomisedUser>(context);
    
    if (user == null) {
      return Authenticate();
    }
    else {
      return FutureBuilder(
        future: UserPreference.setUsername(user.uid),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return User();
          }
          else{
            return LoadingPage();
          }
        }
      );
    }
  }
}
