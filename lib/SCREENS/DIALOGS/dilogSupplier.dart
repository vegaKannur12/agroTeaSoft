import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsupply/CONTROLLER/controller.dart';

class DialogSupplier {
  showSupplierDialog(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    TextEditingController seacrh = TextEditingController();

    String date = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? phh = prefs.getString("ph");
    print("siccccccccccc-${size.height / 1.5}");
    Dialog fancyDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Consumer<Controller>(
        builder: (BuildContext context, Controller value, Widget? child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            height: value.filteredlist.length == 1
                ? size.height * 0.15
                : (size.height * 0.09) * value.filteredlist.length,
            //1
            width: size.width,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 65),
                  child: value.isLoading
                      ? Align(
                          alignment: Alignment.center,
                          child: SpinKitCircle(
                            color: const Color.fromARGB(255, 53, 46, 46),
                          ),
                        )
                      : value.filteredlist.isEmpty
                          ? Center(
                              child: Lottie.asset("assets/datano.json",
                                  height: size.height * 0.15))
                          : ListView.builder(
                              itemCount: 
                              value.filteredlist.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                print(
                                    "len--------------${value.filteredlist.length}");
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: InkWell(
                                        onTap: () async {
                                          await Provider.of<Controller>(context,
                                                  listen: false)
                                              .setSelectedsupplier(
                                                  value.filteredlist[index]);
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(),
                                          width: size.width / 1.2,
                                          padding: EdgeInsets.all(7),
                                          child: Text(
                                            // "FGDHDHTH HDFHDFH - HDFHDTHYF HGTEWEWAHL<L<K<",
                                            "${value.filteredlist[index]["acc_name"].toString().trimLeft().toUpperCase()}",
                                            textAlign: TextAlign.left,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.black45,
                                    )
                                  ],
                                );
                              }),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(241, 235, 236, 236),
                      ),
                      child: TextFormField(
                        controller: seacrh,
                        //   decoration: const InputDecoration(,
                        onChanged: (val) {
                          // setState(() {
                          Provider.of<Controller>(context, listen: false)
                              .searchSupplier(
                                  val.toString());
                          // });
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () {
                              // setState(() {
                              print("pressed");
                              seacrh.clear();
                              // Provider.of<Controller>(context, listen: false)
                              //     .getserviceCategoryList(context, "");
                              // Provider.of<Controller>(context, listen: false)
                              //     .searchRoom("");
                              // });
                            },
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: "Search Supplier",
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  // These values are based on trial & error method
                  alignment: Alignment(1.05, -1.05),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }
}
