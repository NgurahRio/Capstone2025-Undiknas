import 'package:admin_website/components/ButtonCostum.dart';
import 'package:admin_website/components/CardCostum.dart';
import 'package:admin_website/components/DeletePopup.dart';
import 'package:admin_website/components/Facility/AddFacility.dart';
import 'package:admin_website/components/HeaderCostum.dart';
import 'package:admin_website/components/Table/ActionButton.dart';
import 'package:admin_website/components/Table/TabelContent.dart';
import 'package:admin_website/components/Table/TableHeader.dart';
import 'package:admin_website/models/facility_model.dart';
import 'package:flutter/material.dart';

class FacilityPage extends StatefulWidget {
  const FacilityPage({super.key});

  @override
  State<FacilityPage> createState() => _FacilityPageState();
}

class _FacilityPageState extends State<FacilityPage> {
  TextEditingController searchFacility = TextEditingController();

  bool openAddFasility = false;

  Facility? editingFacility;
  List<Facility> facilitySearch = [];

  void _searchFunction() {
    String query = searchFacility.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        facilitySearch = facilities;
      } else {
        facilitySearch = facilities.where(
          (dest) => dest.name.toLowerCase().contains(query)
        ).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    facilitySearch = facilities;
    searchFacility.addListener(_searchFunction);
  }

  void deleteFacility(int id) {
    showPopUpDelete(
      context: context, 
      text: "Facility", 
      onDelete: () {
        setState(() {
          facilities.removeWhere((item) => item.id_facility == id);

          searchFacility.clear();
        });
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
                
                HeaderCostum(controller: searchFacility),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Manage Facilities",
                        style: TextStyle(fontSize: 20),
                      ),

                      ButtonCostum(
                        text: "Add Facility", 
                        onPressed: () {
                          setState(() {
                            openAddFasility = true;
                          });
                        },
                      )
                    ],
                  ),
                ),

                if(openAddFasility)
                  AddFacility(
                    existingFacility: editingFacility,
                    onClose: () {
                      setState(() {
                        openAddFasility = false;
                        editingFacility = null;
                      });
                    },
                    onSave: (updatedFacility) {
                      setState(() {
                        if (editingFacility == null) {
                          facilities.add(updatedFacility);
                        } else {
                          final index = facilities.indexWhere(
                              (f) => f.id_facility == updatedFacility.id_facility);
                          facilities[index] = updatedFacility;
                        }
                      });
                    },
                  ),

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

                      ...facilitySearch.asMap().entries.map((entry) {
                        final index = entry.key;
                        final fac = entry.value;

                        final bool isEven = index % 2 == 0;

                        return Container(
                          color: isEven ? Colors.white : const Color.fromARGB(255, 237, 246, 255), // warna berbeda
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                TableContent(
                                  isIcon: true, 
                                  title: fac.icon,
                                ),
                                TableContent(title: fac.name, flex: 2,),

                                Expanded(
                                  flex: 5,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Actionbutton(
                                        label: "Edit",
                                        onTap: () {
                                          setState(() {
                                            openAddFasility = true;
                                            editingFacility =  fac;
                                          });
                                        },
                                      ),
                                      Actionbutton(
                                        isDelete: true,
                                        label: "Delete", 
                                        onTap: () => deleteFacility(fac.id_facility), 
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