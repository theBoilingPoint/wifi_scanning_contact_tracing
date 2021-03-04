import 'package:flutter/material.dart';
import 'package:wifi_scanning_flutter/models/customised_user.dart';
import 'package:wifi_scanning_flutter/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scanning_flutter/screens/user/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomisedUser>(context);
    if (user == null) {
      return Authenticate();
    }
    else {
      return User();
    }
  }
}
