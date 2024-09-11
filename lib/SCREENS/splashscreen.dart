import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsupply/COMPONENTS/external_dir.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:tsupply/SCREENS/AUTH/login.dart';
import 'package:tsupply/SCREENS/AUTH/registr.dart';
import 'package:tsupply/SCREENS/COLLECTION/collection.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  int? cid;
  String? fp;
  String? st_uname;
  String? st_pwd;
  String? t_series;
  ExternalDir externalDir = ExternalDir();

  navigate() async {
    await Future.delayed(Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      cid = prefs.getInt("c_id");
      t_series = prefs.getString("t_series");
      st_uname = prefs.getString("uname");
      st_pwd = prefs.getString("upwd");

      print("auth-----$cid---$st_uname---$st_pwd--");
      Navigator.push(
          context,
          PageRouteBuilder(
              opaque: false, // set to false
              pageBuilder: (_, __, ___) {
                if (cid != null) {
                  print("CID : $cid \nT_SERIES : $t_series");
                  if (st_uname != null && st_pwd != null) {
                    return CollectionPage();
                  } else {
                    return USERLogin();
                  }
                } else {
                  return Registration();
                }
              }));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Controller>(context, listen: false).getUsersfromDB();
      Provider.of<Controller>(context, listen: false).setdownflag();
    });
    // Provider.of<Controller>(context, listen: false).fetchMenusFromMenuTable();
    // Provider.of<Controller>(context, listen: false)
    //     .verifyRegistration(context, "splash");
    // shared();
    navigate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.teal,
      body: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Center(
            child: Column(
          children: [
            SizedBox(
              height: size.height * 0.4,
            ),
            Container(
                height: 200,
                width: 200,
                child: Image.asset(
                  "assets/logo_black_bg.png",
                )),
          ],
        )),
      ),
    );
  }
}
