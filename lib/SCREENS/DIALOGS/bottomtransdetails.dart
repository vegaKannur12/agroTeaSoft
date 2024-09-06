import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tsupply/CONTROLLER/controller.dart';

class TransDetailsBottomSheet {
  List rawCalcResult = [];
  List splitted = [];
  // String? selected;
  ValueNotifier<bool> visible = ValueNotifier(false);
  showTransDetailsMoadlBottomsheet(
    BuildContext context,
    Size size,

    // String os,
    String date,
  ) async {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Consumer<Controller>(
            builder: (context, value, child) {
              return SingleChildScrollView(
                child: Container(
                  // height: size.height * 0.96,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: value.isLoading
                        ? SpinKitFadingCircle(color: Colors.black)
                        : Column(
                            // mainAxisSize:MainAxisSize.min ,
                            // spacing: 5,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: DataTable(
                                  // border: TableBorder.all(color: Colors.black),
                                  columnSpacing: 13,
                                  columns: <DataColumn>[
                                    DataColumn(
                                      label: Text(
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
                                  rows: value.prodList
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    int index = entry.key;
                                    var element = entry.value;
                                    return DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text(element['product'])),
                                        DataCell(
                                          Container(
                                            width: size.width * 0.14,
                                            child: TextFormField(
                                                   decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 199, 198, 198),
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 199, 198, 198),
                                                  width: 1.0,
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 3,
                                                ),
                                              ),
                                              hintText: ""),
                                              onTap: () {
                                                // Perform any action using the index
                                              },
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              ),
                                             
                                              keyboardType:
                                                  TextInputType.number,
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
                                                   decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 199, 198, 198),
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 199, 198, 198),
                                                  width: 1.0,
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 3,
                                                ),
                                              ),
                                              hintText: ""),
                                              onTap: () {
                                                // Perform any action using the index
                                              },
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              ),
                                             
                                              keyboardType:
                                                  TextInputType.number,
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
                                                   decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 199, 198, 198),
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: const Color.fromARGB(
                                                      255, 199, 198, 198),
                                                  width: 1.0,
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: const BorderSide(
                                                  color: Colors.black,
                                                  width: 3,
                                                ),
                                              ),
                                              hintText: ""),
                                              onTap: () {
                                                // Perform any action using the index
                                              },
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              ),
                                             
                                              keyboardType:
                                                  TextInputType.number,
                                              // onSubmitted: (values) {
                                              //   // Perform any action using the index
                                              // },
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
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15, bottom: 18),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: size.width * 0.4,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.amber),
                                            onPressed: () async {
                                              // int indexCalc = index + 1;

                                              // int max = await OrderAppDB
                                              //     .instance
                                              //     .getMaxCommonQuery(
                                              //         'orderBagTable',
                                              //         'cartrowno',
                                              //         "os='${os}' AND customerid='${customerId}'");
                                              // var pid =
                                              //     value.orderitemList2[index]
                                              //         ['prid'];
                                              // if (value.qty[index].text !=
                                              //         null &&
                                              //     value.qty[index].text
                                              //         .isNotEmpty) {
                                              //   double total = double.parse(
                                              //           value
                                              //               .orderrate_X001[
                                              //                   index]
                                              //               .text) *
                                              //       double.parse(
                                              //           value.qty[index].text);

                                              //   double baseRate = double.parse(
                                              //           value
                                              //               .orderrate_X001[
                                              //                   index]
                                              //               .text) /
                                              //       value.package!;
                                              //   print("rateggg----$baseRate");

                                              //   await OrderAppDB.instance
                                              //       .insertorderBagTable_X001(
                                              //           item,
                                              //           date,
                                              //           time,
                                              //           os,
                                              //           customerId,
                                              //           max,
                                              //           code,
                                              //           double.parse(value
                                              //               .qty[index].text),
                                              //           value
                                              //               .orderrate_X001[
                                              //                   index]
                                              //               .text,
                                              //           total.toString(),
                                              //           pid,
                                              //           value.selectedItem,
                                              //           value.package!,
                                              //           baseRate,
                                              //           0);
                                              //   Fluttertoast.showToast(
                                              //     msg:
                                              //         "$item Added Successfully",
                                              //     toastLength:
                                              //         Toast.LENGTH_SHORT,
                                              //     gravity: ToastGravity.CENTER,
                                              //     timeInSecForIosWeb: 1,
                                              //     textColor: Colors.white,
                                              //     fontSize: 14.0,
                                              //     backgroundColor: Colors.green,
                                              //   );
                                              //   Provider.of<Controller>(context,
                                              //           listen: false)
                                              //       .countFromTable(
                                              //     "orderBagTable",
                                              //     os,
                                              //     customerId,
                                              //   );
                                              // } else {
                                              //   // await OrderAppDB.instance
                                              //   //     .upadteCommonQuery(
                                              //   //         "orderBagTable",
                                              //   //         "rate=${value.orderrate_X001[index].text},totalamount=${value.orderNetAmount},qty=${value.qty[index].text}",
                                              //   //         "code='$code' and customerid='$customerId' and unit_name='${value.selectedItem}'");
                                              //   print("calculate new total");
                                              //   await Provider.of<Controller>(
                                              //           context,
                                              //           listen: false)
                                              //       .calculatesalesTotal(
                                              //           os, customerId);
                                              //   Provider.of<Controller>(context,
                                              //           listen: false)
                                              //       .getBagDetails(
                                              //           customerId, os);
                                              // }

                                              // Provider.of<Controller>(context,
                                              //         listen: false)
                                              //     .calculateorderTotal(
                                              //         os, customerId);

                                              // Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Add ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white),
                                            )))
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              );
            },
          );
        });
  }

  //////////////////
}
