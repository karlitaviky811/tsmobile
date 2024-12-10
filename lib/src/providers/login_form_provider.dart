import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {

  //String email = 'tecnico8@gmail.com';
  //String password = '83244473487';
  String email = '';
  String password = '';

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  bool isValidForm(){
    return formKey.currentState?.validate() ?? false;
  }

}