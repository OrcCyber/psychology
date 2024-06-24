import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:SomeOne/presentation/bottom_nav.dart';
import 'package:SomeOne/presentation/pages/login/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription? _sub;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  Future<void> initUniLinks() async {
    try {
      _sub = uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          _navigateToPage(uri);
        }
      }, onError: (Object err) {
        print("Failed to listen uri");
        print(err.toString());
      });
    } on FormatException catch (e) {
      print("Bad link format");
      print(e.toString());
    } on Exception catch (e) {
      print("Failed to handle uri");
      print(e.toString());
    }
  }

  void _navigateToPage(Uri uri) {
    if (uri.path == '/login') {
      setState(() {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const BottomNav()),
        );
      });
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const  LoginPage();
  }
}
