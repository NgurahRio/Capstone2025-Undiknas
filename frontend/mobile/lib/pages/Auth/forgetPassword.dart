import 'package:flutter/material.dart';
import 'package:mobile/componen/buttonCostum.dart';
import 'package:mobile/componen/textField.dart';
import 'package:mobile/pages/Auth/loginPage.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController emailController = TextEditingController();

  void _showSuccesful() {
    showDialog(
      context: context, 
      barrierDismissible: false,
      barrierColor: const Color.fromARGB(255, 106, 106, 106),
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SizedBox(
            width: 500,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_rounded, color: Color(0xFF8AC4FA), size: 100,),
                  const Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 30),
                    child: Text(
                      "Succesful",
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              
                  const Text(
                    textAlign: TextAlign.center,
                    "We've sent a reset link to your email.\nCheck your inbox to create\na new password",
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.2
                    ),
                  ),
              
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: ButtonCostum(
                      text: "Back to Login", 
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context, 
                          MaterialPageRoute(builder: (context) => const LoginPage()), 
                          (route) => false,
                        );
                      }
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  void _handleConfirmEmail() {
    _showSuccesful();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f9ff),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
        
                    Image.asset('assets/l&n.png', height: 70,),
        
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 40, bottom: 25),
                        child: Text(
                          "Forget Password",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
        
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        "Enter your registered email address below. We'll send you a link to reset your password",
                        style: TextStyle(
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
        
                    FieldTextCustom(
                      controller: emailController, 
                      labelText: "Email"
                    ),
        
                    Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 15),
                      child: ButtonCostum(
                        text: "Confirm", 
                        onPressed: _handleConfirmEmail
                      )
                    ),
                  ],
                ),
              ),
            ),
        
            Positioned(
              top: 10,
              left: 15,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios),
              )
            )
          ],
        ),
      )
    );
  }
}