
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Widget_TextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueNotifier<bool> obscureNotifier;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final String? Function(String?) validator;
  final TextInputType keytype;

  Widget_TextField({
    required this.controller,
    required this.obscureNotifier,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.keytype=TextInputType.text,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: obscureNotifier,
      builder: (context, isObscure, child) {
        return TextFormField(keyboardType: keytype,style: TextStyle(color: Colors.white),
          controller: controller,
          obscureText: isPassword ? isObscure : false,
          validator: validator,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide: const BorderSide(
                  color: Colors.white, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide: const BorderSide(
                  color: Colors.white, width: 1),
            ),
            prefixIcon: Icon(prefixIcon, size: 16,color: Colors.white),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isObscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      obscureNotifier.value = !isObscure;
                    },
                  )
                : null,
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 14,color: Colors.white),
          ),
        );
      },
    );
  }
}

