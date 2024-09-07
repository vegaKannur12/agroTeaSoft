import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:tsupply/SCREENS/DRAWER/customdrawer.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({super.key});

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage>
    with SingleTickerProviderStateMixin {
  Set<int> selectedIndexes = {};
  List selectedtransIDs = [];
  late AnimationController _controller;
  late Animation<double> _animation;
  int? currentSelectedIndex;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Consumer<Controller>(
          builder: (BuildContext context, Controller value, Widget? child) =>
              Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: value.finalSaveList[0]["transactions"].length,
                  itemBuilder: ((context, index) {
                    List list = value.finalSaveList[0]["transactions"];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedIndexes.contains(index)) {
                            selectedIndexes.remove(index);
                            currentSelectedIndex =
                                null; // Reset current selected index
                            selectedtransIDs
                                .remove(list[index]["trans_id"].toString());
                            print("selected IDs== $selectedtransIDs");
                          } else {
                            selectedIndexes.add(index);
                            currentSelectedIndex =
                                index; // Update current selected index
                            selectedtransIDs
                                .add(list[index]["trans_id"].toString());
                            print("selected IDs== $selectedtransIDs");
                          }
                        });
                        _startAnimation();
                      },
                      child: Container(
                        color: Color.fromARGB(255, 243, 244, 245),
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(
                              "${list[index]["details"][0]["trans_det_mast_id"].toString()}"),
                          subtitle: Column(
                            children: [
                              Text(
                                  "${list[index]["trans_party_name"].toString()}"),
                              Text("${list[index]["trans_id"].toString()}"),
                            ],
                          ),
                          leading: AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return CircleAvatar(
                                  child: currentSelectedIndex == index
                                      ? Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.identity()
                                            ..rotateY(3.14)
                                            ..rotateY(_animation.value * 3.14),
                                          child: Icon(
                                            Icons.check,
                                          ),
                                        )
                                      : selectedIndexes.contains(index)
                                          ? Icon(
                                              Icons.check,
                                            )
                                          : Icon(
                                              Icons.touch_app,
                                            ));
                            },
                          ),
                          selected: selectedIndexes.contains(index),
                          selectedTileColor: Colors.blue.withOpacity(0.5),
                        ),
                      ),
                    );
                  })),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          await Provider.of<Controller>(context,
                  listen: false) // import code to be uncommented
              .importFinal(context, selectedtransIDs);
        },
        child: const Icon(Icons.upload),
        //  Text("IMPORT")
      ),
    );
  }
}
