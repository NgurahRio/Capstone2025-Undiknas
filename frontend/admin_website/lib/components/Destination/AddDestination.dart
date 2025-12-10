import 'dart:convert';
import 'dart:typed_data';
import 'package:admin_website/components/BoxContent.dart';
import 'package:admin_website/components/ButtonCostum.dart';
import 'package:admin_website/components/OpenGoogleMaps.dart';
import 'package:admin_website/components/Table/TabelContent.dart';
import 'package:admin_website/components/TextFieldCostum.dart';
import 'package:admin_website/components/TimePicker.dart';
import 'package:admin_website/components/WebPickerFile.dart';
import 'package:admin_website/models/category_model.dart';
import 'package:admin_website/models/destination_model.dart';
import 'package:admin_website/models/facility_model.dart';
import 'package:admin_website/models/sos_model.dart';
import 'package:admin_website/models/subCategory_model.dart';
import 'package:flutter/material.dart';

class AddDestination extends StatefulWidget {
  final VoidCallback onClose;
  final Function(Destination) onSave;
  final Destination? existingDestination;

  const AddDestination({
    super.key,
    required this.onClose,
    required this.onSave,
    this.existingDestination,
  });

  @override
  State<AddDestination> createState() => _AddDestinationState();
}

class _AddDestinationState extends State<AddDestination> {
  TextEditingController destinationName = TextEditingController();
  TextEditingController description  = TextEditingController();
  TextEditingController operational  = TextEditingController();
  TextEditingController mapLink  = TextEditingController();
  TextEditingController location  = TextEditingController();
  TextEditingController latitude  = TextEditingController();
  TextEditingController longitude  = TextEditingController();
  TextEditingController dos  = TextEditingController();
  TextEditingController donts  = TextEditingController();
  TextEditingController safetyGuideline = TextEditingController();

  List<Uint8List> previewImages = [];
  List<dynamic> selectedCategories = [];
  List<dynamic> selectedSubCategories = [];
  List<dynamic> selectedFasility = [];
  List<String> dosItems = [];
  List<String> dontsItems = [];
  List<String> safetyGuidelinesItems =  [];

  TimeOfDay? openTime;
  TimeOfDay? closeTime;

  SOS? selectedSOS;

  Uint8List? facilitasIcon;

  List<String> convertImagesToBase64() {
    return previewImages.map((img) => base64Encode(img)).toList();
  }

  bool isBase64(String data) {
    return data.length > 200 || data.startsWith("iVBOR") || data.contains("data:image");
  }

  TimeOfDay parseTime(String time) {
    final parts = time.split(":");
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  @override
  void initState() {
    super.initState();

    final d = widget.existingDestination;

    if (d != null) {
      destinationName.text = d.name;
      description.text = d.description;
      mapLink.text = d.maps;
      location.text = d.location;
      operational.text = d.operational;
      if (d.operational.isNotEmpty) {
        final parts = d.operational.split(" - ");

        if (parts.length == 2) {
          openTime = parseTime(parts[0]);
          closeTime = parseTime(parts[1]);
        }
      }
      latitude.text = d.latitude.toString();
      longitude.text = d.longitude.toString();

      dosItems = [...d.dos ?? []];
      dontsItems = [...d.donts ?? []];
      safetyGuidelinesItems = [...d.safetyGuidelines ?? []];

      selectedFasility = d.facilities?.map((f) => f.id_facility).toList() ?? [];

      selectedCategories = d.subCategoryId.map((cat) => cat.categoryId.id_category).toSet().toList();
      selectedSubCategories = d.subCategoryId.map((subc) => subc.id_subCategory).toList();

      selectedSOS = d.sos?.isNotEmpty == true ? d.sos!.first : null;

      previewImages = d.imageUrl
          .where((img) => img.length > 100) 
          .map((img) => base64Decode(img))
          .toList();
    }
  }

  Future<void> onPickImage() async {
    if (previewImages.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Maksimal 5 foto saja!")),
      );
      return;
    }

    final result = await pickImageWeb();
    if (result == null) return;

    setState(() {
      previewImages.add(result.bytes);
    });
  }

  Future<void> onPickTime() async {
    final pickedOpen = await showAnalogPicker(
      context,
      initialTime: openTime,
    );

    if (pickedOpen == null) return;

    final pickedClose = await showAnalogPicker(
      context,
      isClose: true,
      initialTime: closeTime ?? pickedOpen,
    );

    if (pickedClose == null) return;

    setState(() {
      openTime = pickedOpen;
      closeTime = pickedClose;

      operational.text = "${format24(openTime!)} - ${format24(closeTime!)}";
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

  OverlayEntry? _overlaySOS;
  final LayerLink _sosLink = LayerLink();
  final GlobalKey _sosKey = GlobalKey();
  bool _isDropdownSOS = false;

  void _showDropdown({
    required LayerLink link,
    required GlobalKey keyButton,
    required ValueSetter<OverlayEntry> onSaveOverlay,
    required VoidCallback onVisibleChange,
    required Widget content,
  }) {
    final overlay = Overlay.of(context);
    final RenderBox renderBox = keyButton.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        width: size.width,
        child: CompositedTransformFollower(
          link: link,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 2),
          child: Material(
            color: Colors.white,
            elevation: 4,
            borderRadius: BorderRadius.circular(5),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: content,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    onSaveOverlay(overlayEntry);
    onVisibleChange();
  }

  void removeImageSelected(int index) {
    setState(() {
      previewImages.removeAt(index);
    });
  }

  void addDoItem() {
    if (dos.text.trim().isEmpty) return;

    setState(() {
      dosItems.add(dos.text.trim());
      dos.clear();
    });
  }

  void addDontItem() {
    if (donts.text.trim().isEmpty) return;

    setState(() {
      dontsItems.add(donts.text.trim());
      donts.clear();
    });
  }

  void addSafetyGuidelineItem() {
    if (safetyGuideline.text.trim().isEmpty) return;

    setState(() {
      safetyGuidelinesItems.add(safetyGuideline.text.trim());
      safetyGuideline.clear();
    });
  }

  void deleteDoItem(int index) {
    setState(() {
      dosItems.removeAt(index);
    });
  }

  void deleteDontItem(int index) {
    setState(() {
      dontsItems.removeAt(index);
    });
  }

  void deleteSafetyGuidelineItem(int index) {
    setState(() {
      safetyGuidelinesItems.removeAt(index);
    });
  }

  void saveDestination() {
    if (destinationName.text.isEmpty) return;

    final newDest = Destination(
      id_destination: widget.existingDestination?.id_destination ??
          DateTime.now().millisecondsSinceEpoch,

      name: destinationName.text.trim(),
      description: description.text.trim(),
      location: location.text.trim(),
      operational: operational.text.trim(),
      maps: mapLink.text.trim(),

      imageUrl: convertImagesToBase64(),

      latitude: double.tryParse(latitude.text.trim()) ?? 0.0,
      longitude: double.tryParse(longitude.text.trim()) ?? 0.0,

      subCategoryId: subCategories.where(
        (sub) => selectedSubCategories.contains(sub.id_subCategory),
      ).toList(),

      dos: [...dosItems],
      donts: [...dontsItems],
      safetyGuidelines: [...safetyGuidelinesItems],

      facilities: facilities
          .where((f) => selectedFasility.contains(f.id_facility))
          .toList(),

      sos: selectedSOS != null ? [selectedSOS!] : [],
    );

    widget.onSave(newDest);
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
                      widget.existingDestination == null ? "Create Destination" : "Edit Destination",
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
                    ),
                  ],
                ),
              ),

              fieldLabel(text: "Destination Galery (max 5 photo)"),

              Row(
                children: [
                  BoxImageContent(
                    images: previewImages, 
                    delete: removeImageSelected
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ButtonCostum3(
                      icon: Icons.file_upload_outlined, 
                      text: "upload", 
                      onTap: onPickImage
                    ),
                  ),
                ],
              ),  

              fieldLabel(text: "Tags Travel"), 

              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 5,
                  children: categories.map((cat) {
                    return Container(
                      width: 130,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black54, width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(cat.name),
                            Transform.scale(
                              scale: 0.8,
                              child: Checkbox(
                                side: const BorderSide(
                                  width: 0.5,
                                  color: Colors.black54,
                                ),
                                activeColor: const Color(0xFF8AC4FA),
                                value: selectedCategories.contains(cat.id_category),
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      selectedCategories.add(cat.id_category);
                                    } else {
                                      selectedCategories.remove(cat.id_category);
                                    }
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList()
                ),
              ),

              if (selectedCategories.isNotEmpty)
                ...selectedCategories.map((catId) {
                  final subs = subCategories
                    .where((sub) => sub.categoryId.id_category == catId)
                    .toList();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 5,
                      children: subs.map((sub) {
                        final isSubSelected = selectedSubCategories.contains(sub.id_subCategory);
                        return Container(
                          width: 130,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black54, width: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(sub.name),
                                Transform.scale(
                                  scale: 0.8,
                                  child: Checkbox(
                                    side: const BorderSide(
                                      width: 0.5,
                                      color: Colors.black54,
                                    ),
                                    activeColor: const Color(0xFF8AC4FA),
                                    value: isSubSelected,
                                    onChanged: (val) {
                                      setState(() {
                                        if (val == true) {
                                          selectedSubCategories.add(sub.id_subCategory);
                                        } else {
                                          selectedSubCategories.remove(sub.id_subCategory);
                                        }
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList()
                    ),
                  );
                }),

              fieldLabel(text: "Destination Name"),

              TextFieldCostum(
                controller: destinationName, 
                text: "write destination name"
              ),

              fieldLabel(text: "Description (max 100 words)"),

              TextFieldCostum(
                controller: description, 
                text: "write short description about the event"
              ),

              fieldLabel(text: "Facilities"),

              Wrap(
                spacing: 10,
                runSpacing: 5,
                children: facilities.map((fac) {
                  return IntrinsicWidth(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black54, width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [               
                          Row(
                            children: [
                              isBase64(fac.icon)
                                ? Image.memory(
                                    base64Decode(fac.icon),
                                    height: 20,
                                    width: 20,
                                  )
                                : Image.asset(
                                    fac.icon,
                                    height: 20,
                                    width: 20,
                                  ),
                                          
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(fac.name),
                              ),
                            ],
                          ),
                          Transform.scale(
                            scale: 0.8,
                            child: Checkbox(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              side: const BorderSide(
                                width: 0.5,
                                color: Colors.black54,
                              ),
                              activeColor: const Color(0xFF8AC4FA),
                              value: selectedFasility.contains(fac.id_facility),
                              onChanged: (val) {
                                setState(() {
                                  if (val == true) {
                                    selectedFasility.add(fac.id_facility);
                                  } else {
                                    selectedFasility.remove(fac.id_facility);
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList()
              ),

              fieldLabel(text: "Operational"),

              Row(
                children: [
                  Expanded(
                    child: TextFieldCostum(
                      controller: operational, 
                      text: "write destination operational hours"
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ButtonCostum3(
                      text: "clock", 
                      icon: Icons.access_time, 
                      onTap: onPickTime
                    ),
                  )
                ],
              ),

              fieldLabel(text: "Map Link"),

              Row(
                children: [
                  Expanded(
                    child: TextFieldCostum(
                      controller: mapLink, 
                      text: "write the destination map link"
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ButtonCostum3(
                      icon: Icons.map_outlined, 
                      text: "Gmaps", 
                      onTap: () {
                        OpenMap.openGoogleMaps(mapLink.text);
                      }
                    ),
                  )
                ],
              ),

              fieldLabel(text: "Location"),

              TextFieldCostum(
                controller: location, 
                text: "Enter location or address"
              ),

              fieldLabel(text: "Latitude"),
              
              TextFieldCostum(
                controller: latitude, 
                text: "write latitude destination"
              ),

              fieldLabel(text: "Longitude"),

              TextFieldCostum(
                controller: longitude, 
                text: "write longitude destination"
              ),


              fieldLabel(text: "Do & Don't"),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFieldCostum(
                        controller: dos,
                        text: "write do items",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: ButtonCostum(
                        isIcon: true,
                        width: 100,
                        text: "Add",
                        onPressed: addDoItem,
                      ),
                    ),
                  ],
                ),
              ),

              if(dosItems.isNotEmpty)
                BoxAddContent(
                  items: dosItems, 
                  delete: deleteDoItem
                ),

              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFieldCostum(
                        controller: donts,
                        text: "write don't items",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: ButtonCostum(
                        isIcon: true,
                        width: 100,
                        text: "Add",
                        onPressed: addDontItem,
                      ),
                    ),
                  ],
                ),
              ),

              if(dontsItems.isNotEmpty)
                BoxAddContent(
                  items: dontsItems, 
                  delete: deleteDontItem
                ),

              fieldLabel(text: "Safety Guidelines"),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFieldCostum(
                        controller: safetyGuideline,
                        text: "write safety guidelines",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: ButtonCostum(
                        isIcon: true,
                        width: 100,
                        text: "Add",
                        onPressed: addSafetyGuidelineItem,
                      ),
                    ),
                  ],
                ),
              ),

              if(safetyGuidelinesItems.isNotEmpty)
                BoxAddContent(
                  items: safetyGuidelinesItems, 
                  delete: deleteSafetyGuidelineItem
                ),

              fieldLabel(text: "Selected SOS"),
              
              CompositedTransformTarget(
                link: _sosLink,
                key: _sosKey,
                child: GestureDetector(
                  onTap: () {
                    if (_isDropdownSOS) {
                      _overlaySOS?.remove();
                      _overlaySOS = null;
                      setState(() => _isDropdownSOS = false);
                    } else {
                      _showDropdown(
                        link: _sosLink,
                        keyButton: _sosKey,
                        onSaveOverlay: (entry) => _overlaySOS = entry,
                        onVisibleChange: () => setState(() => _isDropdownSOS = true),
                        content: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 180,
                          ),
                          child: SingleChildScrollView(
                            child: ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              children: sos.map((d) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedSOS = d;
                                    });
                            
                                    _overlaySOS?.remove();
                                    _isDropdownSOS = false;
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Row(
                                      children: [
                                        TableContent(title: d.name),
                                        TableContent(title: d.address, flex: 2,),
                                        TableContent(title: d.phone),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 0.5),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedSOS == null
                            ? "Select SOS (Save Our Souls)"
                            : "${selectedSOS!.name} - ${selectedSOS!.address} (${selectedSOS!.phone})",
                          style: TextStyle(
                            color: selectedSOS == null ? const Color(0xFFB6B6B6) : Colors.black,
                            fontSize: 13,
                          ),
                        ),
                        Icon(
                          _isDropdownSOS 
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ButtonCostum2(
                  text: widget.existingDestination == null ? "Save Destination" : "Update Destination" ,
                  onPressed: saveDestination,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}