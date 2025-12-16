import 'package:admin_website/components/ButtonCostum.dart';
import 'package:admin_website/components/CardCostum.dart';
import 'package:admin_website/components/DeletePopup.dart';
import 'package:admin_website/components/Destination/AddDestination.dart';
import 'package:admin_website/components/Destination/DetailDestination.dart';
import 'package:admin_website/components/HeaderCostum.dart';
import 'package:admin_website/components/Table/ActionButton.dart';
import 'package:admin_website/components/Table/TabelContent.dart';
import 'package:admin_website/components/Table/TableHeader.dart';
import 'package:admin_website/models/destination_model.dart';
import 'package:flutter/material.dart';

class DestinationPage extends StatefulWidget {
  const DestinationPage({super.key});

  @override
  State<DestinationPage> createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  TextEditingController searchDestination = TextEditingController();

  bool openAddDestination = false;

  Destination? editingDestination;
  List<Destination> destinationSearch = [];
  List<Destination> destinations = [];
  bool isLoading = true;

  Future<void> loadDestinations() async {
    try {
      final data = await getDestinations();
      setState(() {
        destinations = data;
        destinationSearch = data;
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
      debugPrint(e.toString());
    }
  }

  void _searchFunction() {
    String query = searchDestination.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        destinationSearch = destinations;
      } else {
        destinationSearch = destinations.where((dest) {
          final matchDestination = dest.name.toLowerCase().contains(query);
          final matchCategory = dest.subCategoryId.any((cat) => cat.categoryId.name.toLowerCase().contains(query));
          final matchSubCategory = dest.subCategoryId.any((subc) => subc.name.toLowerCase().contains(query));
          final matchLocation = dest.location.toLowerCase().contains(query);

          return matchDestination || matchCategory || matchSubCategory || matchLocation;
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadDestinations();
    searchDestination.addListener(_searchFunction);
  }

  void removeDestination(int id) {
    showPopUpDelete(
      context: context, 
      text: "Destination", 
      onDelete: ()  async{
        try {
          await deleteDestination(id);
          setState(() {
            destinations.removeWhere((item) => item.id_destination == id);
            searchDestination.clear();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Destination deleted successfully')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting destination: $e')),
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

                HeaderCostum(controller: searchDestination),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Manage Destinations",
                        style: TextStyle(fontSize: 20),
                      ),

                      ButtonCostum(
                        text: "Add Destination", 
                        onPressed: () {
                          setState(() {
                            openAddDestination = true;
                          });
                        }
                      )
                    ],
                  ),
                ),

                if(openAddDestination)
                  AddDestination(
                    existingDestination: editingDestination,
                    onClose: () {
                      setState(() {
                        openAddDestination = false;
                        editingDestination = null;
                      });
                    },
                    onSave: (updatedDestination) {
                      setState(() {
                        if (editingDestination == null) {
                          destinations.add(updatedDestination);
                        } else {
                          final index = destinations.indexWhere(
                            (f) => f.id_destination == updatedDestination.id_destination
                          );
                          destinations[index] = updatedDestination;
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
                            TableHeader(title: "Category"),
                            TableHeader(title: "Sub Category"),
                            TableHeader(title: "Location",  flex: 3,),
                            TableHeader(title: "Actions", flex: 2,),             
                          ],
                        ),
                      ),

                      const Divider(height: 1,),

                      ...destinationSearch.asMap().entries.map((entry) {
                        final index = entry.key;
                        final dest = entry.value;

                        final bool isEven = index % 2 == 0;

                        return Container(
                          color: isEven ? Colors.white : const Color(0xFFEDF6FF),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                TableContent(title: dest.name),
                                TableContent(
                                  title: dest.subCategoryId.map((cat) => cat.categoryId.name).toSet().join(", ")
                                ),
                                TableContent(
                                  title: dest.subCategoryId.map((subc) => subc.name).join(", ")
                                ),
                                TableContent(title: dest.location, flex: 3,),
                            
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Actionbutton(
                                        label: "View Detail", 
                                        onTap: () => showDetailDestination(context, dest.id_destination),
                                      ),
                                      Actionbutton(
                                        label: "Edit", 
                                        onTap: () {
                                          setState(() {
                                            openAddDestination = true;
                                            editingDestination = dest;
                                          });
                                        }
                                      ),
                                      Actionbutton(
                                        isDelete: true,
                                        label: "Delete", 
                                        onTap: () => removeDestination(dest.id_destination), 
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