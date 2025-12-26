import 'package:flutter/material.dart';
import 'package:mobile/componen/buttonCostum.dart';
import 'package:mobile/models/user_model.dart';

class EditNameSection extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSuccess;

  const EditNameSection({
    super.key,
    required this.onBack,
    required this.onSuccess,
  });

  @override
  State<EditNameSection> createState() => _EditNameSectionState();
}

class _EditNameSectionState extends State<EditNameSection> {
  final TextEditingController nameController = TextEditingController();

  Future<void> _handleChangeName() async {
    final newName = nameController.text.trim();

    FocusScope.of(context).unfocus();

    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username tidak boleh kosong")),
      );
      return;
    }

    try {
      await updateProfile(username: newName);

      // Update UI parent
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
                "Change Username",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: "New Username",
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: ButtonCostum(
            text: "Confirm Change",
            height: 55,
            onPressed: _handleChangeName,
          ),
        ),
      ],
    );
  }
}