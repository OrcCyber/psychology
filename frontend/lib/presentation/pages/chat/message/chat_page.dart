

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/data/models/chat_model.dart';
import 'package:frontend/data/models/directory_model.dart';
import 'package:frontend/presentation/constants.dart';
import 'package:frontend/presentation/pages/chat/message/create_new_group_page.dart';
import 'package:frontend/presentation/pages/chat/message/detail_chat_page.dart';
import 'package:frontend/presentation/pages/chat/message/detail_group_chat_page.dart';
import 'package:get/get.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  int currentChatPageTab = 0;
  PageController chatPageController = PageController();
  List<String> tabBarItemName = [
    "Tất cả",
    "Nhóm",
    "Riêng tư",
    "Công việc",
  ];

  dynamic chatMockUpData = [
    [
      ChatModel(
        name: 'Henry',
        time: '9h',
        message: 'Hi Guy',
        imgpath: ['assets/chat/henry.jpeg'],
      ),
      ChatModel(
        name: 'Jack',
        time: '10h',
        message: 'Hi',
        imgpath: ['assets/chat/henry.jpeg'],
      ),
      ChatModel(
        name: 'Kali',
        time: '2h',
        message: 'So !!',
        imgpath: ['assets/chat/henry.jpeg'],
      ),
      ChatModel(
        name: 'Hiếu, Tuấn, Hải, Phần ...',
        time: '2h',
        message: 'So !!',
        imgpath: [
          'assets/chat/henry.jpeg',
          'assets/chat/henry.jpeg',
          'assets/chat/jack.jpeg',
          'assets/chat/kali.jpeg'
        ],
      ),
    ],
    [
      ChatModel(
        name: 'Hiếu, Tuấn, Hải, Phần ...',
        time: '2h',
        message: 'So !!',
        imgpath: [
          'assets/chat/henry.jpeg',
          'assets/chat/jack.jpeg',
          'assets/chat/kali.jpeg'
        ],
      ),
      ChatModel(
        name: 'Kali',
        time: '2h',
        message: 'So !!',
        imgpath: ['assets/chat/henry.jpeg'],
      ),
    ],
    [
      ChatModel(
        name: 'Henry',
        time: '9h',
        message: 'Hi Guy',
        imgpath: ['assets/chat/henry.jpeg'],
      ),
      ChatModel(
        name: 'Kali',
        time: '2h',
        message: 'So !!',
        imgpath: ['assets/chat/henry.jpeg'],
      ),
    ],
    [
      ChatModel(
        name: 'Henry',
        time: '9h',
        message: 'Hi Guy',
        imgpath: ['assets/chat/henry.jpeg'],
      ),
      ChatModel(
        name: 'Jack',
        time: '10h',
        message: 'Hi',
        imgpath: ['assets/chat/henry.jpeg'],
      ),
      ChatModel(
        name: 'Kali',
        time: '2h',
        message: 'So !!',
        imgpath: ['assets/chat/henry.jpeg'],
      ),
    ],
  ];
  dynamic directoryMockupData = [
    DirectoryModel(
      name: 'Aenry',
      isOnl: 'Đang hoạt động',
      imgpath: "assets/chat/henry.jpeg",
    ),
    DirectoryModel(
      name: 'Back',
      isOnl: 'Đang hoạt động',
      imgpath: "assets/chat/henry.jpeg",
    ),
    DirectoryModel(
      name: 'Aali',
      isOnl: 'Đang hoạt động',
      imgpath: "assets/chat/henry.jpeg",
    ),
    DirectoryModel(
      name: 'Henry',
      isOnl: 'Đang hoạt động',
      imgpath: "assets/chat/henry.jpeg",
    ),
    DirectoryModel(
      name: 'Dack',
      isOnl: 'Hoạt động 10 phút trước',
      imgpath: Images.AvataHenry,
    ),
    DirectoryModel(
      name: 'Kali',
      isOnl: 'Hoạt động 10 phút trước',
      imgpath: Images.AvataKali,
    ),
    DirectoryModel(
      name: 'Aki',
      isOnl: 'Hoạt động 10 phút trước',
      imgpath: Images.AvataHenry,
    ),
    DirectoryModel(
      name: 'Jack',
      isOnl: 'Hoạt động 10 phút trước',
      imgpath: Images.AvataJack,
    ),
    DirectoryModel(
      name: 'Kali',
      isOnl: 'Hoạt động 10 phút trước',
      imgpath: Images.AvataHenry,
    ),
    DirectoryModel(
      name: 'Henry',
      isOnl: 'Đang hoạt động',
      imgpath: Images.AvataHenry,
    ),
    DirectoryModel(
      name: 'Jack',
      isOnl: 'Đang hoạt động',
      imgpath: Images.AvataHenry,
    ),
    DirectoryModel(
      name: 'Henry',
      isOnl: 'Đang hoạt động',
      imgpath: Images.AvataHenry,
    ),
    DirectoryModel(
      name: 'Jack',
      isOnl: 'Đang hoạt động',
      imgpath: Images.AvataHenry,
    ),
  ];

  final TextEditingController _search_controller = TextEditingController();
  final FocusNode _search_focusNode = FocusNode();
  bool _search_Focused = false;
  bool _showEllipsis = false;
  int _maxLength = 30;
  List<String> selectedValues = [];
  late int numMember;
  @override
  void initState() {
    super.initState();
    _search_controller.addListener(() {
      if (_search_controller.text.length > _maxLength && !_showEllipsis) {
        setState(() {
          _showEllipsis = true;
        });
      } else if (_search_controller.text.length <= _maxLength &&
          _showEllipsis) {
        setState(() {
          _showEllipsis = false;
        });
      }
    });

    _search_focusNode.addListener(() {
      if (_search_focusNode.hasFocus != _search_Focused) {
        setState(() {
          _search_Focused = _search_focusNode.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    _search_controller.dispose();
    _search_focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Message'.tr),
        leading: Center(
          child: GestureDetector(
            onTap: () {
              
            },
            child: Container(
              margin: const EdgeInsets.only(left: 20),
              child: const Text(
                '',
                style: TextStyle(color: Colors.blue, fontSize: 14),
              ),
            ),
          ),
        ),
        leadingWidth: 65,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (builder) => directorChatPopup(),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              child: Image.asset(
                Images.plusMessageIcon,
                color: Colors.blue,
                height: 25,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44.0,
                  padding: const EdgeInsets.only(right: 10),
                  margin: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Stack(
                    children: [
                      TextField(
                        controller: _search_controller,
                        focusNode: _search_focusNode,
                        textAlign: _search_Focused
                            ? TextAlign.start
                            : TextAlign.center,
                        decoration: InputDecoration(
                          prefixIcon: GestureDetector(
                            onTap: () {
                              _searchContact();
                            },
                            child: getPrefixIcon(),
                          ),
                          hintText: 'search'.tr,
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                      Positioned(
                        child: _showEllipsis
                            ? const Padding(
                                padding: EdgeInsets.only(left: 37, top: 15),
                                child: Text(
                                  '...',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 50,
            margin: const EdgeInsets.only(left: 20, top: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tabBarItemName.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentChatPageTab = index;
                      chatPageController.jumpToPage(index);
                    });
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            tabBarItemName[index],
                            style: TextStyle(
                              color: (currentChatPageTab == index)
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: (currentChatPageTab == index) ? 50 : 0,
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (currentChatPageTab == index)
                                ? Colors.blue
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: chatPageController,
              itemCount: tabBarItemName.length,
              onPageChanged: (index) {
                setState(() {
                  currentChatPageTab = index;
                });
              },
              itemBuilder: (context, index) {
                return getTab(chatMockUpData, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getPrefixIcon() {
    if (_search_Focused && _search_controller.text.isNotEmpty) {
      return const Icon(Icons.search, color: Colors.grey);
    } else if (!_search_Focused && _search_controller.text.isEmpty) {
      return Transform.translate(
        offset: Offset(MediaQuery.of(context).size.width * 0.3, 0),
        child: const Icon(Icons.search, color: Colors.grey),
      );
    } else if (_search_controller.text.isNotEmpty) {
      return Transform.translate(
        offset: Offset(MediaQuery.of(context).size.width * 0.0, 0),
        child: const Icon(Icons.search, color: Colors.grey),
      );
    } else {
      return const Icon(Icons.search, color: Colors.grey);
    }
  }

  Widget getTab(dynamic chatMockUpData, int tabIndex) {
    return ListView.builder(
      itemCount: chatMockUpData[tabIndex].length,
      itemBuilder: (context, index) {
        final ChatModel chatData = chatMockUpData[tabIndex][index];
        return typeOfChat(index, chatData, context);
      },
    );
  }

  Widget typeOfChat(int index, ChatModel chatData, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => chatData.imgpath.length > 1
                    ? const DetailGroupChatPage()
                    : const DetailChatPage()));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
        padding: const EdgeInsets.all(10),
        height: 60,
        color: Colors.white,
        child: Row(
          children: [
            typeAvata(chatData),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    chatData.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    chatData.message,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  chatData.time,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _searchContact() {
    // logger.e('Hi there');
  }

  Widget typeAvata(
    ChatModel chatData,
  ) {
    if (chatData.imgpath.length > 1) {
      return SizedBox(
        width: 45,
        height: 54,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  chatData.imgpath[0],
                  width: 27,
                  height: 27,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  chatData.imgpath[1],
                  width: 27,
                  height: 27,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  chatData.imgpath[2],
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 40,
        width: 40,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            chatData.imgpath[0],
            fit: BoxFit.fill,
          ),
        ),
      );
    }
  }

  Widget directoryList() {
    List<DirectoryModel> letterA = [];

    List<DirectoryModel> letterB = [];
    List<DirectoryModel> letterC = [];
    List<DirectoryModel> letterD = [];
    List<DirectoryModel> letterE = [];
    List<DirectoryModel> letterF = [];
    List<DirectoryModel> letterG = [];
    List<DirectoryModel> letterH = [];
    List<DirectoryModel> letterI = [];
    List<DirectoryModel> letterJ = [];
    List<DirectoryModel> letterK = [];
    List<DirectoryModel> letterL = [];
    List<DirectoryModel> letterM = [];
    List<DirectoryModel> letterN = [];
    List<DirectoryModel> letterO = [];
    List<DirectoryModel> letterP = [];
    List<DirectoryModel> letterQ = [];
    List<DirectoryModel> letterR = [];
    List<DirectoryModel> letterS = [];
    List<DirectoryModel> letterT = [];
    List<DirectoryModel> letterU = [];
    List<DirectoryModel> letterV = [];
    List<DirectoryModel> letterW = [];
    List<DirectoryModel> letterX = [];
    List<DirectoryModel> letterY = [];
    List<DirectoryModel> letterZ = [];

    for (final item in directoryMockupData) {
      final name = item.name;
      final firstLetter = name[0];
      if (firstLetter.toLowerCase() case ("a")) {
        letterA.add(item);
      } else if (firstLetter.toLowerCase() case ("b")) {
        letterB.add(item);
      } else if (firstLetter.toLowerCase() case ("c")) {
        letterC.add(item);
      } else if (firstLetter.toLowerCase() case ("d")) {
        letterD.add(item);
      } else if (firstLetter.toLowerCase() case ("e")) {
        letterE.add(item);
      } else if (firstLetter.toLowerCase() case ("f")) {
        letterF.add(item);
      } else if (firstLetter.toLowerCase() case ("g")) {
        letterG.add(item);
      } else if (firstLetter.toLowerCase() case ("h")) {
        letterH.add(item);
      } else if (firstLetter.toLowerCase() case ("i")) {
        letterI.add(item);
      } else if (firstLetter.toLowerCase() case ("j")) {
        letterJ.add(item);
      } else if (firstLetter.toLowerCase() case ("k")) {
        letterK.add(item);
      } else if (firstLetter.toLowerCase() case ("l")) {
        letterL.add(item);
      } else if (firstLetter.toLowerCase() case ("m")) {
        letterM.add(item);
      } else if (firstLetter.toLowerCase() case ("n")) {
        letterN.add(item);
      } else if (firstLetter.toLowerCase() case ("o")) {
        letterO.add(item);
      } else if (firstLetter.toLowerCase() case ("p")) {
        letterP.add(item);
      } else if (firstLetter.toLowerCase() case ("q")) {
        letterQ.add(item);
      } else if (firstLetter.toLowerCase() case ("r")) {
        letterR.add(item);
      } else if (firstLetter.toLowerCase() case ("s")) {
        letterS.add(item);
      } else if (firstLetter.toLowerCase() case ("t")) {
        letterT.add(item);
      } else if (firstLetter.toLowerCase() case ("u")) {
        letterU.add(item);
      } else if (firstLetter.toLowerCase() case ("v")) {
        letterV.add(item);
      } else if (firstLetter.toLowerCase() case ("w")) {
        letterW.add(item);
      } else if (firstLetter.toLowerCase() case ("x")) {
        letterX.add(item);
      } else if (firstLetter.toLowerCase() case ("y")) {
        letterY.add(item);
      } else if (firstLetter.toLowerCase() case ("z")) {
        letterZ.add(item);
      }
    }
    List<DirectoryModel> allContacts = [
      ...letterA,
      ...letterB,
      ...letterC,
      ...letterD,
      ...letterE,
      ...letterF,
      ...letterG,
      ...letterH,
      ...letterI,
      ...letterJ,
      ...letterK,
      ...letterL,
      ...letterM,
      ...letterN,
      ...letterO,
      ...letterP,
      ...letterQ,
      ...letterR,
      ...letterS,
      ...letterT,
      ...letterU,
      ...letterV,
      ...letterW,
      ...letterX,
      ...letterY,
      ...letterZ,
    ];

    String? currentLetter;

    return Stack(
      children: [
        const Positioned(
            right: 0.0,
            top: 60,
            child: Column(
              children: [
                Text(
                  'A',
                  style: TextStyle(fontSize: 10, color: Colors.blue),
                ),
                Text('B', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('C', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('D', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('E', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('F', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('G', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('H', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('I', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('J', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('K', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('L', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('M', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('N', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('O', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('P', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('Q', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('S', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('T', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('U', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('V', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('W', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('X', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('Y', style: TextStyle(fontSize: 10, color: Colors.blue)),
                Text('Z', style: TextStyle(fontSize: 10, color: Colors.blue)),
              ],
            )),
        ListView.builder(
          itemCount: allContacts.length,
          itemBuilder: (context, index) {
            final contact = allContacts[index];
            final name = contact.name as String;
            final firstLetter = name[0].toUpperCase();
            final shouldShowLetter =
                currentLetter == null || firstLetter != currentLetter;

            currentLetter = firstLetter;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (shouldShowLetter)
                  Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(firstLetter))),
                ContactTile(contact: contact),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget directorChatPopup() {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.95,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Hủy',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  const Expanded(
                      child: Center(
                          child: Text(
                    'Tin nhắn mới',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ))),
                  Text('     ')
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44.0,
                      width: double.infinity,
                      padding: const EdgeInsets.only(right: 10),
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Stack(
                        children: [
                          TextField(
                            controller: _search_controller,
                            focusNode: _search_focusNode,
                            textAlign: _search_Focused
                                ? TextAlign.start
                                : TextAlign.center,
                            decoration: InputDecoration(
                              prefixIcon: GestureDetector(
                                onTap: () {},
                                child: getPrefixIcon(),
                              ),
                              hintText: 'search'.tr,
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                          Positioned(
                            child: _showEllipsis
                                ? const Padding(
                                    padding: EdgeInsets.only(left: 37, top: 15),
                                    child: Text(
                                      '...',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                  )
                                : Container(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateGroupPage()));
                },
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: Image.asset(
                        Images.createNewGroupIcon,
                        color: Colors.blue,
                        height: 24,
                      ),
                    ),
                    const Text(
                      'Tạo nhóm mới',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: directoryList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ContactTile extends StatelessWidget {
  final DirectoryModel contact;

  const ContactTile({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: contact.imgpath != null
                  ? Image.asset(
                      contact.imgpath,
                      fit: BoxFit.fill,
                    )
                  : const SizedBox(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  contact.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  contact.isOnl,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
