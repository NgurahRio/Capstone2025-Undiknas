import 'dart:convert';
import 'dart:typed_data';

import 'package:admin_website/components/ButtonCostum.dart';
import 'package:admin_website/components/TextFieldCostum.dart';
import 'package:admin_website/components/WebPickerFile.dart';
import 'package:admin_website/models/subPackage_model.dart';
import 'package:flutter/material.dart';

class AddSubPackage extends StatefulWidget {
  final VoidCallback onClose;
  final Function(SubPackage) onSave;
  final SubPackage? existingSubPackage;

  const AddSubPackage({
    super.key, 
    required this.onClose, 
    required this.onSave, 
    this.existingSubPackage
  });

  @override
  State<AddSubPackage> createState() => _AddSubPackageState();
}

class _AddSubPackageState extends State<AddSubPackage> {
  TextEditingController subPackageName = TextEditingController();

  Uint8List? previewIcon;
  bool isHover = false;

  bool isBase64(String data) {
    return data.length > 100;
  }

  @override
  void initState() {
    super.initState();

    if (widget.existingSubPackage != null) {
      subPackageName.text = widget.existingSubPackage!.name;

      if (isBase64(widget.existingSubPackage!.icon)) {
        previewIcon = base64Decode(widget.existingSubPackage!.icon);
      } else {
        previewIcon = null;
      }
    }
  }

  Future<void> onPickImage() async {
    final result = await pickImageWeb();

    if (result == null) return;

    setState(() {
      previewIcon = result.bytes;
    });
  }

  Widget fieldLabel ({
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 5),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12, 
          fontWeight: FontWeight.w600
        ),
      ),
    );
  }

  void clearForm() {
    subPackageName.clear();
    previewIcon = null;
  }

  Future<void> saveSubPackage() async {
    try {
      if (widget.existingSubPackage == null) {
        final newSubPackage = await createSubPackage(
          jenisPackage: subPackageName.text.trim(), 
          iconBytes: previewIcon!,
        );

        if (newSubPackage == null) return;

        widget.onSave(
          SubPackage(
            id_subPackage: newSubPackage.id_subPackage, 
            name: newSubPackage.name, 
            icon: base64Encode(previewIcon!),
          )
        );
      } else {
        final success = await updateSubPackage(
          idSubPackage: widget.existingSubPackage!.id_subPackage, 
          jenisPackage: subPackageName.text.trim(), 
          iconBytes: previewIcon!,
        );

        if (!success) return;

        widget.onSave(
          SubPackage(
            id_subPackage: widget.existingSubPackage!.id_subPackage, 
            name: subPackageName.text.trim(), 
            icon: previewIcon != null ? base64Encode(previewIcon!) : widget.existingSubPackage!.icon,
          )
        );
      }

      clearForm();
      widget.onClose();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.existingSubPackage == null 
              ? "Sub Package added successfully." 
              : "Sub Package updated successfully."
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Card(
        color: Colors.white,
        shadowColor: const Color(0x5FA6A6A6),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.existingSubPackage == null ? "Create Sub Package" : "Edit Sub Package",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                      
                    TextButton(
                      onPressed: widget.onClose, 
                      child: const Text(
                        "Close",
                        style: TextStyle(color: Colors.black),
                      )
                    )
                  ],
                ),
              ),

              fieldLabel(text: "Sub Package Name"),

              TextFieldCostum(
                controller: subPackageName, 
                text: "write sub package name"
              ),

              fieldLabel(text: "Icon"),

              MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() => isHover = true),
                onExit: (_) => setState(() => isHover = false),
                child: GestureDetector(
                  onTap: onPickImage,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: isHover
                          ? const Color(0xFFEFF6FF)
                          : Colors.transparent,
                      border: Border.all(
                        color: isHover ? Colors.black : Colors.grey,
                        width: isHover ? 1.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: previewIcon == null
                            ? const Center(
                                child: Text(
                                  "Choose File",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.memory(
                                  previewIcon!,
                                  fit: BoxFit.contain,
                                ),
                              ),
                        ),
              
                        if (isHover)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Icon(
                                  previewIcon == null ? Icons.file_upload_outlined : Icons.edit,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ButtonCostum2(
                  text: widget.existingSubPackage == null ? "Save Sub Package" : "Update Sub Package",
                  onPressed: saveSubPackage
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}