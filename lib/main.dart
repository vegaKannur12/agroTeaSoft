import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsupply/CONTROLLER/controller.dart';
import 'package:tsupply/SCREENS/AUTH/login.dart';
import 'package:tsupply/SCREENS/COLLECTION/collection.dart';
import 'package:tsupply/SCREENS/splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Controller()),
     
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: 
        SplashScreen()
        // CollectionPage()
        // USERLogin(),
        );
  }
}
