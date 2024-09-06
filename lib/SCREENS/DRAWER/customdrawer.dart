import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsupply/SCREENS/AUTH/login.dart';
import 'package:tsupply/SCREENS/COLLECTION/collection.dart';
import 'package:tsupply/SCREENS/DOWNLOAD/downloadpage.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class DrawerItems {
  String title;
  Icon icon;
  DrawerItems({required this.title, required this.icon});
}

List itemList = [
  DrawerItems(title: "Dashboard", icon: Icon(Icons.dashboard)),
  DrawerItems(title: "Download", icon: Icon(Icons.download_outlined)),
  DrawerItems(title: "Logout", icon: Icon(Icons.exit_to_app_rounded)),
];

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Center(child: Text('TEA SUPPLY')),
            decoration: BoxDecoration(
              color: Colors.lightGreen,
            ),
          ),
          ...List.generate(itemList.length, (index) {
            return InkWell(
              child: ListTile(
                title: Text(itemList[index].title.toString()),
              ),
              onTap: () async {
                if (index == 0) {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                        opaque: false, // set to false
                        pageBuilder: (_, __, ___) => CollectionPage()),
                  );
                } else if (index == 1) {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                        opaque: false, // set to false
                        pageBuilder: (_, __, ___) => DownLoadPage()),
                  );
                } else if (index == 2) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('u_id');
                  await prefs.remove('uname');
                  await prefs.remove('upwd');
                  print("...............log cleared");
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => USERLogin()));
                }
              },
            );
          })
          // ListTile(
          //   title: Text('Item 1'),
          //   onTap: () {
          //     // Update the state of the app.
          //     // ...
          //   },
          // ),
          // ListTile(
          //   title: Text('Item 2'),
          //   onTap: () {
          //     // Update the state of the app.
          //     // ...
          //   },
          // ),
        ],
      ),
    );
  }
}
