import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:tsupply/SCREENS/COLLECTION/collection.dart';

class USERLogin extends StatefulWidget {
  const USERLogin({super.key});

  @override
  State<USERLogin> createState() => _USERLoginState();
}

class _USERLoginState extends State<USERLogin> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool _isOn = true;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none, // Allow overflow
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(24)),
              width: 330,
              child: Padding(
                padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      // controller: phone,
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter Username';
                        } else if (text.length != 10) {
                          return 'Please Enter Username ';
                        }
                        return null;
                      },
                      // scrollPadding:
                      //     EdgeInsets.only(bottom: topInsets + size.height * 0.18),
                      // obscureText: _isObscure.value,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: 10.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            // borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 119, 119, 119),
                                width: 1),
                          ),
                          errorBorder: OutlineInputBorder(
                            // borderRadius: BorderRadius.all(Radius.circular(20.0)
                            // ),
                            borderSide: BorderSide(color: Colors.red, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            // borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 119, 119, 119),
                                width: 1),
                          ),
                          prefixIcon: Container(
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border(
                                      right:
                                          BorderSide(color: Colors.black38))),
                              child: Icon(Icons.person, size: 16)),
                          hintText: '  Username',
                          hintStyle: TextStyle(fontSize: 14)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      // controller: phone,
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter Password';
                        } else if (text.length != 10) {
                          return 'Please Enter Password ';
                        }
                        return null;
                      },
                      // scrollPadding:
                      //     EdgeInsets.only(bottom: topInsets + size.height * 0.18),
                      // obscureText: _isObscure.value,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: 10.0,
                          ),
                          focusedBorder: OutlineInputBorder(
                            // borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 119, 119, 119),
                                width: 1),
                          ),
                          errorBorder: OutlineInputBorder(
                            // borderRadius: BorderRadius.all(Radius.circular(20.0)
                            // ),
                            borderSide: BorderSide(color: Colors.red, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            // borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 119, 119, 119),
                                width: 1),
                          ),
                          prefixIcon: Container(
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border(
                                      right:
                                          BorderSide(color: Colors.black38))),
                              child: Icon(Icons.key, size: 16)),
                          hintText: '  Password',
                          hintStyle: TextStyle(fontSize: 14)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Provider.of<Controller>(context, listen: false).getRoute(" ",context);
                          Navigator.of(context).push(
                            PageRouteBuilder(
                                opaque: false, // set to false
                                pageBuilder: (_, __, ___) => CollectionPage()),
                          );
                        },
                        child: Text("LOGIN")),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -30, // Position the icon above the container
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.transparent,
                child: Lottie.asset(
                  "assets/login.json",
                  // height:30
                  //  size.height * 0.25
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
