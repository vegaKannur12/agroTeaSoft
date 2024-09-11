import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsupply/COMPONENTS/custom_snackbar.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:tsupply/DB-HELPER/dbhelp.dart';
import 'package:tsupply/MODEL/routeModel.dart';
import 'package:tsupply/MODEL/transMasterModel.dart';
import 'package:tsupply/MODEL/transdetailModel.dart';
import 'package:tsupply/SCREENS/DIALOGS/bottomtransdetails.dart';
import 'package:tsupply/SCREENS/DIALOGS/dilogSupplier.dart';
import 'package:tsupply/SCREENS/DRAWER/customdrawer.dart';
import 'package:tsupply/tableList.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage>
    with TickerProviderStateMixin {
  DateTime date = DateTime.now();
  String? displaydate;
  String? transactDate;
  String? savedate;
  late final TabController _tabController;
  TextEditingController bagno_ctrl = TextEditingController();
  TextEditingController wgt_ctrl = TextEditingController();
  TextEditingController adv_amt_ctrl = TextEditingController();
  TextEditingController adv_narratn_ctrl = TextEditingController();
  Map<String, dynamic>? selectedRoute;
  Map<String, dynamic>? selectedSpplierrr;
  TransDetailsBottomSheet tdetbottom = TransDetailsBottomSheet();
  DialogSupplier supdio = DialogSupplier();
  int? u_id;
  String? uname;
  String? upwd;
  int? br_id;
  int? c_id;
  TextEditingController dateInput = TextEditingController();
  @override
  void initState() {
    super.initState();
    getSharedpref();
    dateInput.text = "";
    _tabController = TabController(length: 2, vsync: this);
    displaydate = DateFormat('dd-MM-yyyy').format(date);
    transactDate = DateFormat('yyyy-MM-dd').format(date);
    // date.toString();
    Provider.of<Controller>(context, listen: false).getProductsfromDB();
    Provider.of<Controller>(context, listen: false).getRoute(" ", context);
    print(("-----$displaydate"));
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  getSharedpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    u_id = prefs.getInt("u_id");
    c_id = prefs.getInt("c_id");
    br_id = prefs.getInt("br_id");
    uname = prefs.getString("uname");
    upwd = prefs.getString("upwd");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          actions: [
            IconButton(
              onPressed: () async {
                List<Map<String, dynamic>> list =
                    await TeaDB.instance.getListOfTables();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TableList(list: list)),
                );
              },
              icon: Icon(Icons.table_bar),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                displaydate.toString(),
                style: TextStyle(
                    color: Color.fromARGB(255, 99, 42, 145),
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        drawer: CustomDrawer(),
        body: Consumer<Controller>(
          builder: (BuildContext context, Controller value, Widget? child) =>
              Column(
            // shrinkWrap: true,
            children: [
              Container(
                color: Colors.lightGreen,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 11.0, left: 08),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                buildRoutePopupDialog(context, size);
                              },
                              icon: Icon(Icons.location_on_outlined)),
                          Container(
                            padding: EdgeInsets.all(7),
                            // decoration: BoxDecoration(
                            //     border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              value.selectedrut == null
                                  ? "Choose Route"
                                  : value.selectedrut!.toUpperCase(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 11.0, left: 08, bottom: 11.0),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                if (value.selectedrut != null) {
                                  print(
                                      "route selected---------> ${value.selectedrut}");
                                  supdio.showSupplierDialog(context);
                                  // buildSupplierPopupDialog(context, size);
                                } else {
                                  CustomSnackbar snak = CustomSnackbar();
                                  snak.showSnackbar(
                                      context, "Select Route", "");
                                }
                              },
                              icon: Icon(Icons.person)),
                          Container(
                            padding: EdgeInsets.all(7),
                            // decoration: BoxDecoration(
                            //     border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              value.selectedsuplier == null
                                  ? "Choose Supplier"
                                  : value.selectedsuplier!.toUpperCase(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      width: size.width,
                      child: TabBar(controller: _tabController, tabs: [
                        Tab(
                          text: 'Collection',
                          // icon: Icon(Icons.settings_input_composite_outlined)
                        ),
                        Tab(
                          text: 'Advance',
                          // icon: Icon(Icons.money_rounded),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: size.height * 0.75,
                    child: TabBarView(
                      // physics:NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: <Widget>[
                        collectionWidget(size),
                        advanceWidget(size),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildRoutePopupDialog(BuildContext context, Size size) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              content: Consumer<Controller>(builder: (context, value, child) {
                if (value.isLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: Colors.grey[100],
                        height: size.height * 0.06,
                        child: DropdownButton<Map<String, dynamic>>(
                          hint: Text("Select Route"),
                          value: selectedRoute,
                          onChanged: (Map<String, dynamic>? newValue) async {
                            setState(() {
                              selectedRoute = newValue;
                              print("selected root---$selectedRoute");
                            });
                            await Provider.of<Controller>(context,
                                    listen: false)
                                .setSelectedroute(selectedRoute!);
                          },
                          items: value.routeList
                              .map<DropdownMenuItem<Map<String, dynamic>>>(
                                  (Map<String, dynamic> route) {
                            return DropdownMenuItem<Map<String, dynamic>>(
                              value: route,
                              child: Text(route['routename']),
                            );
                          }).toList(),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if (selectedRoute != null) {
                              print("---------$selectedRoute");
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              int? rid = prefs.getInt("sel_rootid");
                              Provider.of<Controller>(context, listen: false)
                                  .getSupplierfromDB(rid);
                              Navigator.pop(context);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "This is a Toast message",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          child: const Text("save"))
                    ],
                  );
                }
              }),
            );
          });
        });
  }

  buildSupplierPopupDialog(BuildContext context, Size size) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              content: Consumer<Controller>(builder: (context, value, child) {
                if (value.isLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: Colors.grey[100],
                        height: size.height * 0.06,
                        child: DropdownButton<Map<String, dynamic>>(
                          hint: Text("Select Supplier"),
                          value: selectedSpplierrr,
                          onChanged: (Map<String, dynamic>? newValue) async {
                            setState(() {
                              selectedSpplierrr = newValue;
                              print("selected supl---$selectedSpplierrr");
                            });
                            await Provider.of<Controller>(context,
                                    listen: false)
                                .setSelectedsupplier(selectedSpplierrr!);
                          },
                          items: value.spplierList
                              .map<DropdownMenuItem<Map<String, dynamic>>>(
                                  (Map<String, dynamic> supp) {
                            return DropdownMenuItem<Map<String, dynamic>>(
                              value: supp,
                              child: Text(supp['acc_name']),
                            );
                          }).toList(),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if (selectedSpplierrr != null) {
                              // SharedPreferences prefs =
                              //     await SharedPreferences.getInstance();
                              // int? rid = prefs.getInt("sel_rootid");
                              // Provider.of<Controller>(context, listen: false)
                              //     .getSupplierfromDB(rid);
                            }

                            Navigator.pop(context);
                          },
                          child: const Text("save"))
                    ],
                  );
                }
              }),
            );
          });
        });
  }

  Widget advanceWidget(Size size) {
    return Consumer<Controller>(
        builder: (BuildContext context, Controller value, Widget? child) =>
            Padding(
                padding: EdgeInsets.only(top: 20, left: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            // Container(
                            //     padding: EdgeInsets.all(10),
                            //     // color: Colors.yellow,
                            //     width: size.width * 1 / 3.5,
                            //     child: Text("Amount")),
                            Flexible(
                                child: TextField(
                              controller: dateInput,
                              //editing controller of this TextField
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(Icons
                                      .calendar_today), //icon of text field
                                  labelText:
                                      "Accountable Date" //label text of field
                                  ),
                              readOnly: true,
                              //set it true, so that user will not able to edit text
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1950),
                                    //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2100));

                                if (pickedDate != null) {
                                  print(
                                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                  String formattedDate =
                                      // DateFormat('yyyy-MM-dd')
                                      DateFormat('dd-MM-yyyy')
                                          .format(pickedDate);
                                  savedate = DateFormat('yyyy-MM-dd')
                                      .format(pickedDate);
                                  print(
                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                  setState(() {
                                    dateInput.text =
                                        formattedDate; //set output date to TextField value.
                                  });
                                } else {}
                              },
                            ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 12,
                        ),
                        child: Row(
                          children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                // color: Colors.yellow,
                                width: size.width * 1 / 3.5,
                                child: Text("Amount")),
                            Flexible(
                                child: customTextfield(
                                    adv_amt_ctrl, 1, TextInputType.phone))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 12,
                        ),
                        child: Row(
                          children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                // color: Colors.yellow,
                                width: size.width * 1 / 3.5,
                                child: Text("Narration")),
                            Flexible(
                                child: customTextfield(
                                    adv_narratn_ctrl, 2, TextInputType.text))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 30,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width * 0.7,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                ),
                                onPressed: () async {
                                  if (value.selectedsuplier != "" &&
                                      value.selectedsuplier
                                              .toString()
                                              .toLowerCase() !=
                                          "null" &&
                                      value.selectedsuplier
                                          .toString()
                                          .isNotEmpty &&
                                      value.selectedrut != null &&
                                      adv_amt_ctrl.text != "" &&
                                      adv_narratn_ctrl.text != "") {
                                    int max = await TeaDB.instance
                                        .getMaxCommonQuery(
                                            'AdvanceTable', 'trans_id', " ");
                                    print("int max---- $max");

                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString(
                                        "log_date", date.toString());
                                    int? supId = prefs.getInt("sel_accid");
                                    String? supName =
                                        prefs.getString("sel_accnm");
                                    String? ts = prefs.getString("t_series");
                                    print(
                                        "supl id: $supId , supName: $supName , tseris: $ts");

                                    value.advanceMasterMap["trans_id"] = max;
                                    value.advanceMasterMap["adv_series"] = ts;
                                    value.advanceMasterMap["adv_date"] =
                                        date.toString();
                                    // transactDate;
                                    value.advanceMasterMap["adv_party_id"] =
                                        supId.toString();
                                    value.advanceMasterMap["adv_pay_mode"] =
                                        "1";
                                    value.advanceMasterMap["adv_pay_acc"] = "";
                                    value.advanceMasterMap["adv_amt"] =
                                        adv_amt_ctrl.text.toString();
                                    value.advanceMasterMap["adv_narration"] =
                                        adv_narratn_ctrl.text.toString();
                                    value.advanceMasterMap["adv_acc_date"] =
                                        savedate.toString();
                                    // "25,21,65,985";
                                    value.advanceMasterMap["adv_import_id"] =
                                        "0";
                                    value.advanceMasterMap["company_id"] =
                                        c_id.toString();
                                    value.advanceMasterMap["branch_id"] =
                                        br_id.toString();
                                    value.advanceMasterMap["log_date"] =
                                        date.toString();
                                    value.advanceMasterMap["status"] = 0;

                                    await Provider.of<Controller>(context,
                                            listen: false)
                                        .insertAdvancetoDB(
                                            value.advanceMasterMap);
                                    print(
                                        "advanceMasterMap---> ${value.advanceMasterMap}");
                                    Fluttertoast.showToast(
                                        backgroundColor: Colors.green,
                                        msg: "Advance Added",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        textColor: Colors.black,
                                        fontSize: 16.0);
                                    adv_amt_ctrl.clear();
                                    adv_narratn_ctrl.clear();
                                    dateInput.clear();
                                    savedate = "";
                                  } else {
                                    CustomSnackbar snak = CustomSnackbar();
                                    snak.showSnackbar(
                                        context, "Fill all fields", "");
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    "ADD ADVANCE",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ])));
  }

  Widget collectionWidget(Size size) {
    return Consumer<Controller>(
      builder: (BuildContext context, Controller value, Widget? child) =>
          Padding(
        padding: EdgeInsets.only(top: 20, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: [
                  Container(
                      padding: EdgeInsets.all(10),
                      // color: Colors.yellow,
                      width: size.width * 1 / 3.5,
                      child: Text("No.of Bag")),
                  Flexible(
                      child:
                          customTextfield(bagno_ctrl, 1, TextInputType.phone))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 12, right: 10),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    // color: Colors.yellow,
                    width: size.width * 1 / 3.5,
                    child: Text("Weight"),
                  ),
                  Flexible(
                      child: customTextfield(wgt_ctrl, 1, TextInputType.phone))
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: DataTable(
                // border: TableBorder.all(color: Colors.black),
                columnSpacing: 20,
                columns: <DataColumn>[
                  DataColumn(
                    headingRowAlignment: MainAxisAlignment.start,
                    label: Text(
                      textAlign: TextAlign.start,
                      'Product',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Collected',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Damage',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Total',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: value.prodList.asMap().entries.map((entry) {
                  int index = entry.key;
                  var element = entry.value;
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text(element['product'])),
                      DataCell(
                        Container(
                          width: size.width * 0.14,
                          child: TextFormField(
                            decoration: InputDecoration(hintText: ""),
                            onTap: () {
                              // Perform any action using the index
                            },
                            onChanged: (value) async {
                              await Provider.of<Controller>(context,
                                      listen: false)
                                  .updateTotal(index);
                            },
                            style: TextStyle(
                              fontSize: 15.0,
                            ),

                            keyboardType: TextInputType.number,
                            // onSubmitted: (values) {
                            //   // Perform any action using the index
                            // },
                            textAlign: TextAlign.center,
                            controller: value.colected[index],
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: size.width * 0.14,
                          child: TextFormField(
                            decoration: InputDecoration(hintText: ""),
                            onTap: () {
                              // Perform any action using the index
                            },
                            onChanged: (value) async {
                              await Provider.of<Controller>(context,
                                      listen: false)
                                  .updateTotal(index);
                            },
                            style: TextStyle(
                              fontSize: 15.0,
                            ),

                            keyboardType: TextInputType.number,
                            // onSubmitted: (values) {
                            //   // Perform any action using the index
                            // },
                            textAlign: TextAlign.center,
                            controller: value.damage[index],
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: size.width * 0.14,
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: "",
                              border: InputBorder.none,
                            ),
                            onTap: () {
                              // Perform any action using the index
                            },
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                            textAlign: TextAlign.center,
                            controller: value.total[index],
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 30,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.7,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () async {
                        if (value.selectedsuplier != "" &&
                            value.selectedsuplier.toString().toLowerCase() !=
                                "null" &&
                            value.selectedsuplier.toString().isNotEmpty &&
                            value.selectedrut != null &&
                            bagno_ctrl.text != "" &&
                            wgt_ctrl.text != "") {
                          int max = await TeaDB.instance.getMaxCommonQuery(
                              'TransMasterTable', 'trans_id', " ");
                          print("int max---- $max");
                          print(
                              "sel suppl----------------------${value.selectedsuplier.toString()}");
                          // int transid = await randomNo();
                          final prefs = await SharedPreferences.getInstance();
                          int? supId = prefs.getInt("sel_accid");
                          String? supName = prefs.getString("sel_accnm");
                          String? ts = prefs.getString("t_series");

                          print(
                              "supl id : $supId , supName : $supName , tseris : $ts");

                          value.transMasterMap["trans_id"] = max;
                          value.transMasterMap["trans_series"] = ts;
                          value.transMasterMap["trans_date"] = transactDate;
                          value.transMasterMap["trans_party_id"] =
                              supId.toString();
                          value.transMasterMap["trans_party_name"] = supName;
                          value.transMasterMap["trans_remark"] = "Remarks";
                          value.transMasterMap["trans_bag_nos"] =
                              bagno_ctrl.text.toString();
                          value.transMasterMap["trans_bag_weights"] =
                              wgt_ctrl.text.toString();
                          // "25,21,65,985";
                          value.transMasterMap["trans_import_id"] = "0";
                          value.transMasterMap["company_id"] = c_id.toString();
                          value.transMasterMap["branch_id"] = br_id.toString();
                          value.transMasterMap["user_session"] = "245";
                          value.transMasterMap["log_user_id"] = u_id.toString();
                          value.transMasterMap["hidden_status"] = "0";
                          value.transMasterMap["row_id"] = "0";
                          value.transMasterMap["log_user_name"] =
                              uname.toString();
                          value.transMasterMap["log_date"] = date.toString();
                          value.transMasterMap["status"] = 0;
                          for (int i = 0; i < value.prodList.length; i++) {
                            Map<String, dynamic> transDetailstempMap = {};
                            int pid = value.prodList[i]['pid'];
                            String product = value.prodList[i]
                                ['product']; // Get the product name
                            String collected = value
                                .colected[i].text; // Get the collected value
                            String damage =
                                value.damage[i].text; // Get the damage value
                            String total =
                                value.total[i].text; // Get the total value
                            print("pid---$pid");
                            print("pName---$product");
                            print(
                                "Coll----damg----totl---$collected---$damage---$total");
                            transDetailstempMap["trans_det_mast_id"] =
                                "$ts$max";
                            transDetailstempMap["trans_det_prod_id"] = pid;
                            transDetailstempMap["trans_det_col_qty"] =
                                collected;
                            transDetailstempMap["trans_det_dmg_qty"] = damage;
                            transDetailstempMap["trans_det_net_qty"] = total;
                            transDetailstempMap["trans_det_unit"] = "KG";
                            transDetailstempMap["trans_det_rate_id"] = "0";
                            transDetailstempMap["trans_det_value"] = "0";
                            transDetailstempMap["trans_det_import_id"] = "0";
                            transDetailstempMap["company_id"] = c_id.toString();
                            transDetailstempMap["branch_id"] = br_id.toString();
                            transDetailstempMap["log_user_id"] =
                                u_id.toString();
                            transDetailstempMap["user_session"] = "245";
                            transDetailstempMap["log_date"] = date.toString();
                            transDetailstempMap["status"] = 0;
                            // Create a ProductData object and add it to the list
                            print(
                                "transdetails Map -----$i---${transDetailstempMap}");
                            value.transdetailsList.add(transDetailstempMap);
                          }
                          await Provider.of<Controller>(context, listen: false)
                              .insertTransDetailstoDB(value.transdetailsList);
                          print("transdetails List-${value.transdetailsList}");
                          await Provider.of<Controller>(context, listen: false)
                              .insertTransMastertoDB(value.transMasterMap);
                          value.transMasterMap["details"] =
                              value.transdetailsList;
                          print("transMaster Map-${value.transMasterMap}");
                          value.transdetailsList.clear();
                          Fluttertoast.showToast(
                              backgroundColor: Colors.green,
                              msg: "Collection Added",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.black,
                              fontSize: 16.0);
                          bagno_ctrl.clear();
                          wgt_ctrl.clear();
                          await Provider.of<Controller>(context, listen: false)
                              .getProductsfromDB();
                        } else {
                          CustomSnackbar snak = CustomSnackbar();
                          snak.showSnackbar(context, "Fill all fields", "");
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          "ADD COLLECTION",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  randomNo() {
    int rr = 0;
    var rng = Random();
    for (var i = 0; i < 10; i++) {
      rr = rng.nextInt(100);
      print("randoooomm--------${rng.nextInt(100)}");
    }
    return rr;
  }

  TextFormField customTextfield(
      TextEditingController contr, int? maxline, TextInputType typ) {
    return TextFormField(
      keyboardType: typ,
      controller: contr,
      maxLines: maxline,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 199, 198, 198),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 199, 198, 198),
              width: 1.0,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 3,
            ),
          ),
          hintText: ""),
    );
  }
}

Future<bool> _onBackPressed(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        // title: const Text('AlertDialog Title'),
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ListBody(
            children: const <Widget>[
              Text('Want to exit from this app'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              exit(0);
            },
          ),
        ],
      );
    },
  );
}
