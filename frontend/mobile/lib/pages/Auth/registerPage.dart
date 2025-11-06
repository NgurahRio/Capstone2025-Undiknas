import 'package:flutter/material.dart';
import 'package:mobile/componen/buttonCostum.dart';
import 'package:mobile/componen/textField.dart';
import 'package:mobile/pages/Auth/loginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff3f9ff),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset('assets/l&n.png',),

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 15),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
          
              FieldTextCustom(
                controller: nameController, 
                labelText: "Name"
              ),

              FieldTextCustom(
                controller: emailController, 
                labelText: "Email"
              ),

              FieldTextCustom(
                controller: passwordController, 
                labelText: "Password",
                isPassword: true,
                obscurePass: true,
              ),

              FieldTextCustom(
                controller: confPasswordController, 
                labelText: "Confirm Password",
                isPassword: true,
                obscureConfPass: true,
              ),

              Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 15),
                child: ButtonCostum(
                  text: "Sign Up", 
                  onPressed: () {}
                )
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have a UBX account? "),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Color(0xFF8AC4FA),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}