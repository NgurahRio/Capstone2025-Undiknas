import 'package:flutter/material.dart';
import 'package:mobile/componen/buttonCostum.dart';
import 'package:mobile/componen/headerCustom.dart';
import 'package:mobile/pages/Auth/loginPage.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isChangePassword = false;

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confNewPasswordController = TextEditingController();

  Widget _buttonEdit({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              const BoxShadow(
                color: Color.fromARGB(56, 0, 0, 0),
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Wrap(
            spacing: 7,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(icon, size: 30),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _obscureOldPass = true;
  bool _obscureNewPass = true;
  bool _obscureConfirmPass = true;

  Widget _passwordField({
    required TextEditingController controller,
    required String title,
    bool isOldPassword = false,
    bool isNewPassword = false,
    bool isConfirmPassword = false,
  }) {
    bool obscurePass = isOldPassword
      ? _obscureOldPass
      : isNewPassword
        ? _obscureNewPass
        : _obscureConfirmPass;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: obscurePass,
        decoration: InputDecoration(
          hintText: title,
          hintStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 230, 230, 230),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.5,
            ),
          ),
          suffixIcon: isOldPassword
            ? IconButton(
                icon: Icon(
                  obscurePass ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _obscureOldPass = !_obscureOldPass;
                  });
                },
              )
            : isNewPassword
              ? const Icon(Icons.lock_outline, color: Colors.black)
              : null,
        ),
      ),
    );
  }

  void _showSuccesfulChange () {
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          alignment: Alignment.center,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 120),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "Change Succesful",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          )   
        );
      }
    );
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) Navigator.pop(context);
    });
  }

  void _handleLogout() {
    // await SharedPreferences.getInstance()..clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  void _handleChangePassword() {
    final oldPass = oldPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirmPass = confNewPasswordController.text.trim();

    FocusScope.of(context).unfocus();

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields must be filled.")),
      );
      return;
    }

    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("New password and confirmation do not match.")),
      );
      return;
    }

    if (newPass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 6 characters.")),
      );
      return;
    }

    _showSuccesfulChange();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        isChangePassword = false;
        oldPasswordController.clear();
        newPasswordController.clear();
        confNewPasswordController.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f9ff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85),
        child: Header(title: "Profile", onTap: () {}),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 60),
        child: Center(
          child: Column(
            children: [
              if (isChangePassword)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        "Change Password",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: Column(
                        children: [
                          _passwordField(
                            controller: oldPasswordController, 
                            title: "Old Password",
                            isOldPassword: true,
                          ),
                          _passwordField(
                            controller: newPasswordController,
                            title: "New Password",
                            isNewPassword: true,
                          ),
                          _passwordField(
                            controller: confNewPasswordController,
                            title: "Confirm Password",
                            isConfirmPassword: true,
                          ),
                        ],
                      ),
                    ),

                    ButtonCostum(
                      text: "Confirm Change",
                      height: 55,
                      onPressed: _handleChangePassword
                    )
                  ],
                )
              else
                Column(
                  children: [
                    const Text(
                      "Riyo Sumedang",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text("riyookkkkk@gmail.com"),

                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 40),
                      child: Column(
                        children: [
                          _buttonEdit(
                            icon: Icons.manage_accounts,
                            title: "Edit name",
                            onTap: () {},
                          ),
                          _buttonEdit(
                            icon: Icons.lock_outline,
                            title: "Change password",
                            onTap: () {
                              setState(() {
                                isChangePassword = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFE67777),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Wrap(
                        spacing: 5,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: const [
                          Text(
                            "Log Out",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(Icons.logout),
                        ],
                      ),
                      onPressed: _handleLogout,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
