import 'package:admin_website/components/TextFieldCostum.dart';
import 'package:admin_website/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  void _handleLogin() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.login(username.text.trim(), password.text.trim());

    Future.microtask(() {
      if (authService.isLoggedIn) {
        context.go('/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Username atau password salah!"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 350,
          child: Card(
            color: Colors.white,
            elevation: 15,
            shadowColor: const Color(0x5FA6A6A6),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/iconWeb.png", height: 75,),
          
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      "ADMIN LOGIN",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
          
                  TextFieldLogin(
                    controller: username, 
                    labelText: "Username",
                  ),
          
                  TextFieldLogin(
                    controller: password, 
                    labelText: "Password",
                    isPassword: true,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 10),
                      child: InkWell(
                        child: const Text(
                          "Forgot Password",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF8AC4FA),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: _handleLogin,
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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