import 'package:flutter/material.dart';
import 'package:mobile/componen/buttonCostum.dart';
import 'package:mobile/componen/textField.dart';
import 'package:mobile/models/user_model.dart';
import 'package:mobile/pages/Auth/forgetPassword.dart';
import 'package:mobile/pages/Auth/registerPage.dart';
import 'package:mobile/pages/bottonNavigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _fadeOut;
  late Animation<double> _scaleUp;
  late Animation<double> _moveX;
  late Animation<double> _moveY;

  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _moveX = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _moveY = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeOut = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scaleUp = Tween<double>(begin: 1.0, end: 1.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveLogin(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', user.id_user);
    User.currentUser = user;
  }

  // simple local authentication using the `users` list below
  User? _authenticate(String email, String password) {
    try {
      return users.firstWhere(
        (u) =>
          u.email.trim().toLowerCase() == email.trim().toLowerCase() &&
          u.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _onLoginPressed() async {
    FocusScope.of(context).unfocus();

    if (_isAuthenticating) return;

    final email = emailController.text;
    final pass = passwordController.text;

    if (email.isEmpty || pass.isEmpty) {
      _showSnackBar('Email dan password harus diisi.');
      return;
    }

    setState(() => _isAuthenticating = true);

    final user = _authenticate(email, pass);

    if (user == null) {
      setState(() => _isAuthenticating = false);
      _showSnackBar('Email atau password salah.');
      return;
    }

    try {
      await _controller.forward();

      await _saveLogin(user);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => BottonNavigation(currentUser: user,)),
        );
      }
    } finally {
      _controller.reset();
      if (mounted) setState(() => _isAuthenticating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    const logoSize = 70.0;

    return Scaffold(
      backgroundColor: const Color(0xfff3f9ff),
      body: Center(
        child: SingleChildScrollView(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final moveX = (screen.width / 2 - logoSize / 2 - screen.width * 0.16) * _moveX.value;
              final moveY = (screen.height / 2 - logoSize / 2 - screen.height * 0.16) * _moveY.value;
          
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform.translate(
                          offset: Offset(moveX, moveY),
                          child: Transform.scale(
                            scale: _scaleUp.value,
                            child: Image.asset(
                              'assets/logo.png',
                              height: logoSize,
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: _fadeOut.value,
                          child: Image.asset('assets/name.png'),
                        ),
                      ],
                    ),
          
                    Opacity(
                      opacity: _fadeOut.value,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40, bottom: 15),
                              child: const Text(
                                "Log in",
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          FieldTextCustom(
                            controller: emailController,
                            labelText: "Email",
                          ),
                          FieldTextCustom(
                            controller: passwordController,
                            labelText: "Password",
                            isPassword: true,
                            obscurePass: true,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 10),
                              child: InkWell(
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Color(0xFF8AC4FA),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ForgetPasswordPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 15),
                            child: ButtonCostum(
                              text: "Login",
                              onPressed: _onLoginPressed,
                            ),
                          ),
                          ButtonCostum(
                            text: "Explore as Guest",
                            onPressed: () async {
                              await _controller.forward();
                              Navigator.pushAndRemoveUntil(
                                context, 
                                MaterialPageRoute(builder: (context) => BottonNavigation()), 
                                (route) => false
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have a UBX account? "),
                                InkWell(
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Color(0xFF8AC4FA),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegisterPage(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
