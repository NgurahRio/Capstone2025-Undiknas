import 'package:flutter/material.dart';
import 'package:mobile/componen/buttonCostum.dart';
import 'package:mobile/componen/textField.dart';
import 'package:mobile/pages/Auth/forgetPassword.dart';
import 'package:mobile/pages/Auth/registerPage.dart';
import 'package:mobile/pages/bottonNavigation.dart';

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
  late Animation<Offset> _logoMove;
  late Animation<double> _fadeOut;
  late Animation<double> _scaleUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoMove = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.3, 2),
    ).animate(
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

  void _onLoginPressed() async {
    await _controller.forward();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottonNavigation()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f9ff),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo + Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: _scaleUp,
                        child: SlideTransition(
                          position: _logoMove,
                          child: Image.asset(
                            'assets/logo.png', 
                            height: 70,
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
                                  MaterialPageRoute(builder: (context) => ForgetPasswordPage()),
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
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const BottonNavigation()),
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
                                      builder: (context) => RegisterPage()
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
    );
  }
}
