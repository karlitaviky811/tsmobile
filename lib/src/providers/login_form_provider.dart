import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginFormProvider extends ChangeNotifier {

  String email = '';
  String password = '';


  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  bool isValidForm(){

    print(formKey.currentState?.validate());
    return formKey.currentState?.validate() ?? false;
  }

}