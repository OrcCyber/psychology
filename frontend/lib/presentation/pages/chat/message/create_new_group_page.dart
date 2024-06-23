import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/data/models/directory_model.dart';
import 'package:frontend/presentation/constants.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPage();
}
List<String> selectedValues = [];
class _CreateGroupPage extends State<CreateGroupPage> {
  
  final TextEditingController _search_controller = TextEditingController();
  final FocusNode _search_focusNode = FocusNode();
  bool _search_Focused = false;
  bool _showEllipsis = false;
  int _maxLength = 30;

   dynamic directoryMockupData = [
    DirectoryModel(
      name: 'Aenry',
      isOnl: 'Đang hoạt động',
      imgpath: Images.AvataHenry,
    ),
    DirectoryModel(
      name: 'Back',
      isOnl: 'Đang hoạt động',
      imgpath: Images.AvataJack,
    ),
    DirectoryModel(
      name: 'Aali',
      isOnl: 'Đang hoạt động',
      imgpath: Images.AvataHenry,
    ),
    DirectoryModel(
      name: 'Henry',
      isOnl: 'Đang hoạt động',
      imgpath: Images.AvataKali,
    ),
    DirectoryModel(
      name: 'Dack',
      isOnl: 'Hoạt động 10 phút trước',
      imgpath: Images.AvataHenry,
    ),
    DirectoryModel(
      name: 'Kali',
      isOnl: 'Hoạt động 10 phút trước',
      imgpath: Images.AvataJack,
    ),
    DirectoryModel(
      name: 'Aki',
      isOnl: 'Hoạt động 10 phút trước',
      imgpath: Images.AvataHenry,
    ),
    DirectoryModel(
      name: 'Jack',
      isOnl: 'Hoạt động 10 phút trước',
      imgpath: Images.AvataKali,
    ),
    DirectoryModel(
      name: 'Kali',
      isOnl: 'Hoạt động 10 phút trước',
      imgpath: Images.AvataHenry,
    ),
    DirectoryModel(
      name: 'Henry',
      isOnl: 'Đang hoạt động',
      imgpath: Images.AvataKali,
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

 void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _search_focusNode.requestFocus();
    });
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

  List<String> listImg = [];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.grey.shade500,
      statusBarColor: Colors.grey.shade500,
    ));
    return Scaffold(
      body: SafeArea(
          child: Container(
        color: Colors.grey,
        child: createNewGroupPopup(),
      )),
    );
  }

  Widget createNewGroupPopup() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        height: MediaQuery.of(context).size.height * 0.99,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Container(
          
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_ios_new_sharp,
                                  color: Colors.blue,
                                ),
                                Text(
                                  'Trở về',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )),
                        const Expanded(
                            child: Center(
                                child: Text(
                          'Nhóm mới',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ))),
                        const Text(
                          '     Xong',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        )
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
                                    hintText: _search_Focused
                                        ? 'Bạn muốn thêm ai vào nhóm?'
                                        : 'Tìm kiếm',
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                                Positioned(
                                  child: _showEllipsis
                                      ? const Padding(
                                          padding:
                                              EdgeInsets.only(left: 37, top: 15),
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
                      onTap: () {},
                      child: Row(
                        children: [
                          Container(
                            child: avataNewGroup(listImg),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Nhóm chưa đặt tên',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  child: Text('Đã chọn: ${selectedValues.length}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400)))
                            ],
                          ),
                          Spacer(),
                          Container(
                            child: Image.asset(
                              Images.editNameGroup,
                              color: Colors.blue,
                              height: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: selectDirectory(),
                    )
                  ],
                ),
              ),
              listBottomAvata(listImg)
            ],
          ),
        ),
      ),
    );
  }

  Widget listBottomAvata(List<String> listImg) {
    const maxVisibleImages = 5;
    final totalImages = listImg.length;
    final remainingImages = totalImages - maxVisibleImages;
    final displayText = remainingImages > 0 ? '+$remainingImages' : '';

    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                if (displayText.isNotEmpty)
                  Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        displayText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: totalImages,
                    itemBuilder: (context, index) {
                      if (totalImages > 5 && index < maxVisibleImages) {
                        return SizedBox(
                          height: 50,
                          width: 38,
                          child: Stack(
                            children: [
                              Positioned(
                                left: -5,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.asset(
                                          listImg[index],
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () =>
                                              removeMemberFromIcon(index),
                                          child: const Icon(
                                            Icons.cancel_sharp,
                                            size: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (index < maxVisibleImages) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  listImg[index],
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => removeMemberFromIcon(index),
                                  child: const Icon(
                                    Icons.cancel_sharp,
                                    size: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, right: 20, left: 20),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text(
                    'Tạo',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget avataNewGroup(List<String> listImg) {
    if (listImg.isEmpty) {
      return Container();
    } else if (listImg.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          listImg[0],
          width: 40,
          height: 40,
        ),
      );
    } else {
      return SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  listImg[0],
                  width: 30,
                  height: 30,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  listImg[1],
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void removeMemberFromIcon(int index) {
    setState(() {
      listImg.remove(listImg[index]);
      print(selectedValues);
      selectedValues.remove(selectedValues[index]);
    });
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

  void _itemChange(String itemValue, String itemValueImg, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedValues.add(itemValue);
        listImg.add(itemValueImg);
      } else {
        selectedValues.remove(itemValue);
        listImg.remove(itemValueImg);
      }
    });
  }

  Widget selectDirectory() {
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
            final directorData = allContacts[index];
            final itemValue = directorData.name;
            final firstLetter = itemValue[0].toUpperCase();
            final shouldShowLetter =
                currentLetter == null || firstLetter != currentLetter;

            currentLetter = firstLetter;
            final itemValueImg = directorData.imgpath;
            final isSelected = selectedValues.contains(itemValue);
            return Column(mainAxisSize: MainAxisSize.min, children: [
              if (shouldShowLetter)
                Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(firstLetter!))),
              ContactTile(
                contact: directorData,
                isSelected: isSelected,
                onTap: () => _itemChange(itemValue, itemValueImg, !isSelected),
              )
            ]);
          },
        ),
      ],
    );
  }

}

class ContactTile extends StatelessWidget {
  final DirectoryModel contact;
  final bool isSelected;
  final VoidCallback onTap; 

  const ContactTile({
    required this.contact,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = contact.name;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 53,
        margin: const EdgeInsets.only(right: 10),
        color: Colors.white,
        child: Row(
          children: [
            Stack(
              children: [
                CheckboxTheme(
                  data: CheckboxThemeData(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  child: Checkbox(
                      checkColor: Colors.blue,
                      activeColor: Colors.blue,
                      value: isSelected,
                      onChanged: (isChecked) => onTap()),
                ),
                if (isSelected)
                  Positioned.fill(
                    child: Center(
                      child: Text(
                        (selectedValues.indexOf(name) + 1).toString(),
                        style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  contact.imgpath,
                  fit: BoxFit.fill,
                ),
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
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
