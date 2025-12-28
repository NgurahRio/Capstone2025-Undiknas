import 'package:admin_website/components/ButtonCostum.dart';
import 'package:admin_website/components/CardCostum.dart';
import 'package:admin_website/components/DeletePopup.dart';
import 'package:admin_website/components/HeaderCostum.dart';
import 'package:admin_website/components/SubPackage/AddSubPackage.dart';
import 'package:admin_website/components/Table/ActionButton.dart';
import 'package:admin_website/components/Table/TabelContent.dart';
import 'package:admin_website/components/Table/TableHeader.dart';
import 'package:admin_website/models/subPackage_model.dart';
import 'package:flutter/material.dart';

class SubPackagePage extends StatefulWidget {
  const SubPackagePage({super.key});

  @override
  State<SubPackagePage> createState() => _SubPackagePageState();
}

class _SubPackagePageState extends State<SubPackagePage> {
  TextEditingController searchSubPackage = TextEditingController();

  bool openAddSubPackage = false;

  SubPackage? editingSubPackage;
  List<SubPackage> subPackages = [];
  List<SubPackage> subPackageSearch = [];
  bool isLoading = true;

  Future<void> loadSubPackages() async {
    try {
      final data = await getSubPackages();
      setState(() {
        subPackages = data;
        subPackageSearch = data;
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
      debugPrint(e.toString());
    }
  }

  void _searchFunction() {
    String query = searchSubPackage.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        subPackageSearch = subPackages;
      } else {
        subPackageSearch = subPackages.where(
          (s) => s.name.toLowerCase().contains(query)
        ).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadSubPackages();
    searchSubPackage.addListener(_searchFunction);
  }

  void removeSubPackage (int id) {
    showPopUpDelete(
      context: context, 
      text: "Sub Package", 
      onDelete: () async {
        try {
          await deleteSubPackage(id);
          setState(() {
            subPackages.removeWhere((s) => s.id_subPackage == id);
            subPackageSearch.removeWhere((s) => s.id_subPackage == id);
            searchSubPackage.clear();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Sub Package deleted successfully."),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                
                HeaderCostum(controller: searchSubPackage),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Manage Sub Packages",
                        style: TextStyle(fontSize: 20),
                      ),

                      ButtonCostum(
                        text: "Add Sub Package",
                        onPressed: () {
                          setState(() {
                            openAddSubPackage = true;
                          });
                        },
                      )
                    ],
                  ),
                ),

                if(openAddSubPackage)
                  AddSubPackage(
                    existingSubPackage: editingSubPackage,
                    onClose: () {
                      setState(() {
                        openAddSubPackage = false;
                        editingSubPackage = null;
                      });
                    },
                    onSave: (updatedSubPackage) {
                      setState(() {
                        if (editingSubPackage == null) {
                          subPackages.add(updatedSubPackage);
                        } else {
                          final index = subPackages.indexWhere(
                              (s) => s.id_subPackage == updatedSubPackage.id_subPackage);
                          subPackages[index] = updatedSubPackage;
                        }
                      });
                    },
                  ),

                if(isLoading)
                  const Center(
                    child: CircularProgressIndicator()
                  )
                else
                  CardCostum(
                    content: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              TableHeader(title: "Icon"),
                              TableHeader(title: "Name", flex: 2,),
                              TableHeader(title: "Actions", flex: 5,),             
                            ],
                          ),
                        ),

                        const Divider(height: 1,),

                        ...subPackageSearch.asMap().entries.map((entry) {
                          final index = entry.key;
                          final subPac = entry.value;

                          final bool isEven = index % 2 == 0;

                          return Container(
                            color: isEven ? Colors.white : const Color.fromARGB(255, 237, 246, 255),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  TableContent(
                                    isIcon: true, 
                                    title: subPac.icon,
                                  ),
                                  TableContent(title: subPac.name, flex: 2,),

                                  Expanded(
                                    flex: 5,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Actionbutton(
                                          label: "Edit",
                                          onTap: () {
                                            setState(() {
                                              openAddSubPackage = true;
                                              editingSubPackage = subPac;
                                            });
                                          },
                                        ),
                                        Actionbutton(
                                          isDelete: true,
                                          label: "Delete", 
                                          onTap: () => removeSubPackage(subPac.id_subPackage), 
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    )
                  )
              ],
            ),
          ),
        )
      ),
    );
  }
}