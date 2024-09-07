import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:tsupply/COMPONENTS/custom_snackbar.dart';
import 'package:tsupply/COMPONENTS/external_dir.dart';
import 'package:tsupply/DB-HELPER/dbhelp.dart';
import 'package:tsupply/MODEL/accountMasterModel.dart';
import 'package:tsupply/MODEL/prodModel.dart';
import 'package:tsupply/MODEL/routeModel.dart';
import 'package:tsupply/MODEL/transMasterModel.dart';
import 'package:tsupply/MODEL/transdetailModel.dart';
import 'package:tsupply/MODEL/userModel.dart';

class Controller extends ChangeNotifier {
  //for postreg
  String? fp;
  String? cid;
  ExternalDir externalDir = ExternalDir();
  // List<CD> c_d = [];
  String? sof;
  bool isLoading = false;
  String? appType;
  String? os;
  String? cname;
  ////////
  bool isdbLoading = true;
  List<Map<String, dynamic>> db_list = [];
  bool isYearSelectLoading = false;
  bool isLoginLoading = false;
  List<Map<String, dynamic>> logList = [];
  String? selectedSmName;
  Map<String, dynamic>? selectedItemStaff;
  bool isDBLoading = false;

  ////////////////////////////////////
  RouteModel routee = RouteModel();
  AccountMasterModel acnt = AccountMasterModel();
  UserModel usr = UserModel();
  ProdModel prod = ProdModel();
  TransMasterModel transm = TransMasterModel();
  TransDetailModel transdt = TransDetailModel();
  String? selectedrut;
  String? selectedsuplier;
  String? selectedUsrName;
  Map<String, dynamic>? selectedUserMap;
  List<Map<String, dynamic>> routeList = [];
  List<Map<String, dynamic>> spplierList = [];
  List<Map<String, dynamic>> userList = [];
  List<Map<String, dynamic>> importtransMasterList = [];
  List<Map<String, dynamic>> importtransDetailsList = [];
  List<Map<String, dynamic>> prodList = [];
  List<Map<String, dynamic>> transdetailsList = [];
  List<Map<String, dynamic>> transmasterList = [];
  List<Map<String, dynamic>> finalSaveinnerList = [];
  List<Map<String, dynamic>> finalSaveList = [];
  Map<String, dynamic> transMasterMap = {};
  Map<String, dynamic> transDetailsMap = {};
  Map<String, dynamic> finalSaveMap = {};

  List<bool> downlooaded = [];
  List<bool> downloading = [];
  List<String> downloadItems = [
    "Route",
    "Supplier Details",
    "Product Details",
    "User Details",
  ];
  List<TextEditingController> colected = [];
  List<TextEditingController> damage = [];
  List<TextEditingController> total = [];
  List<Map<String, dynamic>> filteredlist = [];
  bool isSearch = false;
  setdownflag() {
    downlooaded = List.generate(downloadItems.length, (index) => false);
    downloading = List.generate(downloadItems.length, (index) => false);
    notifyListeners();
  }

  Future<RouteModel?> getRouteDetails(
      int index, String page, BuildContext context) async {
    // print("cid...............${cid}");
    try {
      downloading[index] = true;
      notifyListeners();
      Uri url = Uri.parse("http://192.168.18.168:7000/api/load_routes");
      // // SharedPreferences prefs = await SharedPreferences.getInstance();
      // // String? br_id1 = prefs.getString("br_id");

      Map body = {'cid': ""};

      http.Response response = await http.post(
        url,
        body: body,
      );

      print("body ${body}");
      var map = jsonDecode(response.body);
      print("route Map--> $map");
      if (map != null) {
        await TeaDB.instance
            .deleteFromTableCommonQuery('routeDetailsTable', "");
        // List map = [
        //   {"id": 1, "name": "Kannur", "status": 0},
        //   {"id": 2, "name": "Thalassery", "status": 0},
        //   {"id": 3, "name": "Mattannur", "status": 0}
        // ];

        for (var routee in map) {
          print("routeeee----${routee.length}");
          routee = RouteModel.fromJson(routee);
          var rote = await TeaDB.instance.insertrouteDetails(routee);
          print("inserted ${rote}");
        }
        downloading[index] = false;
        downlooaded[index] = true;
        getRoute(" ", context);
        notifyListeners();
        return routee;
      } else {
        print("route Map null");
      }
    } catch (e) {
      downloading[index] = false;
      if (e is SocketException) {
        CustomSnackbar snak = CustomSnackbar();
        snak.showSnackbar(context, "SocketException: No route to host", "");
        print('SocketException: ${e.message}');
        print('Failed to connect to the server.');
      } else if (e is ClientException) {
        CustomSnackbar snak = CustomSnackbar();
        snak.showSnackbar(context, "${e.toString()}", "");
        print('ClientException: ${e.message}');
      } else {
        CustomSnackbar snak = CustomSnackbar();
        snak.showSnackbar(context, "${e.toString()}", "");
        print('Unknown error: $e');
      }
      // CustomSnackbar snak = CustomSnackbar();
      // snak.showSnackbar(context, "${e.toString()}", "");
      // print('General Exception: $e');
    }
  }

  savetransmaster(Map<String, dynamic> mstr) async {
    filteredlist.clear();
    finalSaveMap.clear();
    notifyListeners();
    print("trans_id----------${mstr["trans_id"].toString()}");
    finalSaveinnerList.add(mstr);
    finalSaveMap['transactions'] = finalSaveinnerList;
    notifyListeners();
    print("final LIST=---------------$finalSaveinnerList");
    print(
        "final MAP=---------------$finalSaveMap"); //  //  save-api format of transaction

    finalSavetoapi(finalSaveMap);

    transdetailsList.clear();
  }

  importFinal(
      BuildContext context, List? transfiltered) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ts = prefs.getString("t_series");
    String? unm = prefs.getString("uname");

    finalSaveList.clear();
    finalSaveMap.clear();
    finalSaveinnerList.clear(); // Clear finalSaveinnerList at the beginning
    notifyListeners();

    print("Master List: $importtransMasterList");
    print("Details List: $importtransDetailsList");

    for (var i = 0; i < importtransMasterList.length; i++) {
      // matermap.clear();
      // if (transfiltered!.isEmpty) {
        Map<String, dynamic> matermap = {};
        notifyListeners();
        int transid = importtransMasterList[i]["trans_id"];
        print("Processing trans_id: $transid");
        String mastrid = "$ts$transid";
        print("Generated mastrid: $mastrid");
        matermap = Map.from(importtransMasterList[i]); //hidden_status
        matermap["trans_id"] = importtransMasterList[i]["trans_id"];
        matermap["trans_series"] = importtransMasterList[i]["trans_series"];
        matermap["trans_date"] = importtransMasterList[i]["trans_date"];
        matermap["trans_party_id"] = importtransMasterList[i]["trans_party_id"];
        matermap["trans_party_name"] =
            importtransMasterList[i]["trans_party_name"];
        matermap["trans_remark"] = importtransMasterList[i]["trans_remark"];
        matermap["trans_bag_nos"] = importtransMasterList[i]["trans_bag_nos"];
        matermap["trans_bag_weights"] =
            importtransMasterList[i]["trans_bag_weights"];
        matermap["trans_import_id"] =
            importtransMasterList[i]["trans_import_id"];
        matermap["company_id"] = importtransMasterList[i]["company_id"];
        matermap["branch_id"] = importtransMasterList[i]["branch_id"];
        matermap["user_session"] = importtransMasterList[i]["user_session"];
        matermap["log_user_id"] = importtransMasterList[i]["log_user_id"];
        matermap["hidden_status"] = "0";
        matermap["row_id"] = "0";
        matermap["log_user_name"] = unm;
        matermap["log_date"] = importtransMasterList[i]["log_date"];
        matermap["status"] = importtransMasterList[i]["status"];
        List<Map<String, dynamic>> detailsList = [];
        for (var j = 0; j < importtransDetailsList.length; j++) {
          print(
              "Checking details for mastrid: $mastrid and trans_det_mast_id: ${importtransDetailsList[j]["trans_det_mast_id"]}");
          // Check if the detail belongs to the current master entry
          if (importtransDetailsList[j]["trans_det_mast_id"].toString() ==
              mastrid) {
            detailsList.add(importtransDetailsList[j]);
          }
        }

        // Attach details to the master entry if available
        if (detailsList.isNotEmpty) {
          matermap["details"] = detailsList;
          finalSaveinnerList.add(matermap);
          // matermap.clear();
          print("Added master with details: $matermap");
        } else {
          print("No details found for trans_id: $transid");
        }
        notifyListeners();
      // } else {
      //   print(object)
      //   for (var i = 0; i < transfiltered.length; i++) {
      //     if (importtransMasterList[i]["trans_id"] == transfiltered[i]) {
      //       Map<String, dynamic> matermap = {};
      //       notifyListeners();
      //       int transid = importtransMasterList[i]["trans_id"];
      //       print("Processing trans_id: $transid");
      //       String mastrid = "$ts$transid";
      //       print("Generated mastrid: $mastrid");

      //       matermap = Map.from(importtransMasterList[i]); //hidden_status
      //       matermap["trans_id"] = importtransMasterList[i]["trans_id"];
      //       matermap["trans_series"] = importtransMasterList[i]["trans_series"];
      //       matermap["trans_date"] = importtransMasterList[i]["trans_date"];
      //       matermap["trans_party_id"] =
      //           importtransMasterList[i]["trans_party_id"];
      //       matermap["trans_party_name"] =
      //           importtransMasterList[i]["trans_party_name"];
      //       matermap["trans_remark"] = importtransMasterList[i]["trans_remark"];
      //       matermap["trans_bag_nos"] =
      //           importtransMasterList[i]["trans_bag_nos"];
      //       matermap["trans_bag_weights"] =
      //           importtransMasterList[i]["trans_bag_weights"];
      //       matermap["trans_import_id"] =
      //           importtransMasterList[i]["trans_import_id"];
      //       matermap["company_id"] = importtransMasterList[i]["company_id"];
      //       matermap["branch_id"] = importtransMasterList[i]["branch_id"];
      //       matermap["user_session"] = importtransMasterList[i]["user_session"];
      //       matermap["log_user_id"] = importtransMasterList[i]["log_user_id"];
      //       matermap["hidden_status"] = "0";
      //       matermap["row_id"] = "0";
      //       matermap["log_user_name"] = unm;
      //       matermap["log_date"] = importtransMasterList[i]["log_date"];
      //       matermap["status"] = importtransMasterList[i]["status"];

      //       List<Map<String, dynamic>> detailsList = [];

      //       for (var j = 0; j < importtransDetailsList.length; j++) {
      //         print(
      //             "Checking details for mastrid: $mastrid and trans_det_mast_id: ${importtransDetailsList[j]["trans_det_mast_id"]}");

      //         // Check if the detail belongs to the current master entry
      //         if (importtransDetailsList[j]["trans_det_mast_id"].toString() ==
      //             mastrid) {
      //           detailsList.add(importtransDetailsList[j]);
      //         }
      //       }

      //       // Attach details to the master entry if available
      //       if (detailsList.isNotEmpty) {
      //         matermap["details"] = detailsList;
      //         finalSaveinnerList.add(matermap);
      //         // matermap.clear();
      //         print("Added master with details: $matermap");
      //       } else {
      //         print("No details found for trans_id: $transid");
      //       }
      //       notifyListeners();
      //     }
      //   }

      //   ///
      // }
    }

    // Prepare final save map and list
    finalSaveMap['transactions'] = finalSaveinnerList;
    print("Final MAP: $finalSaveMap"); // API-ready map format

    finalSaveList.add(finalSaveMap);
    print("Final LIST: $finalSaveList");
    print("Final LIST length: ${finalSaveList.length}");
    notifyListeners();

    // Send data to API
    finalSavetoapi(finalSaveMap);   //uncomented in future
  }

  // importFinal() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? ts = prefs.getString("t_series");
  //   finalSaveList.clear();
  //   finalSaveMap.clear();
  //   notifyListeners();
  //   Map<String, dynamic> matermap = {};

  //   for (var i = 0; i < importtransMasterList.length; i++) {
  //     matermap.clear();

  //     notifyListeners();
  //     int transid = importtransMasterList[i]["trans_id"];
  //     print("transddd==$transid");
  //     String mastrid = "$ts$transid";
  //     matermap = Map.from(importtransMasterList[i]);
  //     // matermap = importtransMasterList[i];
  //     List<Map<String, dynamic>> detailsList = [];
  //     for (var j = 0; j < importtransDetailsList.length; j++) {
  //       if (importtransDetailsList[j]["trans_det_mast_id"].toString() ==
  //           mastrid) {
  //         detailsList.add(importtransDetailsList[j]);
  //       }
  //     }
  //     matermap["details"] = detailsList;
  //     notifyListeners();
  //     print("mastreMap====$matermap");

  //     notifyListeners();
  //     print("trans_id----------${matermap["trans_id"].toString()}");
  //     finalSaveinnerList.add(matermap);

  //     notifyListeners();
  //   }
  //   print("final INNER LIST=---------------$finalSaveinnerList");
  //   finalSaveMap['transactions'] = finalSaveinnerList;
  //   print(
  //       "final MAP=---------------$finalSaveMap"); //  //  save-api format of transaction

  //   finalSaveList.add(finalSaveMap);
  //   notifyListeners();
  //   print("final LIST=---------------$finalSaveList");
  //   print("final LIST length=---------------${finalSaveList.length}");
  //   // transdetailsList.clear();
  //   finalSavetoapi(finalSaveMap);
  // }

  finalSavetoapi(Map<String, dynamic> mapp) async {
    var mapBody = jsonEncode(mapp);
    Uri url = Uri.parse("http://192.168.18.168:7000/api/Trans_Save");
    Map body = {'json_arr': mapBody};
    http.Response response = await http.post(
      url,
      body: body,
    );
    print("save body ${body}");
    var map = jsonDecode(response.body);
    print("save Map--> $map");
  }

  gettransmasterfromdb(int tid) {}

  getRoute(String? sid, BuildContext context) async {
    String areaName;
    print("staff...............${sid}");
    try {
      List areaList = await TeaDB.instance.getRoutefromDB(sid!);
      print("areaList----${areaList}");
      routeList.clear();
      for (var item in areaList) {
        routeList.add(item);
      }
      print("added to routeList----${routeList}");
      notifyListeners();
    }
    // on SocketException catch (e) {
    //   CustomSnackbar snak = CustomSnackbar();
    //   snak.showSnackbar(context, "${e.toString()}", "");
    //   print('SocketException: $e');
    // } on http.ClientException catch (e) {
    //   CustomSnackbar snak = CustomSnackbar();
    //   snak.showSnackbar(context, "${e.toString()}", "");
    //   print('ClientException: $e');
    // }
    catch (e) {
      if (e is SocketException) {
        CustomSnackbar snak = CustomSnackbar();
        snak.showSnackbar(context, "${e.toString()}", "");
        print('SocketException: ${e.message}');
        print('Failed to connect to the server.');
      } else if (e is ClientException) {
        CustomSnackbar snak = CustomSnackbar();
        snak.showSnackbar(context, "${e.toString()}", "");
        print('ClientException: ${e.message}');
      } else {
        CustomSnackbar snak = CustomSnackbar();
        snak.showSnackbar(context, "${e.toString()}", "");
        print('Unknown error: $e');
      }
      // CustomSnackbar snak = CustomSnackbar();
      // snak.showSnackbar(context, "${e.toString()}", "");
      // print('General Exception: $e');
    }
    notifyListeners();
  }

  setSelectedroute(Map selectedrout) async {
    selectedrut = selectedrout["routename"];
    print(selectedrout["rid"].runtimeType);
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("sel_rootid", selectedrout["rid"]);
    prefs.setString("sel_rootnm", selectedrout["routename"]);
    print("roottt---$selectedrut");
    notifyListeners();
  }

  setSelectedsupplier(Map selsupplier) async {
    selectedsuplier = selsupplier["acc_name"];
    print(selsupplier["acid"].runtimeType);
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("sel_accid", selsupplier["acid"]);
    prefs.setString("sel_accnm", selsupplier["acc_name"]);
    print("sel supplier---$selectedsuplier, ${selsupplier["acid"]}");
    notifyListeners();
  }

  Future<AccountMasterModel?> getACMasterDetails(int index, String page) async {
    // print("cid...............${cid}");
    try {
      Uri url = Uri.parse("http://192.168.18.168:7000/api/load_suppliers");
      // // SharedPreferences prefs = await SharedPreferences.getInstance();
      // // String? br_id1 = prefs.getString("br_id");
      Map body = {'cid': " "};
      downloading[index] = true;

      // print("compny----${cid}");
      http.Response response = await http.post(
        url,
        body: body,
      );
      print("body ${body}");
      var map = jsonDecode(response.body);
      print("mapsuppli ${map}");
      await TeaDB.instance.deleteFromTableCommonQuery('accountMasterTable', "");
      // List map = [
      //   {
      //     "id": 11,
      //     "acc_name": "Supply1",
      //     "route": 2,
      //     "status": 0,
      //     "acc_master_type": "SU"
      //   },
      //   {
      //     "id": 12,
      //     "acc_name": "Supply2",
      //     "route": 2,
      //     "status": 0,
      //     "acc_master_type": "CU"
      //   },
      //   {
      //     "id": 13,
      //     "acc_name": "Supply3",
      //     "route": 2,
      //     "status": 0,
      //     "acc_master_type": "SU"
      //   },
      // ];
      for (var acnt in map) {
        print("accdetails----${acnt.length}");
        acnt = AccountMasterModel.fromJson(acnt);
        var acc = await TeaDB.instance.insertACmasterDetails(acnt);
        print("inserted ${acc}");
      }
      downloading[index] = false;
      downlooaded[index] = true;
      notifyListeners();
      return acnt;
    } catch (e) {
      print(e);
      return null;
    }
  }

  getSupplierfromDB(int? rid) async {
    print("root ID...............${rid}");
    try {
      List accList = await TeaDB.instance.getSupplierListfromDB(rid!);
      print("accList----${accList}");
      spplierList.clear();
      for (var item in accList) {
        spplierList.add(item);
      }
      filteredlist = spplierList;
      print("added to supplierList----${spplierList}");
      notifyListeners();
    } catch (e) {
      print(e);
      return null;
    }
    notifyListeners();
  }

  getProductsfromDB() async {
    try {
      List proList = await TeaDB.instance.getProductListfromDB();
      print("prodList----${proList}");
      prodList.clear();
      prodList = [
        {"id": 1, "pid": 1, "product": "A"},
        // {"id": 2, "pid": 2, "product": "B"},
      ];
      // for (var item in proList) {
      //   prodList.add(item);
      // }
      var lengthh = prodList.length;
      colected = List.generate(lengthh, (index) => TextEditingController());
      damage = List.generate(lengthh, (index) => TextEditingController());
      total = List.generate(lengthh, (index) => TextEditingController());
      for (int i = 0; i < lengthh; i++) {
        colected[i].text = "0";
        damage[i].text = "0";
        total[i].text = "10";
        print("colected 1st............$colected");
      }
      print("added to prodctList----${prodList}");
      notifyListeners();
    } catch (e) {
      print(e);
      return null;
    }
    notifyListeners();
  }

  getUsersfromDB() async {
    try {
      List usrList = await TeaDB.instance.getUserListfromDB();
      print("userList----${usrList}");
      userList.clear();
      for (var item in usrList) {
        userList.add(item);
      }
      print("added to userList----${userList}");
      notifyListeners();
    } catch (e) {
      print(e);
      return null;
    }
    notifyListeners();
  }

  gettransMastersfromDB() async {
    try {
      List trList = await TeaDB.instance.gettransMasterfromDB();
      // print("translist----${trList}");
      importtransMasterList.clear();
      for (var item in trList) {
        importtransMasterList.add(item);
      }
      print("added to translist----${importtransMasterList}");
      notifyListeners();
    } catch (e) {
      print(e);
      return null;
    }
    notifyListeners();
  }

  gettransDetailsfromDB() async {
    try {
      List dtlList = await TeaDB.instance.gettransDetailsfromDB();
      // print("transDETlist----${dtlList}");
      importtransDetailsList.clear();
      for (var item in dtlList) {
        importtransDetailsList.add(item);
      }
      print("added to transDETlist----${importtransDetailsList}");
      notifyListeners();
    } catch (e) {
      print(e);
      return null;
    }
    notifyListeners();
  }

  updateUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("u_id", selectedUserMap!['uid']);
    prefs.setString("uname", selectedUserMap!['username']);
    prefs.setString("upwd", selectedUserMap!['password']);
    prefs.setInt("c_id", selectedUserMap!['company_id']);
    prefs.setInt("br_id", selectedUserMap!['branch_id']);
    notifyListeners();
  }

  verifyStaff(String pwd, BuildContext context) {
    print("pwd , selpwd ====$pwd ,${selectedUserMap!['password']}");
    if (pwd.toLowerCase() ==
        selectedUserMap!['password'].toString().trim().toLowerCase()) {
      return 1;
    } else {
      return 0;
    }
  }

  Future<ProdModel?> getProductDetails(int index, String page) async {
    // print("cid...............${cid}");
    try {
      downloading[index] = true;
      notifyListeners();
      Uri url = Uri.parse("http://192.168.18.168:7000/api/load_products");
      // // SharedPreferences prefs = await SharedPreferences.getInstance();
      // // String? br_id1 = prefs.getString("br_id");
      Map body = {'cid': ""};

      http.Response response = await http.post(
        url,
        body: body,
      );

      print("Prod body ${body}");
      var map = jsonDecode(response.body);
      print("Prod Map--> $map");

      await TeaDB.instance.deleteFromTableCommonQuery('prodDetailsTable', "");
      // List map = [
      //   {"id": 1, "name": "Kannur", "status": 0},
      //   {"id": 2, "name": "Thalassery", "status": 0},
      //   {"id": 3, "name": "Mattannur", "status": 0}
      // ];

      for (var pro in map) {
        print("productt----${pro.length}");

        prod = ProdModel.fromJson(pro);
        var proo = await TeaDB.instance.insertproductDetails(prod);
        print("inserted ${proo}");
      }
      downloading[index] = false;
      downlooaded[index] = true;
      notifyListeners();
      return prod;
    } catch (e) {
      print(e);
      return null;
    }
  }

  registeration(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("t_series", "CD");
  }

  Future<UserModel?> getUserDetails(int index, String page) async {
    try {
      downloading[index] = true;
      notifyListeners();
      Uri url = Uri.parse("http://192.168.18.168:7000/api/load_users");
      // // SharedPreferences prefs = await SharedPreferences.getInstance();
      // // String? br_id1 = prefs.getString("br_id");
      Map body = {'cid': ""};

      http.Response response = await http.post(
        url,
        body: body,
      );
      print("User body ${body}");
      var map = jsonDecode(response.body);
      print("User Map--> $map");
      if (map != null) {
        await TeaDB.instance.deleteFromTableCommonQuery('UserMasterTable', "");
        // List map = [
        //   {"id": 1, "name": "Kannur", "status": 0},
        //   {"id": 2, "name": "Thalassery", "status": 0},
        //   {"id": 3, "name": "Mattannur", "status": 0}
        // ];
        for (var uss in map) {
          print("userrr----${uss.length}");
          usr = UserModel.fromJson(uss);
          var userr = await TeaDB.instance.insertUserDetails(usr);
          print("user inserted ${userr}");
        }
        downloading[index] = false;
        downlooaded[index] = true;
        getUsersfromDB();
        notifyListeners();
        return usr;
      } else {
        print("user map null");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  insertTransDetailstoDB(List<Map<String, dynamic>> details) async {
    final dbHelper = TeaDB.instance;
    for (var detail in details) {
      var transDetail = TransDetailModel.fromMap(detail);
      await dbHelper.insertTransDetail(transDetail);
    }
  }

  insertTransMastertoDB(Map<String, dynamic> transMasterM) async {
    transm = TransMasterModel.fromJson(transMasterM);
    var trn = await TeaDB.instance.inserttransMasterDetails(transm);
  }

  searchSupplier(String val) {
    filteredlist = spplierList;
    if (val.isNotEmpty) {
      isSearch = true;
      notifyListeners();

      filteredlist = spplierList
          .where((e) => e["acc_name"]
              .toString()
              .toLowerCase()
              .contains(val.toLowerCase()))
          .toList();
    } else {
      isSearch = false;
      notifyListeners();
      filteredlist = spplierList;
    }
    // qty =
    //     List.generate(filteredlist.length, (index) => TextEditingController());
    // isAdded = List.generate(filteredlist.length, (index) => false);
    // response = List.generate(filteredlist.length, (index) => 0);
    // for (int i = 0; i < filteredlist.length; i++) {
    //   qty[i].text = "1.0";
    //   response[i] = 0;
    // }
    print("filtered_CAT_List----------------$filteredlist");
    notifyListeners();
  }
}
