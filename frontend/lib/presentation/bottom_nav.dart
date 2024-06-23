import 'package:flutter/material.dart';
import 'package:frontend/presentation/constants.dart';
import 'package:get/get.dart';

import 'pages/chat/contact/contact_page.dart';
import 'pages/chat/message/chat_page.dart';
import 'pages/chat/setting/setting_page.dart';
class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final List _pageChat = [
    const ContactPage(),
    const ChatPage(),
    const SettingPage()
  ];
  int currentPageChat = 1;

  void NavigatorChatPage(int index) {
    setState(() {
      currentPageChat = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _pageChat[currentPageChat],
      bottomNavigationBar: 
         
          buildChatBottomNav(context),);
  }
  
  Widget buildChatBottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentPageChat,
      unselectedItemColor: Colors.grey,
      onTap: NavigatorChatPage,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF5177FF),
      backgroundColor: Colors.white,
      elevation: 0,
      selectedFontSize: 0,
      items: [
        bottomNavChatItem('contact', Images.nav5, currentPageChat == 0),
        bottomNavChatItem(
            'message', Images.navBottomChat, currentPageChat == 1),
        bottomNavChatItem(
            'setting', Images.chatSettingIcon, currentPageChat == 2),
      ],
    );
  }

  

  BottomNavigationBarItem bottomNavChatItem(
      String title, String icon, bool isActive) {
    return BottomNavigationBarItem(
        backgroundColor: Colors.transparent,
        icon: SizedBox(
          height: 50,
          width: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 4),
              ImageIcon(AssetImage(icon)),
              Text(
                title.tr,
                style: TextStyle(
                  color:
                      isActive ? const Color(0xff007AFF) :Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        label: "");
  }
}