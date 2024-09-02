import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsupply/COMPONENTS/custom_snackbar.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:tsupply/MODEL/routeModel.dart';
import 'package:tsupply/SCREENS/DIALOGS/bottomtransdetails.dart';
import 'package:tsupply/SCREENS/DRAWER/customdrawer.dart';

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
  late final TabController _tabController;
  TextEditingController bagno_ctrl = TextEditingController();
  TextEditingController wgt_ctrl = TextEditingController();
  Map<String, dynamic>? selectedRoute;
  Map<String, dynamic>? selectedSpplierrr;
  TransDetailsBottomSheet tdetbottom=TransDetailsBottomSheet();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    displaydate = DateFormat('dd-MM-yyyy').format(date);
    transactDate = DateFormat('yyyy-MM-dd').format(date);
    Provider.of<Controller>(context, listen: false).getRoute(" ", context);
    print(("-----$displaydate"));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        actions: [
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
            ListView(
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
                            style: TextStyle(color: Colors.black, fontSize: 18),
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
                              if (selectedRoute != null) {
                                print("---------$selectedRoute");
                                buildSupplierPopupDialog(context, size);
                              } else {
                                CustomSnackbar snak = CustomSnackbar();
                                snak.showSnackbar(context, "Select Route", "");
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
                            style: TextStyle(color: Colors.black, fontSize: 18),
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
                          icon: Icon(Icons.settings_input_composite_outlined)),
                      Tab(
                        text: 'Advance',
                        icon: Icon(Icons.money_rounded),
                      ),
                    ]),
                  )
                ],
              ),
            ),
            SizedBox(
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
          ],
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
                              // Provider.of<Controller>(context, listen: false)
                              //     .areaSelection(selected!);
                              // Provider.of<Controller>(context, listen: false)
                              //     .dashboardSummery(
                              //         sid!, s[0], selected!, context);
                              // String? genArea = Provider.of<Controller>(context,
                              //         listen: false)
                              //     .areaidFrompopup;
                              // if (genArea != null) {
                              //   gen_condition =
                              //       " and accountHeadsTable.area_id=$genArea";
                              // } else {
                              //   gen_condition = " ";
                              // }
                              // Provider.of<Controller>(context, listen: false)
                              //     .getCustomer(genArea!);
                              // // Provider.of<Controller>(context, listen: false)
                              // //     .todayOrder(s[0], gen_condition!);
                              // Provider.of<Controller>(context, listen: false)
                              //     .todayCollection(s[0], gen_condition!);
                              // Provider.of<Controller>(context, listen: false)
                              //     .todaySales(s[0], gen_condition!, "");
                              // // Provider.of<Controller>(context, listen: false)
                              // //     .selectReportFromOrder(
                              // //         context, sid!, s[0], "");
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
    return Padding(
        padding: EdgeInsets.only(top: 20, left: 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(children: [Text("Advance")]))
        ]));
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
                  Flexible(child: customTextfield(bagno_ctrl))
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
                  Flexible(child: customTextfield(wgt_ctrl))
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: size.width * 0.4,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          if (value.selectedsuplier != "" &&
                              value.selectedsuplier.toString().toLowerCase() !=
                                  "null" &&
                              value.selectedsuplier.toString().isNotEmpty &&
                              selectedRoute != null &&
                              bagno_ctrl.text != "" &&
                              wgt_ctrl.text != "") {
                            print(
                                "----------------------${value.selectedsuplier.toString()}");
                            final prefs = await SharedPreferences.getInstance();
                            int? supId = prefs.getInt("sel_accid");
                            String? supName = prefs.getString("sel_accnm");
                            value.transMasterMap.clear();
                            value.transMasterMap["id"] = 7;
                            value.transMasterMap["trans_series"] = "AB";
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
                            value.transMasterMap["trans_import_id"] = "23";
                            value.transMasterMap["company_id"] = "01";
                            value.transMasterMap["branch_id"] = "01";
                            value.transMasterMap["user_session"] = "245";
                            value.transMasterMap["log_user_id"] = "2";
                            value.transMasterMap["hidden_status"] = "0";
                            value.transMasterMap["row_id"] = "0";
                            value.transMasterMap["log_user_name"] = "user";
                            value.transMasterMap["log_date"] = "2024-09-02";
                            value.transMasterMap["status"] = 0;

                            // {
                            //   "id": 3,
                            //   "trans_series": "AB",
                            //   "trans_date": "2024-08-06",
                            //   "trans_party_id": "12",
                            //   "trans_party_name": "dhanush",
                            //   "trans_remark": "Remarks",
                            //   "trans_bag_nos": "4",
                            //   "trans_bag_weights": "25,21,65,985",
                            //   "trans_import_id": "23",
                            //   "company_id": "01",
                            //   "branch_id": "01",
                            //   "user_session": "245",
                            //   "log_user_id": "2",
                            //   "hidden_status": "0",
                            //   "row_id": "0",
                            //   "log_user_name": "user",
                            // };
                            await Provider.of<Controller>(context,
                                    listen: false)
                                .savetransmaster(value.transMasterMap);
                              await Provider.of<Controller>(context, listen: false)
                                  .getProductsfromDB();
                                tdetbottom.showTransDetailsMoadlBottomsheet(context, size,displaydate!);
                            // Fluttertoast.showToast(
                            //     msg: "This is a Toast message",
                            //     toastLength: Toast.LENGTH_SHORT,
                            //     gravity: ToastGravity.CENTER,
                            //     timeInSecForIosWeb: 1,
                            //     textColor: Colors.white,
                            //     fontSize: 16.0);
                          } else {
                            CustomSnackbar snak = CustomSnackbar();
                            snak.showSnackbar(context, "Fill all fields", "");
                          }
                        },
                        child: Text(
                          "ADD",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ))),
              ],
            )
          ],
        ),
      ),
    );
  }

  TextFormField customTextfield(TextEditingController contr) {
    return TextFormField(keyboardType: TextInputType.number,
      controller: contr,
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
