// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/login/login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => __SignUpPagState();
}

class __SignUpPagState extends State<SignUpPage> {
  bool isEmailFocus = false;
  bool isFirstNameFocus = false;
  bool isLastNameFocus = false;
  bool isPassword = false;
  bool isPasswordVerify = false;
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _Email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordVerify = TextEditingController();

  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordFocusVerify = FocusNode();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  @override
  void initState() {
    super.initState();
    _firstNameFocus.addListener(() {
      setState(() {
        isFirstNameFocus = _firstNameFocus.hasFocus;
      });
    });
    _lastNameFocus.addListener(() {
      setState(() {
        isLastNameFocus = _lastNameFocus.hasFocus;
      });
    });
    _emailFocus.addListener(() {
      setState(() {
        isEmailFocus = _emailFocus.hasFocus;
      });
    });
    _passwordFocus.addListener(() {
      setState(() {
        isPassword = _passwordFocus.hasFocus;
      });
    });
    _passwordFocusVerify.addListener(() {
      setState(() {
        isPasswordVerify = _passwordFocusVerify.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _firstName.dispose();
    _firstNameFocus.dispose();
    _emailFocus.dispose();
    _Email.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    _passwordVerify.dispose();
    _passwordFocusVerify.dispose();
    super.dispose();
  }

  void sendEmailWithDeepLink() async {
    String username = 'vyle.1110035@gmail.com'; // Thay bằng địa chỉ email của bạn
    String password = 'Thaivy1110035'; // Thay bằng mật khẩu email của bạn

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Tên của bạn')
      ..recipients.add('vyle.111003@gmail.com') // Thay bằng email người nhận
      ..subject = 'Email có chứa deep link'
      ..html = '''
    <p>Xin chào,</p>
    <p>Đây là một deep link để mở ứng dụng của tôi:</p>
    <a href="myapp://main/details">Nhấp vào đây để mở ứng dụng</a>
    ''';

    try {
      final sendReport = await send(message, smtpServer);
      print('Email đã được gửi thành công!');

      // Kiểm tra và xử lý kết quả gửi email
      if (sendReport != null) {
        print('Response: ${sendReport.toString()}');
      } else {
        print('Không có phản hồi từ server.');
      }
    } catch (e) {
      print('Lỗi khi gửi email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF5177FF),
                    offset: Offset(0, 1),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.only(top: 25, bottom: 10),
                      child: const Text(
                        'Đăng ký',
                        style: TextStyle(
                            color: Color(0xFF5177FF),
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const Text(
                    'Nhập các thông tin bên dưới để tạo tài khoản',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15, left: 25, right: 25),
                    child: TextField(
                      controller: _firstName,
                      focusNode: _firstNameFocus,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.account_box,
                            color: isFirstNameFocus
                                ? const Color(0xFF5177FF)
                                : Colors.grey,
                          ),
                          hintText: 'First Name',
                          hintStyle: TextStyle(
                              color: isFirstNameFocus
                                  ? const Color(0xFF5177FF)
                                  : Colors.grey),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xFF5177FF)))),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15, left: 25, right: 25),
                    child: TextField(
                      controller: _lastName,
                      focusNode: _lastNameFocus,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.account_box,
                            color: isLastNameFocus
                                ? const Color(0xFF5177FF)
                                : Colors.grey,
                          ),
                          hintText: 'Last Name',
                          hintStyle: TextStyle(
                              color: isLastNameFocus
                                  ? const Color(0xFF5177FF)
                                  : Colors.grey),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xFF5177FF)))),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15, left: 25, right: 25),
                    child: TextField(
                      controller: _Email,
                      focusNode: _emailFocus,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: isEmailFocus
                              ? const Color(0xFF5177FF)
                              : Colors.grey,
                        ),
                        hintText: 'Email',
                        hintStyle: TextStyle(
                            color: isEmailFocus
                                ? const Color(0xFF5177FF)
                                : Colors.grey),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF5177FF))),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15, left: 25, right: 25),
                    child: TextField(
                      controller: _password,
                      focusNode: _passwordFocus,
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: isPassword
                                ? const Color(0xFF5177FF)
                                : Colors.grey,
                          ),
                          hintText: 'Mật khẩu',
                          hintStyle: TextStyle(
                              color: isPassword
                                  ? const Color(0xFF5177FF)
                                  : Colors.grey),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xFF5177FF)))),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15, left: 25, right: 25),
                    child: TextField(
                      controller: _passwordVerify,
                      focusNode: _passwordFocusVerify,
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: isPasswordVerify
                                ? const Color(0xFF5177FF)
                                : Colors.grey,
                          ),
                          hintText: 'Xác nhận mật khẩu',
                          hintStyle: TextStyle(
                              color: isPasswordVerify
                                  ? const Color(0xFF5177FF)
                                  : Colors.grey),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xFF5177FF)))),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: sendEmailWithDeepLink,
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF5177FF),
                        minimumSize: const Size(150, 47)),
                    child: const Text('Đăng ký',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Bạn đã có tài khoản?',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.leftToRightWithFade,
                              duration: const Duration(milliseconds: 500),
                              child: const LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          ' Đăng nhập ngay',
                          style: TextStyle(
                              color: Color(0xFF5177FF),
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
