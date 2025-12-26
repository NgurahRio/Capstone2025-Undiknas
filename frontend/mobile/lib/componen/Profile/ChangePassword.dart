import 'package:flutter/material.dart';
import 'package:mobile/componen/buttonCostum.dart';
import 'package:mobile/models/user_model.dart';

class ChangePasswordSection extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSuccess;

  const ChangePasswordSection({
    super.key,
    required this.onBack,
    required this.onSuccess,
  });

  @override
  State<ChangePasswordSection> createState() => _ChangePasswordSectionState();
}

class _ChangePasswordSectionState extends State<ChangePasswordSection> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confNewPasswordController =
      TextEditingController();

  bool _obscureOldPass = true;
  bool _obscureNewPass = true;
  bool _obscureConfirmPass = true;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confNewPasswordController.dispose();
    super.dispose();
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility : Icons.visibility_off,
              color: Colors.black,
            ),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }

  Future<void> _handleChangePassword() async {
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
        const SnackBar(
          content: Text("New password and confirmation do not match."),
        ),
      );
      return;
    }

    if (newPass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password must be at least 6 characters."),
        ),
      );
      return;
    }

    try {
      await updateProfile(
        oldPassword: oldPass,
        newPassword: newPass,
      );

      widget.onSuccess();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Wrap(
            spacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              GestureDetector(
                onTap: widget.onBack,
                child: const Icon(Icons.arrow_back_ios),
              ),
              const Text(
                "Change Password",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        _passwordField(
          controller: oldPasswordController,
          hint: "Old Password",
          obscure: _obscureOldPass,
          onToggle: () {
            setState(() => _obscureOldPass = !_obscureOldPass);
          },
        ),

        _passwordField(
          controller: newPasswordController,
          hint: "New Password",
          obscure: _obscureNewPass,
          onToggle: () {
            setState(() => _obscureNewPass = !_obscureNewPass);
          },
        ),

        _passwordField(
          controller: confNewPasswordController,
          hint: "Confirm Password",
          obscure: _obscureConfirmPass,
          onToggle: () {
            setState(() =>
                _obscureConfirmPass = !_obscureConfirmPass);
          },
        ),

        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: ButtonCostum(
            text: "Confirm Change",
            height: 55,
            onPressed: _handleChangePassword,
          ),
        ),
      ],
    );
  }
}
