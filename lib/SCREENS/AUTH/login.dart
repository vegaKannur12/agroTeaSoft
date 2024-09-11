import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tsupply/COMPONENTS/custom_snackbar.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:tsupply/SCREENS/COLLECTION/collection.dart';

class USERLogin extends StatefulWidget {
  const USERLogin({super.key});

  @override
  State<USERLogin> createState() => _USERLoginState();
}

class _USERLoginState extends State<USERLogin> {
  TextEditingController password = TextEditingController();
  bool loginLoad = false;
   DateTime date = DateTime.now();
   String? logdate;
  @override
  void initState() {
    // TODO: implement initState
    logdate = date.toString();
    Provider.of<Controller>(context, listen: false).getUsersfromDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool _isOn = true;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<Controller>(
            builder: (BuildContext context, Controller value, Widget? child) =>
                Stack(
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
                          Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Colors
                                  .white, // Background color of the dropdown menu
                            ),
                            child: Container(
                              // height: 50,
                              // width: 250,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Colors.black,
                                  )),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  icon: Container(
                                    padding: EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                    child: Icon(Icons.person, size: 16),
                                  ),
                                  labelStyle: TextStyle(color: Colors.white),
                                  focusedBorder: OutlineInputBorder(
                                      // borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      // borderSide: BorderSide(
                                      //     color:
                                      //         Color.fromARGB(255, 119, 119, 119),
                                      //     width: 1),
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
                                        color:
                                            // Colors.black,
                                            Color.fromARGB(255, 119, 119, 119),
                                        width: 1),
                                  ),
                                ),
                                isExpanded: true,
                                hint: Text(
                                  "Select username",
                                  style: TextStyle(color: Colors.black),
                                ),
                                value: value.selectedSmName,
                                style: TextStyle(color: Colors.black),
                                // underline: Container(
                                //   decoration: ShapeDecoration(
                                //     shape: RoundedRectangleBorder(
                                //       side: BorderSide(width: 1.0, style: BorderStyle.solid),
                                //       borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                //     ),
                                //   ),
                                // ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    value.selectedUsrName = newValue;
                                    print(("object"));
                                    print(
                                        ("selected NAme==${value.selectedUsrName}"));

                                    //                          Text("Sm_id: ${selectedItem!['Sm_id']}"),
                                    // Text("Us_Name: ${selectedItem!['Us_Name']}"),
                                    // Text("PWD: ${selectedItem!['PWD']}"),
                                    value.selectedUserMap = value.userList
                                        .firstWhere((element) =>
                                            element['username'] == newValue);
                                    print("${value.selectedUserMap}");
                                    Provider.of<Controller>(context,
                                            listen: false)
                                        .updateUserDetails(logdate!);
                                  });
                                },
                                items: value.userList
                                    .map<DropdownMenuItem<String>>(
                                        (Map<String, dynamic> item) {
                                  return DropdownMenuItem<String>(
                                    value: item['username'],
                                    child: Text(
                                      item['username'],
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          // TextFormField(
                          //   keyboardType: TextInputType.text,
                          //   // controller: phone,
                          //   inputFormatters: [
                          //     LengthLimitingTextInputFormatter(10)
                          //   ],
                          //   validator: (text) {
                          //     if (text == null || text.isEmpty) {
                          //       return 'Please Enter Username';
                          //     } else if (text.length != 10) {
                          //       return 'Please Enter Username ';
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
                          //           child: Icon(Icons.person, size: 16)),
                          //       hintText: '  Username',
                          //       hintStyle: TextStyle(fontSize: 14)),
                          // ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: password,
                            // inputFormatters: [
                            //   LengthLimitingTextInputFormatter(10)
                            // ],
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
                                      color: Colors.black,
                                      // color: Color.fromARGB(255, 119, 119, 119),
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
                                    child: Icon(Icons.key, size: 16)),
                                hintText: '  Password',
                                hintStyle: TextStyle(fontSize: 14)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
                              onPressed: () async {
                                loginLoad = true;
                                int i = await Provider.of<Controller>(context,
                                        listen: false)
                                    .verifyStaff(password.text, context);
                                print("$i");
                                if (i == 1) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CollectionPage()));
                                } else {
                                  CustomSnackbar snackbar = CustomSnackbar();
                                  snackbar.showSnackbar(
                                      context, "Incorrect Password", "");
                                }
                                loginLoad = false;
                              },
                              child: Text(
                                "LOGIN",
                                style: TextStyle(color: Colors.white),
                              )),
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
      ),
    );
  }
}
