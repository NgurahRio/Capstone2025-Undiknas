import 'package:admin_website/components/ButtonCostum.dart';
import 'package:admin_website/components/CardCostum.dart';
import 'package:admin_website/components/DeletePopup.dart';
import 'package:admin_website/components/HeaderCostum.dart';
import 'package:admin_website/components/Package/AddPackage.dart';
import 'package:admin_website/components/Package/DetailPackage.dart';
import 'package:admin_website/components/Table/ActionButton.dart';
import 'package:admin_website/components/Table/TabelContent.dart';
import 'package:admin_website/components/Table/TableHeader.dart';
import 'package:admin_website/models/package_model.dart';
import 'package:flutter/material.dart';

class PackagePage extends StatefulWidget {
  const PackagePage({super.key});

  @override
  State<PackagePage> createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage> {
  TextEditingController searchPackage = TextEditingController();

  bool openAddPackage = false;

  Package? editingPackage;
  List<Package> packageSearch = [];
  List<Package> packages = [];
  bool isLoading = true;

  Future<void> loadPackages() async {
    try {
      final data = await getPackages();
      setState(() {
        packages = data;
        packageSearch = data;
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
      debugPrint(e.toString());
    }
  }

  void _searchFunction() {
    String query = searchPackage.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        packageSearch = packages;
      } else {
        packageSearch = packages.where((pac) {
          final matchDestination = pac.destinationId.name.toLowerCase().contains(query);
          final matchSubPackage =
            pac.subPackages.keys.any(
              (sub) => sub.name.toLowerCase().contains(query),
            );

          return matchDestination || matchSubPackage;
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadPackages();
    searchPackage.addListener(_searchFunction);
  }

  void removePackage(int id) {
    showPopUpDelete(
      context: context, 
      text: "Package", 
      onDelete: ()  async {
        try {
          await deletePackage(id);
          setState(() {
            packages.removeWhere((item) => item.destinationId.id_destination == id);
            packageSearch = packages;
            searchPackage.clear();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Package deleted successfully')),
          );
        } catch (e) {
          debugPrint(e.toString());
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                HeaderCostum(controller: searchPackage),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Manage Your Packages",
                        style: TextStyle(fontSize: 20),
                      ),

                      ButtonCostum(
                        text: "Add Package", 
                        onPressed: () {
                          setState(() {
                            openAddPackage = true;
                          });
                        }
                      )
                    ],
                  ),
                ),

                if (openAddPackage)
                  AddPackage(
                    packages: packages,
                    existingPackage: editingPackage,
                    onClose: () {
                      setState(() {
                        openAddPackage = false;
                        editingPackage = null;
                      });
                    },
                    onSave: () async {
                      await loadPackages();
                    },
                      
                  ),

                CardCostum(
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            TableHeader(title: "Name",),
                            TableHeader(title: "Type"),
                            TableHeader(title: "Ticket",  flex: 3,),            
                            TableHeader(title: "Actions", flex: 2,),             
                          ],
                        ),
                      ),

                      const Divider(height: 1,),

                      ...packageSearch.asMap().entries.map((entry) {
                        final index = entry.key;
                        final pac = entry.value;

                        final bool isEven = index % 2 == 0;

                        return Container(
                          color: isEven ? Colors.white : const Color(0xFFEDF6FF),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                TableContent(title: pac.destinationId.name),
                                const TableContent(title: "Destination"),
                                TableContent(
                                  title: pac.subPackages.keys.map((s) => s.name).join(", "), 
                                  flex: 3,
                                ),
                            
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Actionbutton(
                                        label: "View Detail", 
                                        onTap: () => showDetailPackage(context, pac.destinationId.id_destination),
                                      ),
                                      Actionbutton(
                                        label: "Edit", 
                                        onTap: () {
                                          setState(() {
                                            editingPackage = pac;
                                            openAddPackage = true;
                                          });
                                        },
                                      ),
                                      Actionbutton(
                                        isDelete: true,
                                        label: "Delete", 
                                        onTap: () => removePackage(pac.destinationId.id_destination), 
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