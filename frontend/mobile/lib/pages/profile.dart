import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile/componen/Profile/ChangePassword.dart';
import 'package:mobile/componen/Profile/EditName.dart';
import 'package:mobile/componen/buttonCostum.dart';
import 'package:mobile/componen/formatImage.dart';
import 'package:mobile/componen/headerCustom.dart';
import 'package:mobile/models/user_model.dart';
import 'package:mobile/pages/Auth/auth_service.dart';
import 'package:mobile/pages/Auth/loginPage.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({super.key,});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isChangePassword = false;
  bool isEditingName = false;

  File? _selectedImage;

  String? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _profileImage = User.currentUser?.image;
  }

  Future<void> _uploadProfileImage() async {
    if (_selectedImage == null) return;

    try {
      final updatedUser = await updateProfile(
        imageFile: _selectedImage,
      );

      setState(() {
        _profileImage = updatedUser.image;
        _selectedImage = null;
      });

      _showSuccesfulChange();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }


  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
    });

    Navigator.pop(context);

    await _uploadProfileImage();
  }

  Future<void> _pickFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
    });

    Navigator.pop(context);

    await _uploadProfileImage();
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
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pop(context);

              try {
                await updateProfile(removeImage: true);

                if (!mounted) return;
                setState(() {
                  _profileImage = '';
                });
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
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

  void handleLogout(BuildContext context) async {
    try {
      await AuthService.logout();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = User.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xfff3f9ff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85),
        child: Header(title: "Profile",),
      ),
      body: Column(
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
                          ChangePasswordSection(
                            onBack: () {
                              setState(() {
                                isChangePassword = false;
                              });
                            },
                            onSuccess: () {
                              _showSuccesfulChange();
                              Future.delayed(const Duration(seconds: 2), () {
                                if (!mounted) return;
                                setState(() {
                                  isChangePassword = false;
                                });
                              });
                            },
                          )
                        else
                          if (isEditingName)
                            EditNameSection(
                              onBack: () {
                                setState(() {
                                  isEditingName = false;
                                });
                              },
                              onSuccess: () {
                                _showSuccesfulChange();
                                Future.delayed(const Duration(seconds: 2), () {
                                  if (!mounted) return;
                                  setState(() {
                                    isEditingName = false;
                                  });
                                });
                              },
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
                                      child: user.image.isNotEmpty
                                        ?  ClipOval(
                                            child: Image(
                                              image: formatImage(user.image),
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
                                        onTap: () {
                                          setState(() {
                                            isEditingName = true;
                                          });
                                        },
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
                                  onPressed: () => handleLogout(context),
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

        ],
      ),
    );
  }
}
