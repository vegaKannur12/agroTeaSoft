
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsupply/COMPONENTS/external_dir.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:tsupply/SCREENS/AUTH/login.dart';
import 'package:tsupply/SCREENS/COLLECTION/collection.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  String? cid;
  String? com_cid;
  String? fp;
  bool? isautodownload;
  String? st_uname;
  String? st_pwd;
  String? userType;
  String? firstMenu;
  String? versof;
  bool? continueClicked;
  bool? staffLog;
  String? dataFile;
  String? os;

  ExternalDir externalDir = ExternalDir();

  navigate() async {
    await Future.delayed(Duration(seconds: 3), () async {
  
      // if (versof.toString() != "0") {
      Navigator.push(
          context,
          PageRouteBuilder(
              opaque: false, // set to false
              pageBuilder: (_, __, ___) {
                return CollectionPage();
          
              }));
      // if (versof != "0") {
      //   Navigator.push(
      //       context,
      //       PageRouteBuilder(
      //           opaque: false, // set to false
      //           pageBuilder: (_, __, ___) {
      //             if (cid != null) {
      //               if (continueClicked != null && continueClicked!) {
      //                 print("continueClicked.............$continueClicked");
      //                 if (st_uname != null &&
      //                     st_pwd != null &&
      //                     staffLog != null &&
      //                     staffLog!) {
      //                   return Dashboard();
      //                 } else {
      //                   return StaffLogin();
      //                 }
      //               } else {
      //                 if (os != null && os!.isNotEmpty) {
      //                   Provider.of<Controller>(context, listen: false)
      //                       .getCompanyData(context);
      //                   return CompanyDetails(
      //                     type: "",
      //                     msg: "",
      //                     br_length: 0,
      //                   );
      //                 } else {
      //                   return RegistrationScreen();
      //                 }
      //               }
      //             } else {
      //               return RegistrationScreen();
      //             }
      //           }));
      // }
    });
  }

  // shared() async {
  //   var status = await Permission.storage.status;
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   fp = prefs.getString("fp");
  //   print("fingerPrint......$fp");

  //   if (com_cid != null) {
  //     Provider.of<AdminController>(context, listen: false)
  //         .getCategoryReport(com_cid!);
  //     Provider.of<Controller>(context, listen: false).adminDashboard(com_cid!);
  //   }
  // }

  @override
  void initState() {
      
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
    Provider.of<Controller>(context, listen: false).setdownflag();});
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
      backgroundColor:Colors.teal,
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
