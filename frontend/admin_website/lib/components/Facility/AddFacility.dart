import 'dart:convert';
import 'package:admin_website/components/ButtonCostum.dart';
import 'package:admin_website/components/TextFieldCostum.dart';
import 'package:admin_website/components/WebPickerFile.dart';
import 'package:admin_website/models/facility_model.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

class AddFacility extends StatefulWidget {
  final VoidCallback onClose;
  final Function(Facility) onSave;
  final Facility? existingFacility;

  const AddFacility({
    super.key,
    required this.onClose,
    required this.onSave,
    this.existingFacility,
  });


  @override
  State<AddFacility> createState() => _AddFacilityState();
}

class _AddFacilityState extends State<AddFacility> {
  TextEditingController facilityName = TextEditingController();

  Uint8List? previewIcon;

  bool isHover = false;

  bool isBase64(String data) {
    return data.length > 100;
  }

  @override
  void initState() {
    super.initState();

    if (widget.existingFacility != null) {
      facilityName.text = widget.existingFacility!.name;

      if (isBase64(widget.existingFacility!.icon)) {
        previewIcon = base64Decode(widget.existingFacility!.icon);
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
    facilityName.clear();
    previewIcon = null;
  }

  Future<void> saveFacility() async {
    try {
      if (widget.existingFacility == null) {
        final newFacility = await createFacility(
          nameFacility: facilityName.text.trim(),
          iconBytes: previewIcon!,
        );

        if (newFacility == null) return;

        widget.onSave(
          Facility(
            id_facility: newFacility.id_facility,
            name: newFacility.name,
            icon: base64Encode(previewIcon!),
          ),
        );
      } else {
        final success = await updateFacility(
          idFacility: widget.existingFacility!.id_facility,
          nameFacility: facilityName.text.trim(),
          iconBytes: previewIcon,
        );

        if (!success) return;

        widget.onSave(
          Facility(
            id_facility: widget.existingFacility!.id_facility,
            name: facilityName.text,
            icon: previewIcon != null
                ? base64Encode(previewIcon!)
                : widget.existingFacility!.icon,
          ),
        );
      }

      clearForm();
      widget.onClose();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.existingFacility == null
                ? 'Facility berhasil ditambahkan'
                : 'Facility berhasil diperbarui',
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
                      widget.existingFacility == null ? "Create Facility" : "Edit Facility",
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
      
              fieldLabel(text: "Facility Name"),

              TextFieldCostum(
                controller: facilityName, 
                text: "write facility name"
              ),

              fieldLabel(text: "Icon"),

              Row(
                children: [
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
                                      fit: BoxFit.cover,
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
                                  child: const Center(
                                    child: Icon(
                                      Icons.edit,
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
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ButtonCostum2(
                  text: widget.existingFacility == null ? "Save Facility" : "Update Facility",
                  onPressed: saveFacility
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}