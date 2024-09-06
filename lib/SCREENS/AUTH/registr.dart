import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:tsupply/SCREENS/AUTH/login.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool _isOn = true;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none, // Allow overflow
            children: [
              Card(
                elevation: 4,
                color: Colors.transparent,
                shadowColor: Colors.green,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black38),
                      borderRadius: BorderRadius.circular(24)),
                  // width: 330,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 80, left: 30, right: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          // controller: phone,
                          // inputFormatters: [
                          //   LengthLimitingTextInputFormatter(10)
                          // ],
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Please Enter Key';
                            } else if (text.length != 10) {
                              return 'Please Enter Key ';
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
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1),
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
                                          right: BorderSide(
                                              color: Colors.black38))),
                                  child: Icon(Icons.person, size: 16)),
                              hintText: '  Key',
                              hintStyle: TextStyle(fontSize: 14)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // TextFormField(
                        //   keyboardType: TextInputType.text,
                        //   // controller: phone,
                        //   // inputFormatters: [
                        //   //   LengthLimitingTextInputFormatter(10)
                        //   // ],
                        //   validator: (text) {
                        //     if (text == null || text.isEmpty) {
                        //       return 'Please Enter Password';
                        //     } else if (text.length != 10) {
                        //       return 'Please Enter Password ';
                        //     }
                        //     return null;
                        //   },
                        //   // scrollPadding:
                        //   //     EdgeInsets.only(bottom: topInsets + size.height * 0.18),
                        //   // obscureText: _isObscure.value,
                        //   decoration: InputDecoration(
                        //       contentPadding: EdgeInsets.only(
                        //         left: 10.0,
                        //       ),
                        //       focusedBorder: OutlineInputBorder(
                        //         // borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        //         borderSide: BorderSide(
                        //             color: Color.fromARGB(255, 119, 119, 119),
                        //             width: 1),
                        //       ),
                        //       errorBorder: OutlineInputBorder(
                        //         // borderRadius: BorderRadius.all(Radius.circular(20.0)
                        //         // ),
                        //         borderSide:
                        //             BorderSide(color: Colors.red, width: 1),
                        //       ),
                        //       enabledBorder: OutlineInputBorder(
                        //         // borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        //         borderSide: BorderSide(
                        //             color: Color.fromARGB(255, 119, 119, 119),
                        //             width: 1),
                        //       ),
                        //       prefixIcon: Container(
                        //           decoration: BoxDecoration(
                        //               color: Colors.transparent,
                        //               border: Border(
                        //                   right: BorderSide(
                        //                       color: Colors.black38))),
                        //           child: Icon(Icons.key, size: 16)),
                        //       hintText: '  Password',
                        //       hintStyle: TextStyle(fontSize: 14)),
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          onPressed: () async {
                            await Provider.of<Controller>(context,
                                    listen: false)
                                .getRoute(" ", context);
                            await Provider.of<Controller>(context,
                                    listen: false)
                                .getUserDetails(0, "");

                            Navigator.of(context).push(
                              PageRouteBuilder(
                                  opaque: false, // set to false
                                  pageBuilder: (_, __, ___) => USERLogin()),
                            );
                          },
                          child: Text(
                            "REGISTER",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -40, // Position the icon above the container
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.transparent,
                  child: Image.asset(
                    "assets/locked.png",
                    // height:30
                    //  size.height * 0.25
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
