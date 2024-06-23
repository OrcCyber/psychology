import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/presentation/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

class DetailChatPage extends StatefulWidget {
  const DetailChatPage({super.key});

  @override
  State<DetailChatPage> createState() => _Detail_chatState();
}

List<AssetEntity> _assetEntity_images = [];
List<XFile> _selectedXFiles = [];
List<XFile> _tempPickedImages = [];
Set<int> _selectedIndexes = {};

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

class _Detail_chatState extends State<DetailChatPage> {
  final TextEditingController _inputMessageController = TextEditingController();
  final FocusNode _search_focusNode = FocusNode();
  final ScrollController _scrollListMessageController = ScrollController();
  final Map<int, GlobalKey> _messageKeys = {};
  final List<XFile> files = []; //ReadFile
  bool isOnline = false;
  void OnlineStatus() {
    setState(() {
      isOnline = !isOnline;
    });
  }

  void _sendMessage() {
    if (_inputMessageController.text.isNotEmpty ||
        _selectedXFiles.isNotEmpty ||
        files.isNotEmpty) {
      //ReadFile
      setState(() {
        if (_inputMessageController.text.isNotEmpty) {
          messages.add({"auth": 0, "message": _inputMessageController.text});
        }
        for (XFile imageFile in _selectedXFiles) {
          messages.add({"auth": 0, "message": "", "image": imageFile});
        }
        if (files.isNotEmpty) {
          messages.add({"auth": 0, "message": files[0].name, "file": files[0]});
        } //ReadFile

        _inputMessageController.clear();
        _selectedXFiles.clear();
        files.clear(); //ReadFile
      });
      _scrollListMessageController.animateTo(
        _scrollListMessageController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  dynamic messages = [
    {"auth": 1, "message": "Hello"},
    {"auth": 1, "message": "Hello em"},
    {"auth": 1, "message": "lam xong chưa"},
    {"auth": 0, "message": "chua anh oi"},
    {"auth": 0, "message": "kho qua"},
    {"auth": 1, "message": "lam xong chưa"},
    {"auth": 1, "message": "lam xong chưa"},
    {"auth": 1, "message": "lam xong chưa"},
    {"auth": 1, "message": "lam xong chưa"},
    {"auth": 1, "message": "lam xong chưa"},
    {"auth": 1, "message": "lam xong chưa"},
    {"auth": 1, "message": "lam xong chưa"},
    {"auth": 1, "message": "lam xong chưa"},
    {"auth": 1, "message": "lam xong chưa"},
    {"auth": 1, "message": "lam xong chưa"},
    {"auth": 1, "message": "lam xong chưa"},
    {
      "auth": 1,
      "message":
          "lam xong chưa , lam xo lamg chưa, lam xong chưa lam , lam xo lam xong chưa, lam xong chưa, lam x , lam xo lam xong chưa, lam xong chưa, lam xong chưa, lam xong chưa, lam xong chưa"
    },
    {
      "auth": 0,
      "message":
          "lam xong chưa , lam xo lamg chưa, lam xong chưa lam , lam xo lam xong chưa, lam xong chưa, lam x , lam xo lam xong chưa, lam xong chưa, lam xong chưa, lam xong chưa, lam xong chưa"
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

  //ReadFile
  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      XFile file = XFile(result.files.single.path!);
      setState(() {
        files.add(file);
      });
    }
  }
  Future<void> _checkPermissionFile()async{
    var status = await Permission.storage.status;
    if(status.isDenied){
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Row(
            children: [
              Icon(Icons.camera_alt, color: Colors.red),
              SizedBox(width: 10),
              Expanded(
                  child: Text(
                'Quyền truy cập File bị từ chối',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
            ],
          ),
          content: const Text(
            'Bạn đã từ chối quyền truy cập File. Hãy đi đến cài đặt để mở quyền truy cập.',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Đi đến cài đặt'),
              onPressed: () {
                openAppSettings();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }else if(status.isGranted){
      _pickFile();
    }
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkCameraPermission(refresh: true);
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

  Future<void> _checkCameraPermission({bool refresh = false}) async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Row(
            children: [
              Icon(Icons.camera_alt, color: Colors.red),
              SizedBox(width: 10),
              Expanded(
                  child: Text(
                'Quyền truy cập camera bị từ chối',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
            ],
          ),
          content: const Text(
            'Bạn đã từ chối quyền truy cập camera. Hãy đi đến cài đặt để mở quyền truy cập.',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Đi đến cài đặt'),
              onPressed: () {
                openAppSettings();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else if (status.isGranted) {
      if (refresh) {
        setState(() {});
      } else {
        await _pickImageFromCamera();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),
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
                height: 42,
                width: 42,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                   Images.AvataKali,
                    fit: BoxFit.fill,
                  ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Na Em Name',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Đang hoạt động',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          Image.asset(
            Images.callIcon,
            color: Colors.blue,
            height: 20,
          ),
          const SizedBox(
            width: 15,
          ),
          Image.asset(
            Images.danhMucIcon,
            color: Colors.blue,
            height: 20,
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );
      List<AssetEntity> images = await paths[0].getAssetListPaged(
        page: 0,
        size: 100,
      );
      setState(() {
        _assetEntity_images = images;
      });
    } else {}
  }

  void _onImageSelect(AssetEntity image, bool isSelected) async {
    File? file = await image.file;
    if (file != null) {
      setState(() {
        if (isSelected) {
          _tempPickedImages.add(XFile(file.path));
          _selectedXFiles.add(XFile(file.path));
        } else {
          _tempPickedImages.removeWhere((element) => element.path == file.path);
          _selectedXFiles.removeWhere((element) => element.path == file.path);
        }
        print("Chỉ số ảnh đã chọn :$_tempPickedImages");
        print("Số lượng ảnh đã chọn :${_tempPickedImages.length}");
      });
    }
  }

  void _showCustomImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 600,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _selectedXFiles.clear();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Hủy',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Gửi tệp',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            _sendMessage();
                          });
                          _selectedXFiles.clear();

                          Navigator.of(context).pop();
                        },
                        child: const Text('Gửi',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500))),
                  ],
                ),
              ),
              Expanded(
                child: _assetEntity_images.isNotEmpty
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: _assetEntity_images.length,
                        itemBuilder: (BuildContext context, int index) {
                          AssetEntity image = _assetEntity_images[index];
                          return SelectableImage(
                            image: image,
                            index: index,
                            onSelect: _onImageSelect,
                          );
                        },
                      )
                    : Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                children: [
                                  TextSpan(
                                    text:
                                        'Bạn đã từ chối quyền truy cập camera. ',
                                  ),
                                  TextSpan(
                                    text: 'Hãy đi đến cài đặt ',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'để mở quyền truy cập.',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  openAppSettings();
                                },
                                child: const Text(
                                  'Cấp quyền truy cập thư viện ảnh',
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        )),
              ),
              Container(
                height: 60,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  color: Colors.white,
                ),
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Image.asset(Images.PhotoLibrary, height: 20),
                            Text('Thư viện')
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        _checkPermissionFile();
                      },
                      child: Column(
                        children: [
                          Image.asset(Images.FilesIcon, height: 20),
                          Text('Tài liệu')
                        ],
                      ),
                    )),
                    Expanded(
                        child: GestureDetector(
                      onTap: () async {
                        _checkCameraPermission();
                      },
                      child: const Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                          Text('Máy ảnh')
                        ],
                      ),
                    ))
                  ],
                ),
              )
            ],
          ),
        );
      },
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
            child: Center(
              child: GestureDetector(
                  onTap: _showCustomImagePicker, child: const Icon(Icons.link)),
            ),
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

  //ReadFile
  Widget showMessage(var message, bool isMe) {
    if (message.containsKey("image")) {
      return Image.file(File(message["image"].path));
    } else if (message.containsKey("file")) {
      return ListTile(
        leading: Icon(Icons.insert_drive_file),
        title: Text(message["message"]),
        onLongPress: () {
          OpenFile.open(message["file"].path);
        },
      );
    } else {
      return Text(
        message["message"],
        style: TextStyle(
          color: isMe ? Colors.white : Colors.black,
        ),
      );
    }
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
            if (!_messageKeys.containsKey(indexMess)) {
              _messageKeys[indexMess] = GlobalKey();
            }
            return Column(
              children: [
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
                      margin: isMe
                          ? const EdgeInsets.only(right: 20, left: 145, top: 5)
                          : const EdgeInsets.only(right: 145, left: 20, top: 5),
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
                          showMessage(message, isMe),
                          if (_selectedReactions.containsKey(indexMess))
                            Container(
                              padding: EdgeInsets.all(3.5),
                              width: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: isMe ? Colors.grey[300] : Colors.blue,
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
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                       Images.AvataKali,
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
                            Text("${messages[_IndexMess]['message']}...",
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey)),
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
              )),
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
                        const Expanded(
                          child: Text('Tin nhắn được ghim #1',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.blue,
                              )),
                        ),
                        Expanded(
                          child: Text("${messages[_IndexMess]['message']}...",
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPin = !_isPin;
                      });
                    },
                    child: Center(
                        child: Image.asset(
                      Images.UnionIcon,
                      height: 14,
                    )),
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
      double posionLRReaction = 40;
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
                width: isMe ? size.width : size.width - 20,
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

class SelectableImage extends StatefulWidget {
  final AssetEntity image;
  final int index;
  final Function(AssetEntity, bool) onSelect;

  const SelectableImage({
    required this.image,
    required this.index,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  @override
  _SelectableImageState createState() => _SelectableImageState();
}

class _SelectableImageState extends State<SelectableImage> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: widget.image.thumbnailDataWithSize(ThumbnailSize(200, 200)),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _isSelected = !_isSelected;
                widget.onSelect(widget.image, _isSelected);
              });
            },
            child: Stack(
              children: [
                Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                if (_isSelected)
                  const Positioned(
                    right: 5,
                    top: 5,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                    ),
                  ),
              ],
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
