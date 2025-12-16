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
  List<Destination> destinations = [];
  List<SubPackage> subPackages = [];
  bool isLoading = true;

  Future<void> loadData() async {
    try {
      final destData = await getDestinations();
      final subPackData = await getSubPackages();

      setState(() {
        destinations = destData;
        subPackages = subPackData;
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
      debugPrint(e.toString());
    }
  }

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
    loadData();

    final p = widget.existingPackage;
    if (p == null) return;

    selectedDestination = p.destinationId;
    selectedSubPackages = p.subPackages.keys.toList();

    for (final sp in selectedSubPackages) {
      final data = p.subPackages[sp]!;
      final form = PackageTypeFormData();

      // price
      form.price.text = formatRupiah(data["price"]);

      // include
      final includes = data["include"] as List;
      for (final inc in includes) {
        form.includedItems.add(inc["name"]);

        final img = inc["image"];
        if (img != null && img.isNotEmpty) {
          try {
            form.includedImages.add(base64Decode(img));
          } catch (_) {
            form.includedImages.add(img);
          }
        }
      }

      perTypeForm[sp.id_subPackage] = form;
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
      debugPrint("Please select destination!");
      return;
    }

    if (selectedSubPackages.isEmpty) {
      debugPrint("Please select at least one package type!");
      return;
    }

    final Map<SubPackage, Map<String, dynamic>> subPackageMap = {};

    for (final sp in selectedSubPackages) {
      final form = perTypeForm[sp.id_subPackage]!;

      // ===== PRICE =====
      final cleanPrice = form.price.text.replaceAll('.', '');
      if (cleanPrice.isEmpty) {
        debugPrint("Price for ${sp.name} is empty");
        return;
      }

      final int price = int.parse(cleanPrice);

      // ===== INCLUDE =====
      final List<Map<String, String>> includes = [];

      for (int i = 0; i < form.includedItems.length; i++) {
        final img = form.includedImages[i];

        String imageEncoded = "";

        if (img is Uint8List) {
          imageEncoded = base64Encode(img);
        } else if (img is String) {
          imageEncoded = img;
        }

        includes.add({
          "image": imageEncoded,
          "name": form.includedItems[i],
        });
      }

      // ===== MAP KE MODEL KEDUA =====
      subPackageMap[sp] = {
        "price": price,
        "include": includes,
      };
    }

    final newPackage = Package(
      id_package: widget.existingPackage?.id_package
          ?? DateTime.now().millisecondsSinceEpoch,
      destinationId: selectedDestination!,
      subPackages: subPackageMap,
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
                          selectedDestination?.name ?? "Select destination",
                          style: TextStyle(
                            color: selectedDestination == null ? const Color(0xFFB6B6B6) : Colors.black,
                            fontSize: 13,
                          ),
                        ),
                        Icon(
                          _isDropdownDestination
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down
                        ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
                        Icon(
                          _isDropdownType
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down
                        ),
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
                                  height: 35,
                                  width: 35,
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