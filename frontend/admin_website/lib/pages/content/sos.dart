import 'package:admin_website/components/ButtonCostum.dart';
import 'package:admin_website/components/CardCostum.dart';
import 'package:admin_website/components/DeletePopup.dart';
import 'package:admin_website/components/HeaderCostum.dart';
import 'package:admin_website/components/SOS/AddSos.dart';
import 'package:admin_website/components/Table/ActionButton.dart';
import 'package:admin_website/components/Table/TabelContent.dart';
import 'package:admin_website/components/Table/TableHeader.dart';
import 'package:admin_website/models/sos_model.dart';
import 'package:flutter/material.dart';

class SosPage extends StatefulWidget {
  const SosPage({super.key});

  @override
  State<SosPage> createState() => _SosPageState();
}

class _SosPageState extends State<SosPage> {
  TextEditingController searchSOS = TextEditingController();

  bool openAddSos = false;

  SOS? selectedSOS;
  List<SOS> sosSearch = [];

  void _searchFunction() {
    String query = searchSOS.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        sosSearch = sos;
      } else {
        sosSearch = sos.where(
          (sos) => sos.name.toLowerCase().contains(query)
        ).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    sosSearch = sos;
    searchSOS.addListener(_searchFunction);
  }

  void deleteSOS(int id) {
    showPopUpDelete(
      context: context, 
      text: "SOS", 
      onDelete: () {
        setState(() {
          sos.removeWhere((item) => item.id_sos == id);

          searchSOS.clear();
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
                
                HeaderCostum(controller: searchSOS),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Manage SOS (Save Our Souls)",
                        style: TextStyle(fontSize: 20),
                      ),

                      ButtonCostum(
                        text: "Add SOS", 
                        onPressed: () {
                          setState(() {
                            selectedSOS = null;
                            openAddSos = true;
                          });
                        },
                      )
                    ],
                  ),
                ),

                if(openAddSos)
                  AddSos(
                    existingSos: selectedSOS,
                    onClose: () {
                      setState(() {
                        openAddSos = false;
                      });
                    },
                    onSave: (updatedSos) {
                      setState(() {
                        if (selectedSOS != null) {
                          int index = sos.indexWhere((item) => item.id_sos == updatedSos.id_sos);
                          sos[index] = updatedSos;
                        } else {
                          sos.add(updatedSos);
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
                            TableHeader(title: "Name"),
                            TableHeader(title: "Location", flex: 2,),
                            TableHeader(title: "Number"),
                            TableHeader(title: "Actions"),             
                          ],
                        ),
                      ),

                      const Divider(height: 1,),

                      ...sosSearch.asMap().entries.map((entry) {
                        final index = entry.key;
                        final sos = entry.value;

                        final bool isEven = index % 2 == 0;

                        return Container(
                          color: isEven ? Colors.white : const Color.fromARGB(255, 237, 246, 255), // warna berbeda
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                TableContent(title: sos.name),
                                TableContent(title: sos.address, flex: 2,),
                                TableContent(title: sos.phone),

                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Actionbutton(
                                        label: "Edit",
                                        onTap: () {
                                          setState(() {
                                            selectedSOS = sos;
                                            openAddSos = true;
                                          });
                                        }
                                      ),
                                      Actionbutton(
                                        isDelete: true,
                                        label: "Delete", 
                                        onTap: () => deleteSOS(sos.id_sos), 
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