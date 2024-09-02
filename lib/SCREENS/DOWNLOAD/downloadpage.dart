import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:tsupply/SCREENS/DRAWER/customdrawer.dart';

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
    return Scaffold(
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
                Container(
                    height: size.height * 0.9,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: value.downloadItems.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Ink(
                              decoration: BoxDecoration(border: Border.all(color: Colors.black45),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: ListTile(
                                // leading: Icon(Icons.abc),
                                title: Center(
                                    child: Text(
                                  value.downloadItems[index].toUpperCase(),
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                )),
                                trailing: IconButton(
                                  onPressed: value.downloading[index]
                                      ? null // Disable the button while downloading
                                      : () {
                                          if (value.downloadItems[index] ==
                                              "Route") {
                                            Provider.of<Controller>(context,
                                                    listen: false)
                                                .getRouteDetails(index, "");
                                          } else if (value
                                                  .downloadItems[index] ==
                                              "Supplier Details") {
                                            Provider.of<Controller>(context,
                                                    listen: false)
                                                .getACMasterDetails(index, "");
                                            //           Provider.of<Controller>(context, listen: false)
                                            // .getSupplierfromDB(" ");
                                          } 
                                          else if (value
                                                  .downloadItems[index] ==
                                              "Product Details") 
                                          {
                                            Provider.of<Controller>(context,
                                                    listen: false)
                                                .getProductDetails(index, "");
                                          } else if (value
                                                  .downloadItems[index] ==
                                              "User Details") 
                                          {
                                            Provider.of<Controller>(context,
                                                    listen: false)
                                                .getUserDetails(index, "");
                                          } 
                                          else 
                                          {

                                          }
                                        },
                                  icon: value.downloading[index]
                                      ? SizedBox(
                                          height:25,width: 25,
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
                        }))
              ],
            ),
          ),
        ));
  }
}
