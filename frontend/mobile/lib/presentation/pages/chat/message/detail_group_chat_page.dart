import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:SomeOne/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class DetailGroupChatPage extends StatefulWidget {
  const DetailGroupChatPage({super.key});

  @override
  State<DetailGroupChatPage> createState() => _Detail_group_chatState();
}

Map<int, int> _selectedReactions = {};
Map<int, int> _relyMess = {};
Map<int, int> _pinMess = {};
dynamic _moveMess = [];
int? _IndexMess;
dynamic reacTionIcon = [
  Image.asset(Images.reactionLove, height: 22.5),
  Image.asset(Images.reactionLaught, height: 22.5),
  Image.asset(Images.reactionGlassFace, height: 32.5),
  Image.asset(Images.reactionBad, height: 22.5),
  Image.asset(Images.reactionLaughtSlight, height: 22.5),
  Image.asset(Images.reactionScary, height: 22.5),
  Image.asset(Images.reactionLoveFace, height: 22.5),
  Image.asset(Images.downReaction, height: 22.5),
];
bool _isRely = false;
bool _isPin = false;
bool _isMove = false;
dynamic itemCatelory2 = [
  {
    "item1": "Nhóm",
    "icon": Image.asset(
      Images.acctionRely,
      height: 15,
    )
  },
  {"item1": "Riêng tư", "icon": Image.asset(Images.acctionMove, height: 15)},
  {"item1": "Kênh", "icon": Image.asset(Images.acctionRely, height: 15)},
  {"item1": "Trở về", "icon": Image.asset(Images.acctionSendTo, height: 15)},
];

dynamic itemCatelory = [
  {
    "item1": "Trả lời",
    "icon": Image.asset(
      Images.acctionRely,
      height: 15,
    )
  },
  {"item1": "Di chuyển", "icon": Image.asset(Images.acctionMove, height: 15)},
  {"item1": "Sao chép", "icon": Image.asset(Images.acctionRely, height: 15)},
  {
    "item1": "Chuyển tiếp",
    "icon": Image.asset(Images.acctionSendTo, height: 15)
  },
  {
    "item1": "Ghim tin nhắn",
    "icon": Image.asset(Images.acctionPin, height: 15)
  },
  {"item1": "Xoá", "icon": Image.asset(Images.acctionDelete, height: 15)}
];

class _Detail_group_chatState extends State<DetailGroupChatPage> {
  final TextEditingController _inputMessageController = TextEditingController();
  final FocusNode _search_focusNode = FocusNode();
  final ScrollController _scrollListMessageController = ScrollController();
  final List<XFile> _selectImgsFromGallery = [];
  final Map<int, GlobalKey> _messageKeys = {};

  bool isOnline = false;
  void OnlineStatus() {
    setState(() {
      isOnline = !isOnline;
    });
  }

  void _sendMessage() {
    if (_inputMessageController.text.isNotEmpty ||
        _selectImgsFromGallery.isNotEmpty) {
      setState(() {
        if (_inputMessageController.text.isNotEmpty) {
          messages.add({"auth": 0, "message": _inputMessageController.text});
        }
        for (XFile imageFile in _selectImgsFromGallery) {
          messages.add({"auth": 0, "message": "", "image": imageFile});
        }
        _inputMessageController.clear();
        _selectImgsFromGallery.clear();
        
      });
      _scrollListMessageController.animateTo(
        _scrollListMessageController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  dynamic messages = [
    {
      "auth": 1,
      "message": "Hello các em",
      "imgAvata": "assets/chat/henry.jpeg",
      "name": "Lê Thánh Hiếu",
      "isAdmin": 1
    },
    {
      "auth": 1,
      "message": "Hello các em",
      "imgAvata": "assets/chat/henry.jpeg",
      "name": "Lê Thánh Hiếu",
      "isAdmin": 1
    },
    {
      "auth": 1,
      "message": "Task làm xong hết chưa các em",
      "imgAvata": "assets/chat/henry.jpeg",
      "name": "Lê Thánh Hiếu",
      "isAdmin": 1
    },
    {
      "auth": 1,
      "message": "Task chưa xong anh",
      "imgAvata": "assets/chat/jack.jpeg",
      "name": "Phạm Anh Tuấn",
      "isAdmin": 0
    },
  ];
  int currentPage = 0;
  void NavigatorPage(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  void dispose() {
    _search_focusNode.dispose();
    super.dispose();
  }

  final picker = ImagePicker();
  Future _pickImageFromGallery() async {
    final List<XFile>? returnImage = await picker.pickMultiImage();
    if (returnImage != null) {
      setState(() {
        _selectImgsFromGallery.addAll(returnImage);
      });
    }
  }

  File? _selectImg;
  Future _pickImageFromCamera() async {
    final returnImage = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (returnImage == null) return print('no photo');
      _selectImg = File(returnImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),
            Center(child: Text("18:57 08 THG 5"),),
            Expanded(
              child: _messageList(messages),
            ),
            _messageInput(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      width: double.infinity,
      height: 70,
      color: Colors.grey.shade400.withOpacity(0.15),
      child: Row(
        children: [
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
                _selectedReactions.clear();
              },
              child: const Icon(Icons.arrow_back_ios_rounded)),
          const SizedBox(
            width: 15,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 45,
                height: 45,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          "assets/chat/jack.jpeg",
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
                          "assets/chat/kali.jpeg",
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
                          "assets/chat/kali.jpeg",
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: isOnline
                    ? Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                      )
                    : const SizedBox(),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: isOnline
                    ? Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green),
                      )
                    : const SizedBox(),
              )
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hiếu, Tuấn, Hải, Phần ...',
                  maxLines: 1,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '6 thành viên ,6 đang hoạt động',
                                    maxLines: 1,
                
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Image.asset(
            Images.callIcon,
            color: Colors.blue,
            height: 20,
          ),
          const SizedBox(width: 15,),
          Image.asset(
            Images.danhMucIcon,
            color: Colors.blue,
            height: 20,
          )
        ],
      ),
    );
  }

  Widget _messageInput() {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Colors.grey.shade400.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (builder) => _bottomSheet(),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                  _pickImageFromGallery();
                },
                child: const Icon(Icons.link)),
          ),
          Expanded(
              child: Container(
            height: 45.0,
            padding: const EdgeInsets.only(right: 10, left: 10),
            margin: const EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
                focusNode: _search_focusNode,
                controller: _inputMessageController,
                textAlign: TextAlign.start,
                obscureText: false,
                decoration: const InputDecoration(
                  hintText: 'Nhập tin nhắn',
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixIcon: Icon(Icons.mic),
                  border: InputBorder.none,
                )),
          )),
          IconButton(
            onPressed: () {
              _sendMessage();
            },
            icon: const Icon(Icons.send, color: Colors.blue),
          )
        ],
      ),
    );
  }

  Widget _bottomSheet() {
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.60,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                height: 30,
                margin: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Hủy',
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        )),
                    const Spacer(),
                    const Center(
                        child: Text(
                      'Gửi tệp',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          _sendMessage();
                          // Navigator.pop(context);
                        },
                        child: const Text(
                          'Gửi',
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        )),
                  ],
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8),
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemCount: _selectImgsFromGallery.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.file(
                        File(_selectImgsFromGallery[index].path),
                      );
                    }),
              )),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _pickImageFromGallery();
                      },
                      child: const Column(
                        children: [Icon(Icons.photo_library), Text('Thư viện')],
                      ),
                    ),
                  ),
                  const Expanded(
                      child: Column(
                    children: [Icon(Icons.photo_library), Text('Tài liệu')],
                  )),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      _pickImageFromCamera();
                    },
                    child: const Column(
                      children: [Icon(Icons.camera_alt), Text('Máy ảnh')],
                    ),
                  ))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _messageList(dynamic messages) {
    return Stack(
      children: [
        ListView.builder(
          controller: _scrollListMessageController,
          shrinkWrap: true,
          itemCount: messages.length,
          itemBuilder: (context, indexMess) {
            var message = messages[indexMess];
            bool isMe = message["auth"] == 0;
            bool showAvatar = true;
            bool showName = true;

            if (indexMess < messages.length - 1 &&
                messages[indexMess]["imgAvata"] ==
                    messages[indexMess + 1]["imgAvata"]) {
              showAvatar = false;
            }
            if (indexMess > 0 &&
                messages[indexMess]["name"] ==
                    messages[indexMess - 1]["name"]) {
              showName = false;
            }
            if (!_messageKeys.containsKey(indexMess)) {
              _messageKeys[indexMess] = GlobalKey();
            }

            double avatarWidth = showAvatar
                ? 100.0
                : 0.0; // Width of the avatar including margin
            double maxWidth = MediaQuery.of(context).size.width -
                avatarWidth -
                60; // Available width for the message

            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: showAvatar
                              ? Image.asset(
                                  message['imgAvata'],
                                  fit: BoxFit.fill,
                                )
                              : null,
                        ),
                      ),
                    ),
                    GestureDetector(
                      key: _messageKeys[indexMess],
                      onTap: () {
                        _showMyDialog(indexMess, context, message, isMe,
                            _messageKeys[indexMess]!);
                      },
                      child: Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          margin: isMe
                              ? const EdgeInsets.only(
                                  right: 10, left: 10, top: 5)
                              : const EdgeInsets.only(
                                  left: 10, right: 10, top: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Color(0xFFF2F2F2),
                            borderRadius: isMe
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(5),
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  )
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (showName)
                                Text.rich(
                                  TextSpan(
                                    text: '${message['name']}   ',
                                    style: TextStyle(
                                      color: message['isAdmin'] == 1
                                          ? Color(0xFF007DC0)
                                          : Color(0xFFFF7A00),
                                    ),
                                    children: message['isAdmin'] == 1
                                        ? [
                                            const TextSpan(
                                              text: 'Quản trị',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ]
                                        : [],
                                  ),
                                ),
                              message["image"] != null
                                  ? Image.file(File(message["image"].path))
                                  : Text(
                                      message["message"],
                                      style: TextStyle(
                                        color:
                                            isMe ? Colors.white : Colors.black,
                                      ),
                                    ),
                              if (_selectedReactions.containsKey(indexMess))
                                Container(
                                  padding: EdgeInsets.all(3.5),
                                  width: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color:
                                        isMe ? Colors.grey[300] : Colors.blue,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 20,
                                        child: reacTionIcon[
                                            _selectedReactions[indexMess]!],
                                      ),
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.asset(
                                            "assets/chat/kali.jpeg",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (indexMess == messages.length - 1)
                  Container(
                    margin: EdgeInsets.only(left: 60, right: 10,top: 5),
                    child: Row(
                      children: [
                        Text('19:00'),
                        Spacer(),
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              "assets/chat/kali.jpeg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(width: 3,),
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              "assets/chat/kali.jpeg",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            );
          },
        ),
        if (_isRely)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 50,
              color: Colors.white,
              child: Container(
                margin: const EdgeInsets.only(left: 25, right: 25),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Đang trả lời ${messages[_IndexMess]["auth"]}",
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "${messages[_IndexMess]['message']}...",
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isRely = !_isRely;
                        });
                      },
                      child: Image.asset(
                        Images.closeReplyIcon,
                        height: 26,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        if (_isPin)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 55,
              color: Colors.white,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 2,
                        height: 10,
                        color: Colors.blue,
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Container(
                        width: 2,
                        height: 10,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Container(
                        width: 2,
                        height: 10,
                        color: Colors.grey,
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tin nhắn được ghim #1',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue,
                            )),
                        Text(
                          "${messages[_IndexMess]['message']}...",
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPin = !_isPin;
                      });
                    },
                    child: Center(
                      child: Image.asset(
                        Images.unionIcon,
                        height: 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _showMyDialog(int indexMess, BuildContext context,
      dynamic message, bool isMe, GlobalKey messageKey) async {
    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 300));

    final RenderBox? messageBox =
        messageKey.currentContext?.findRenderObject() as RenderBox?;
    if (messageBox != null) {
      final Offset position =
          messageBox.localToGlobal(Offset.zero); //lấy toạ độ
      //hiển thị diaLog tin nhắn
      Size size = messageBox.size;
      int spaceLRDialog = 15;
      int spaceTopDialog = 55;
      int spaceCateloryMessLeft = 155;
      int spaceCateloryMessTop = 20;

      double positionMessMe = position.dx + spaceLRDialog;
      double positionMessOther = position.dx - spaceLRDialog;

      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      //tính vị trí catelory không vượt quá màn hình hiển thị
      bool isPositionedAbove = false;
      int showAbleScreen = 255;
      double dialogLR = isMe
          ? min(position.dx + spaceCateloryMessLeft + 45 + spaceLRDialog + 10,
              screenWidth - 180)
          : max(positionMessMe + 10, 0);

      double dialogTop = min(
          position.dy + size.height - spaceCateloryMessTop, screenHeight - 215);
      if (dialogTop > screenHeight - position.dy) {
        dialogTop = position.dy - showAbleScreen;
        isPositionedAbove = true;
      }
      //tính vị trí reationIcon không vượt quá màn hình hiển thị
      double posionLRReaction = 74;
      double ReactionPopupLR = isMe
          ? min(
              position.dx + posionLRReaction + spaceLRDialog, screenWidth - 180)
          : max(positionMessMe + 10, 0);
      double ReactionPopupTop =
          min(position.dy - size.height - size.height + 10, screenHeight - 215);
      if (dialogTop > screenHeight - position.dy) {
        ReactionPopupTop = position.dy - showAbleScreen;
      }
      if (position.dy - showAbleScreen == dialogTop) {
        ReactionPopupTop = position.dy - showAbleScreen - 50;
      }
      //ds item trong catelory
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (_) => GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Stack(
            children: [
              Positioned(
                width: isMe ? size.width : size.width + size.width + 10,
                left: isMe ? positionMessMe : positionMessOther,
                top: position.dy - spaceTopDialog,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Dialog(
                    backgroundColor: Colors.transparent,
                    child: Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: isMe
                            ? const EdgeInsets.only(left: 65, top: 5)
                            : const EdgeInsets.only(right: 65, top: 5),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey[300],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: message["image"] != null
                            ? Image.file(File(message["image"].path))
                            : Text(
                                message["message"],
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              if (!_isMove)
                Positioned(
                    left: dialogLR,
                    top: dialogTop,
                    child: Align(
                      alignment: isPositionedAbove
                          ? isMe
                              ? Alignment.bottomRight
                              : Alignment.bottomLeft
                          : isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                      child: Container(
                        width: 180,
                        height: 215,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: ListView.builder(
                            itemCount: itemCatelory.length,
                            itemBuilder: (context, indexCate) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (indexCate == 0) {
                                          setState(() {
                                            _isRely = !_isRely;
                                            _IndexMess = indexMess;
                                          });
                                        }
                                        if (indexCate == 1) {
                                          setState(() {
                                            _isMove = !_isMove;
                                            _IndexMess = indexMess;
                                          });
                                        }
                                        if (indexCate == 4) {
                                          setState(() {
                                            _isPin = !_isPin;
                                            _IndexMess = indexMess;
                                          });
                                        }
                                        _relyMess[indexMess] = indexCate;
                                        _pinMess[indexMess] = indexCate;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(7.7),
                                      child: Row(
                                        children: [
                                          Text(
                                              itemCatelory[indexCate]['item1']),
                                          Spacer(),
                                          itemCatelory[indexCate]['icon']
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }),
                      ),
                    )),
              if (_isMove)
                Positioned(
                    left: dialogLR,
                    top: dialogTop,
                    child: Align(
                      alignment: isPositionedAbove
                          ? isMe
                              ? Alignment.bottomRight
                              : Alignment.bottomLeft
                          : isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                      child: Container(
                        width: 180,
                        height: 145,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: ListView.builder(
                            itemCount: itemCatelory2.length,
                            itemBuilder: (context, indexCate) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (indexCate == 0) {
                                          setState(() {
                                            _isRely = !_isRely;
                                            _IndexMess = indexMess;
                                          });
                                        }
                                        if (indexCate == 1) {
                                          setState(() {
                                            _isMove = !_isMove;
                                            _IndexMess = indexMess;
                                          });
                                        }
                                        if (indexCate == 4) {
                                          setState(() {
                                            _isPin = !_isPin;
                                            _IndexMess = indexMess;
                                          });
                                        }
                                        _relyMess[indexMess] = indexCate;
                                        _pinMess[indexMess] = indexCate;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(7.7),
                                      child: Row(
                                        children: [
                                          Text(itemCatelory2[indexCate]
                                              ['item1']),
                                          Spacer(),
                                          itemCatelory2[indexCate]['icon']
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }),
                      ),
                    )),
              Positioned(
                  top: ReactionPopupTop,
                  left: ReactionPopupLR,
                  child: Align(
                    alignment: isPositionedAbove
                        ? isMe
                            ? Alignment.bottomRight
                            : Alignment.bottomLeft
                        : isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Container(
                      width: 300,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: ListView.builder(
                        itemCount: reacTionIcon.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int indexIcon) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedReactions[indexMess] = indexIcon;
                              });
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 10),
                                  child: reacTionIcon[indexIcon],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ))
            ],
          ),
        ),
      );
    } else {
      print('Golbal key is null');
    }
  }
}
