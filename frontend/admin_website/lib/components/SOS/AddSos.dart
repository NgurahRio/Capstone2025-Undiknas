import 'package:admin_website/components/ButtonCostum.dart';
import 'package:admin_website/components/OpenGoogleMaps.dart';
import 'package:admin_website/components/TextFieldCostum.dart';
import 'package:admin_website/models/sos_model.dart';
import 'package:flutter/material.dart';

class AddSos extends StatefulWidget {
  final VoidCallback onClose;
  final Function(SOS) onSave;
  final SOS? existingSos;

  const AddSos({
    super.key,
    required this.onClose,
    required this.onSave,
    this.existingSos,
  });


  @override
  State<AddSos> createState() => _AddSosState();
}

class _AddSosState extends State<AddSos> {
  TextEditingController sosName = TextEditingController();
  TextEditingController sosLocation = TextEditingController();
  TextEditingController sosNumber = TextEditingController();

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

  @override
  void initState() {
    super.initState();

    if (widget.existingSos != null) {
      sosName.text = widget.existingSos!.name;
      sosLocation.text = widget.existingSos!.address;
      sosNumber.text = widget.existingSos!.phone;
    }
  }

  void clearForm() {
    sosName.clear();
    sosLocation.clear();
    sosNumber.clear();
  }

  void saveSOS() {
    final sosData = SOS(
      id_sos: widget.existingSos?.id_sos ?? DateTime.now().millisecondsSinceEpoch,
      name: sosName.text,
      address: sosLocation.text,
      phone: sosNumber.text,
    );

    widget.onSave(sosData);

    clearForm();

    widget.onClose();
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
                      widget.existingSos == null ? "Create SOS" : "Edit Sos",
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
      
              fieldLabel(text: "Sos Name"),

              TextFieldCostum(
                controller: sosName, 
                text: "write sos (save our souls) name"
              ),

              fieldLabel(text: "Location"),

              Row(
                children: [
                  Expanded(
                    child: TextFieldCostum(
                      controller: sosLocation, 
                      text: "Enter location or address"
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ButtonCostum3(
                      icon: Icons.map_outlined, 
                      text: "Gmaps", 
                      onTap: () {
                        OpenMap.openGoogleMaps(sosLocation.text);
                      }
                    ),
                  )
                ],
              ),

              fieldLabel(text: "Number"),

              TextFieldCostum(
                controller: sosNumber, 
                text: "Write phone number"
              ),

              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ButtonCostum2(
                  text: widget.existingSos == null ? "Save SOS" : "Update SOS",
                  onPressed: saveSOS
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}