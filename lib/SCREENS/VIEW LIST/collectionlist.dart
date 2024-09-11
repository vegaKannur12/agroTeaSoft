import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:tsupply/SCREENS/DRAWER/customdrawer.dart';
import 'dart:io';
class CollectionList extends StatefulWidget {
  const CollectionList({super.key});

  @override
  State<CollectionList> createState() => _CollectionListState();
}

class _CollectionListState extends State<CollectionList>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Center(
              child: Text(
            "COLLECTIONS",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          backgroundColor: Colors.lightGreen,
        ),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          //   finalbagListloading
          child: Consumer<Controller>(
              builder: (BuildContext context, Controller value, Widget? child) {
            if (value.finalbagListloading) {
              return const CircularProgressIndicator();
            } else {
              return Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: value.finalBagList[0]["transactions"].length,
                      itemBuilder: ((context, index) {
                        List list = value.finalBagList[0]["transactions"];
                        print("list---  > $list");
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            color: Color.fromARGB(255, 243, 244, 245),
                            margin: EdgeInsets.all(8),
                            child: ListTile(
                              title: Text(
                                "${list[index]["details"][0]["trans_det_mast_id"].toString()}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(children: [
                                      SizedBox(
                                        width: 65,
                                        child: Text(
                                          textAlign: TextAlign.left,
                                          "Party",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        textAlign: TextAlign.left,
                                        // maxLines: 2,
                                        // "SDFGGGTHHJJJJJJJJSSShjhjhj",
                                        " : ${list[index]["trans_party_name"].toString()}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ]),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(children: [
                                      SizedBox(
                                        width: 65,
                                        child: Text(
                                          textAlign: TextAlign.left,
                                          "Trans ID",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        textAlign: TextAlign.left,
                                        // maxLines: 2,
                                        // "SDFGGGTHHJJJJJJJJSSShjhjhj",
                                        " : ${list[index]["trans_id"].toString()}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                              trailing: list[index]["trans_import_id"]
                                          .toString() ==
                                      "0"
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            content:
                                                Text("Do you want to delete?"),
                                            actions: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton(
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors.black),
                                                    onPressed: () async {
                                                      await Provider.of<
                                                                  Controller>(
                                                              context,
                                                              listen: false)
                                                          .deleteTrans(
                                                              list[index]
                                                                  ["trans_id"],
                                                              context);
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    child: Text(
                                                      "Yes",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  ElevatedButton(
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors.black),
                                                    onPressed: () {
                                                      Navigator.of(ctx).pop();
                                                    },
                                                    child: Text(
                                                      "No",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white),
                                          color: Colors.yellow,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Text(
                                        "${list[index]["trans_import_id"].toString()}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      )),
                              selectedTileColor: Colors.blue.withOpacity(0.5),
                            ),
                          ),
                        );
                      })),
                ],
              );
            }
          }),
        ),
      ),
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