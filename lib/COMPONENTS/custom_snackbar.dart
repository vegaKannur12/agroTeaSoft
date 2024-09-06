import 'package:flutter/material.dart';
class CustomSnackbar {
  showSnackbar(BuildContext context, String content,String type) {
    ScaffoldMessenger. of(context).showSnackBar(
      SnackBar(behavior: SnackBarBehavior.floating,
        backgroundColor:Colors.black,
        duration:  Duration(seconds: 5),
        content: Text(content,style: TextStyle(color: Colors.white),),
        action: SnackBarAction(
          label: '',
          textColor: Colors.black,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
