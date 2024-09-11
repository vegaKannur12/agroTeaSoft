import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:tsupply/SCREENS/DRAWER/customdrawer.dart';
import 'dart:io';
class DownLoadPage extends StatefulWidget {
  const DownLoadPage({super.key});

  @override
  State<DownLoadPage> createState() => _DownLoadPageState();
}

class _DownLoadPageState extends State<DownLoadPage> {
  String? formattedDate;
  List s = [];
  DateTime date = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
    s = formattedDate!.split(" ");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.teal,
      
            // title: Text("Company Details",style: TextStyle(fontSize: 20),),
          ),
          drawer: CustomDrawer(),
          body: SingleChildScrollView(
            child: Consumer<Controller>(
              builder: (BuildContext context, Controller value, Widget? child) =>
                  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: value.downloadItems.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Ink(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black45),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: ListTile(
                              // leading: Icon(Icons.abc),
                              title: Center(
                                  child: Text(
                                value.downloadItems[index].toUpperCase(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )),
                              trailing: IconButton(
                                onPressed: value.downloading[index]
                                    ? null // Disable the button while downloading
                                    : () {
                                        if (value.downloadItems[index] ==
                                            "Route") {
                                          Provider.of<Controller>(context,
                                                  listen: false)
                                              .getRouteDetails(
                                                  index, "", context);
                                        } else if (value.downloadItems[index] ==
                                            "Supplier Details") {
                                          Provider.of<Controller>(context,
                                                  listen: false)
                                              .getACMasterDetails(index, "");
                                          //           Provider.of<Controller>(context, listen: false)
                                          // .getSupplierfromDB(" ");
                                        } else if (value.downloadItems[index] ==
                                            "Product Details") {
                                          Provider.of<Controller>(context,
                                                  listen: false)
                                              .getProductDetails(index, "");
                                        } else if (value.downloadItems[index] ==
                                            "User Details") {
                                          Provider.of<Controller>(context,
                                                  listen: false)
                                              .getUserDetails(index, "");
                                        } else {}
                                      },
                                icon: value.downloading[index]
                                    ? SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          color: Colors.black,
                                        ),
                                      )
                                    : value.downlooaded[index]
                                        ? Icon(
                                            Icons.done,
                                            color: Colors.black,
                                          )
                                        : Icon(
                                            Icons.download,
                                            color: Colors.black,
                                          ),
                              ),
                            ),
                          ),
                        );
                      }),
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Ink(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: ListTile(
                      
                        title: Center(
                            child: Text(
                          "Upload Collection ( ${value.importtransMasterList.length} )",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )),
                        trailing: IconButton(
                          onPressed: value.colluploading
                              ? null // Disable the button while downloading
                              : () async{
                                 await Provider.of<Controller>(context,
                                  listen: false) // import code to be uncommented
                              .importFinal(context);
                        },
                        icon:
                        value.colluploading
                            ? SizedBox(
                                height:25,width: 25,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  color: Colors.black,
                                ),
                              )
                            : value.colluploaded
                                ? Icon(
                                    Icons.done,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.upload,
                                    color: Colors.red,
                                  ),
                      ),
                    ),
                  ),),
                   Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Ink(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: ListTile(
                      
                        title: Center(
                            child: Text(
                          "Upload Advance ( ${value.importAdvanceList.length} )",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )),
                        trailing: IconButton(
                          onPressed: value.advuploading
                              ? null // Disable the button while downloading
                              : () async{
                                 await Provider.of<Controller>(context,
                                  listen: false) // import code to be uncommented
                              .importAdvanceFinal(context);
                        },
                        icon:
                        value.advuploading
                            ? SizedBox(
                                height:25,width: 25,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  color: Colors.black,
                                ),
                              )
                            : value.advuploaded
                                ? Icon(
                                    Icons.done,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.upload,
                                    color: Colors.red,
                                  ),
                      ),
                    ),
                  ),)
                ],
              ),
            ),
          )),
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