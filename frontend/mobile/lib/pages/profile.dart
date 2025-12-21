import 'package:flutter/material.dart';
import 'package:mobile/componen/buttonCostum.dart';
import 'package:mobile/componen/formateImage.dart';
import 'package:mobile/componen/headerCustom.dart';
import 'package:mobile/models/user_model.dart';
import 'package:mobile/pages/Auth/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final User? currentUser;

  const ProfilePage({super.key, this.currentUser});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isChangePassword = false;

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confNewPasswordController = TextEditingController();

  bool _obscureOldPass = true;
  final bool _obscureNewPass = true;
  final bool _obscureConfirmPass = true;

  String? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _profileImage = widget.currentUser?.image;
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);

    setState(() {
      _profileImage = base64Image;
    });

    Navigator.pop(context);
  }

  Future<void> _pickFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image == null) return;

    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);

    setState(() {
      _profileImage = base64Image;
    });

    Navigator.pop(context);
  }

  Widget _imagePickerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(icon),
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteImage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Apa Anda yakin menghapus gambar?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _profileImage = null;
              });

              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showProfileImageSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 222, 221, 221),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final hasImage =
            _profileImage != null && _profileImage!.isNotEmpty;

        return FractionallySizedBox(
          widthFactor: 1.0,
          heightFactor: hasImage ? 0.42 : 0.3,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasImage)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: _confirmDeleteImage,
                        child: Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 6),
                                child: Icon(Icons.delete, color: Colors.red),
                              ),
                              Text(
                                'Hapus Gambar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: _imagePickerItem(
                    icon: Icons.photo_library,
                    text: 'Pilih dari Galeri',
                    onTap: _pickFromGallery,
                  ),
                ),

                _imagePickerItem(
                  icon: Icons.camera_alt,
                  text: 'Ambil dari Kamera',
                  onTap: _pickFromCamera,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
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
            boxShadow: const [
              BoxShadow(
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

  void _showSuccesfulChange() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          backgroundColor: Colors.transparent,
          alignment: Alignment.center,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 120),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "Change Successful",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) Navigator.pop(context);
    });
  }

  void _handleLogout() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    User.currentUser = null;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
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
    final user = widget.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xfff3f9ff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85),
        child: Header(title: "Profile",),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 60),
            child: user == null
                ? Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          "You are not logged in.",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ButtonCostum(
                        text: "Login / Sign Up",
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        if (isChangePassword)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 15, top: 10),
                                child: Text(
                                  "Change Password",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 25),
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
                                onPressed: _handleChangePassword,
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 175,
                                    width: 175,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: _profileImage != null && _profileImage!.isNotEmpty
                                      ?  ClipOval(
                                          child: Image(
                                            image: formatImage(_profileImage!),
                                            height: 175,
                                            width: 175,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Icon( 
                                          Icons.account_circle,
                                          size: 175,
                                          color: Colors.grey[400],
                                        ),
                                  ),

                                  Positioned(
                                    right: 15,
                                    bottom: 10,
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(
                                          Icons.photo_camera,
                                          size: 25,
                                          color: Colors.black,
                                        ),
                                        onPressed: _showProfileImageSheet,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Text(
                                  user.username,
                                  style: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              Text(user.email),
                              
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
                                onPressed: _handleLogout,
                                child: const Wrap(
                                  spacing: 5,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
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
                              ),
                            ],
                          ),
                      ],
                    ),
                ),
          ),

          if(isChangePassword)
            Positioned(
              top: 15,
              left: 15,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isChangePassword = false;
                  });
                },
                child: const Icon(Icons.arrow_back_ios),
              )
            )

        ],
      ),
    );
  }
}
