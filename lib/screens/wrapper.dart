import 'package:flutter/material.dart';
import 'package:prj/models/customised_user.dart';
import 'package:prj/screens/authenticate/authenticate.dart';
import 'package:prj/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomisedUser>(context);
    if (user == null) {
      return Authenticate();
    }
    else {
      return Home();
    }
  }
}
