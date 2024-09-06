import 'package:flutter/material.dart';
import 'package:tsupply/SCREENS/DRAWER/customdrawer.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({super.key});

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,     
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(),
    );
  }
}
