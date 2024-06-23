import 'package:flutter/material.dart';
import 'package:frontend/presentation/bottom_nav.dart';
import 'package:frontend/presentation/constants.dart';
import 'package:frontend/presentation/pages/login/signup.dart';
import 'package:page_transition/page_transition.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool currentTheme = false;
  bool isEmailFocused = false;
  bool isPasswordFocused = false;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  void setTheme() {
    setState(() {
      currentTheme = !currentTheme;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() {
      setState(() {
        isEmailFocused = _emailFocus.hasFocus;
      });
    });
    _passwordFocus.addListener(() {
      setState(() {
        isPasswordFocused = _passwordFocus.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
      child: SingleChildScrollView(
        
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 75, left: 5),
                height: 70,
                child: const Text(
                  "Chào mừng bạn đến với Psychology Chat",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF5177FF),
                      fontSize: 25,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, left: 55, right: 55),
              child: Image.asset(Images.AmicoImg),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Hãy đăng nhập tài khoản',
                style: TextStyle(
                    color: Color(0xFF5177FF),
                    fontSize: 25,
                    fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 25, right: 25),
                  child: TextField(
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                    controller: _email,
                    focusNode: _emailFocus,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: isEmailFocused
                            ? const Color(0xFF5177FF)
                            : Colors.grey,
                      ),
                      hintText: 'Email',
                      hintStyle: TextStyle(
                          color: isEmailFocused
                              ? const Color(0xFF5177FF)
                              : Colors.grey),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF5177FF)),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 25, right: 25, top: 5),
                  child: TextField(
                    controller: _password,
                    focusNode: _passwordFocus,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: isPasswordFocused
                            ? const Color(0xFF5177FF)
                            : Colors.grey,
                      ),
                      hintText: 'Mật khẩu',
                      hintStyle: TextStyle(
                          color: isPasswordFocused
                              ? const Color(0xFF5177FF)
                              : Colors.grey),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF5177FF)),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 20, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const BottomNav()));
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF5177FF),
                            disabledBackgroundColor: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.12),
                            animationDuration: const Duration(seconds: 1),
                            minimumSize: const Size(170, 47)),
                        child: const Text(
                          'Đăng nhập',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color(0xFF5177FF),
                            backgroundColor:
                                Colors.white,
                            elevation: 0,
                          ),
                          child: const Text('Quên mật khẩu',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Bạn chưa có tài khoản ? ",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                duration: const Duration(milliseconds: 500),
                                child: const SignUpPage(),
                              ),
                            );
                          },
                          child: const Text(
                            " Đăng ký ngay",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF5177FF),
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
