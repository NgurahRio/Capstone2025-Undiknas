import 'package:admin_website/components/BoxContent.dart';
import 'package:admin_website/components/ButtonCostum.dart';
import 'package:admin_website/components/CurrencyFormat.dart';
import 'package:admin_website/components/TextFieldCostum.dart';
import 'package:admin_website/components/WebPickerFile.dart';
import 'package:admin_website/models/destination_model.dart';
import 'package:admin_website/models/package_model.dart';
import 'package:admin_website/models/subPackage_model.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';

class PackageTypeFormData {
  List<String> includedItems = [];
  List<dynamic> includedImages = [];

  Uint8List? previewIncluded;
  Uint8List? previewExcluded;

  TextEditingController price = TextEditingController();
}

class AddPackage extends StatefulWidget {
  final VoidCallback onClose;
  final Function(Package) onSave;
  final Package? existingPackage;

  const AddPackage({
    super.key,
    required this.onClose,
    required this.onSave,
    this.existingPackage,
  });

  @override
  State<AddPackage> createState() => _AddPackageState();
}

class _AddPackageState extends State<AddPackage> {
  TextEditingController included = TextEditingController();
  TextEditingController excluded = TextEditingController();

  Destination? selectedDestination;
  List<SubPackage> selectedSubPackages = [];

  Map<int, PackageTypeFormData> perTypeForm = {};

  List<Destination> get availableDestinations {
    final usedDestinationIds = packages.map((p) => p.destinationId.id_destination).toSet();

    if (widget.existingPackage != null) {
      usedDestinationIds.remove(widget.existingPackage!.destinationId.id_destination);
    }

    return destinations.where((d) => !usedDestinationIds.contains(d.id_destination)).toList();
  }

  @override
  void initState() {
    super.initState();

    if (widget.existingPackage != null) {
      final p = widget.existingPackage!;

      selectedDestination = p.destinationId;

      selectedSubPackages = [...p.subPackage];

      for (var sp in selectedSubPackages) {
        final form = PackageTypeFormData();

        final price = p.subPackagePrices[sp.id_subPackage] ?? 0;
        form.price.text = formatRupiah(price);

        if (p.includes.containsKey(sp.id_subPackage)) {
          for (var inc in p.includes[sp.id_subPackage]!) {
            form.includedItems.add(inc["name"]!);

            final icon = inc["icon"];
            if (icon != null && icon.isNotEmpty) {
              if (icon.startsWith("data:image") || icon.length > 200) {
                try {
                  form.includedImages.add(base64Decode(icon));
                } catch (_) {
                  form.includedImages.add(icon);
                }
              } else {
                form.includedImages.add(icon);
              }
            } else {
              form.includedImages.add(null);
            }
          }
        }

        perTypeForm[sp.id_subPackage] = form;
      }
    }
  }

  void togglePackageType(SubPackage sp, bool selected) {
    setState(() {
      if (selected) {
        selectedSubPackages.add(sp);

        perTypeForm.putIfAbsent(
          sp.id_subPackage,
          () => PackageTypeFormData(),
        );
      } else {
        selectedSubPackages.remove(sp);
        perTypeForm.remove(sp.id_subPackage);
      }
    });
  }

  Future<void> pickIncludedImage(int id) async {
    final result = await pickImageWeb();
    if (result == null) return;

    setState(() {
      perTypeForm[id]!.previewIncluded = result.bytes;
    });
  }

  Future<void> pickExcludedImage(int id) async {
    final result = await pickImageWeb();
    if (result == null) return;

    setState(() {
      perTypeForm[id]!.previewExcluded = result.bytes;
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

  OverlayEntry? _overlayDestination;
  final LayerLink _destinationLink = LayerLink();
  final GlobalKey _destinationKey = GlobalKey();
  bool _isDropdownDestination = false;

  OverlayEntry? _overlayType;
  final LayerLink _typeLink = LayerLink();
  final GlobalKey _typeKey = GlobalKey();
  bool _isDropdownType = false;

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

  void addIncludedItem(int id, TextEditingController ctrl) {
    if (ctrl.text.isEmpty) return;
    if (perTypeForm[id]!.previewIncluded == null) return;

    setState(() {
      perTypeForm[id]!.includedItems.add(ctrl.text);
      perTypeForm[id]!.includedImages.add(perTypeForm[id]!.previewIncluded);
      perTypeForm[id]!.previewIncluded = null;
      ctrl.clear();
    });
  }

  void deleteIncludedItem(int idSubPackage, int itemIndex) {
    setState(() {
      perTypeForm[idSubPackage]!.includedItems.removeAt(itemIndex);
      perTypeForm[idSubPackage]!.includedImages.removeAt(itemIndex);
    });
  }

  Future<void> savePackage() async {
    if (selectedDestination == null) {
      print("Please select destination!");
      return;
    }

    if (selectedSubPackages.isEmpty) {
      print("Please select at least one package type!");
      return;
    }

    final Map<int, int> prices = {};
    final Map<int, List<Map<String, String>>> includes = {};

    for (var sp in selectedSubPackages) {
      final form = perTypeForm[sp.id_subPackage]!;

      if (form.price.text.isEmpty) {
        print("Price for ${sp.name} is empty!");
        return;
      }
      String clean = form.price.text.replaceAll('.', '');

      if (clean.isEmpty) {
        print("Price for ${sp.name} is empty!");
        return;
      }

      prices[sp.id_subPackage] = int.parse(clean);

      includes[sp.id_subPackage] = List.generate(
        form.includedItems.length,
        (i) {
          final img = form.includedImages[i];

          String encodedIcon = "";

          if (img != null) {
            if (img is Uint8List) {
              encodedIcon = base64Encode(img);
            } else if (img is String) {
              encodedIcon = img;
            }
          }

          return {
            "icon": encodedIcon,
            "name": form.includedItems[i],
          };
        },
      );
    }

    final bool isEdit = widget.existingPackage != null;

    final newPackage = Package(
      id_package: isEdit 
          ? widget.existingPackage!.id_package 
          : DateTime.now().millisecondsSinceEpoch,
      destinationId: selectedDestination!,
      subPackage: selectedSubPackages,
      subPackagePrices: prices,
      includes: includes,
    );

    widget.onSave(newPackage);

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
                      widget.existingPackage == null ? "Create Package" : "Edit Package",
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
      
              fieldLabel(text: "Choose Destinasi"),
              CompositedTransformTarget(
                link: _destinationLink,
                key: _destinationKey,
                child: GestureDetector(
                  onTap: () {
                    if (_isDropdownDestination) {
                      _overlayDestination?.remove();
                      _overlayDestination = null;
                      setState(() => _isDropdownDestination = false);
                    } else {
                      _showDropdown(
                        link: _destinationLink,
                        keyButton: _destinationKey,
                        onSaveOverlay: (entry) => _overlayDestination = entry,
                        onVisibleChange: () => setState(() => _isDropdownDestination = true),
                        content: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 180,
                          ),
                          child: SingleChildScrollView(
                            child: ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              children: availableDestinations.map((d) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedDestination = d;
                                    });
                            
                                    _overlayDestination?.remove();
                                    _isDropdownDestination = false;
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    child: Text(
                                      d.name,
                                      style: const TextStyle(fontSize: 14),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 0.5),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDestination?.name ?? "Select destination",
                          style: TextStyle(
                            color: selectedDestination == null ? const Color(0xFFB6B6B6) : Colors.black,
                            fontSize: 13,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),

              fieldLabel(text: "Choose Package Type"),
              
              CompositedTransformTarget(
                link: _typeLink,
                key: _typeKey,
                child: GestureDetector(
                  onTap: () {
                    if (_isDropdownType) {
                      _overlayType?.remove();
                      _overlayType = null;
                      setState(() => _isDropdownType = false);
                    } else {
                      _showDropdown(
                        link: _typeLink,
                        keyButton: _typeKey,
                        onSaveOverlay: (entry) => _overlayType = entry,
                        onVisibleChange: () => setState(() => _isDropdownType = true),
                        content: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 180
                          ),
                          child: SingleChildScrollView(
                            child: StatefulBuilder(
                              builder: (context, setStateDialog) {
                                return ListView(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  children: subPackages.map((sp) {
                                    bool isSelected = selectedSubPackages.contains(sp);
                            
                                    return InkWell(
                                      onTap: () {
                                        setStateDialog(() {
                                          togglePackageType(sp, !isSelected);
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        child: Row(
                                          children: [
                                            Checkbox(
                                              value: isSelected,
                                              onChanged: (v) {
                                                setStateDialog(() {
                                                  togglePackageType(sp, v!);
                                                });
                                              },
                                            ),
                                            Text(
                                              sp.name,
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 0.5),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedSubPackages.isEmpty
                            ? "Select package type"
                            : selectedSubPackages.map((e) => e.name).join(", "),
                          style: TextStyle(
                            color: selectedSubPackages.isEmpty ? const Color(0xFFB6B6B6) : Colors.black,
                            fontSize: 13,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),

              if (selectedSubPackages.isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: selectedSubPackages.map((sp) {
                    final form = perTypeForm[sp.id_subPackage]!;
                    final incCtrl = TextEditingController();

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            fieldLabel(text: "Included Items (${sp.name})"),

                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black54, width: 0.5),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: form.previewIncluded == null
                                    ? const Center(
                                        child: Text(
                                          "File",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      )
                                    : Image.memory(form.previewIncluded!),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: ButtonCostum3(
                                    icon: Icons.file_upload_outlined,
                                    text: "choose",
                                    onTap: () => pickIncludedImage(sp.id_subPackage),
                                  ),
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFieldCostum(
                                      controller: incCtrl,
                                      text: "Add items",
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: ButtonCostum(
                                      isIcon: true,
                                      width: 100,
                                      text: "Add",
                                      onPressed: () => addIncludedItem(sp.id_subPackage, incCtrl),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            if (form.includedItems.isNotEmpty)
                              BoxAddContent(
                                items: form.includedItems,
                                images: form.includedImages,
                                delete: (i) => deleteIncludedItem(sp.id_subPackage, i),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

              if (selectedSubPackages.isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: selectedSubPackages.map((sp) {
                    final form = perTypeForm[sp.id_subPackage]!;

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            fieldLabel(text: "Price (${sp.name})"),

                            PriceField(
                              controller: form.price,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

               Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ButtonCostum2(
                  text: widget.existingPackage == null ? "Save Package" : "Update Package" ,
                  onPressed: savePackage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}