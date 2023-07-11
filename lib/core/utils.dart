import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

String getNameFrom(String email) {
  //alfiooatmaja@gmail.com
  //List = [alfiooatmaja@gmail.com]
  return email.split('@')[0];
}