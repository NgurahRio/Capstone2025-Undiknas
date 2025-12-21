import 'package:flutter/material.dart';
import 'package:mobile/componen/FormateDate.dart';
import 'package:mobile/componen/buttonCostum.dart';
import 'package:mobile/componen/cardItems.dart';
import 'package:mobile/componen/headerCustom.dart';
import 'package:mobile/models/bookmark_model.dart';
import 'package:mobile/models/user_model.dart';
import 'package:mobile/pages/Auth/loginPage.dart';
import 'package:mobile/pages/detail.dart';

class BookmarkPage extends StatefulWidget {
  final User? currentUser; 

  const BookmarkPage({super.key, required this.currentUser});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final List<String> type = ["ALL", "Destination", "Event"];

  List<int> selected = [];
  bool _isSelect = false;
  String selectedType = "ALL";

  void _deleteAllFavorites() {
    setState(() {
      bookmarks.clear();
      selected.clear();
    });
  }

  void _deleteSelecteds() {
    setState(() {
      bookmarks.removeWhere((item) => selected.contains(item.id_bookmark));
      selected.clear();
    });
  }

  void _showDialogDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xE7FFFFFF),
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          content: SizedBox(
            width: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    textAlign: TextAlign.center,
                    _isSelect == false
                      ? "Are you sure want to delete all these items?"
                      : "Delete this item?",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Center(
                  child: Container(
                    width: 170,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF547899),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 15, 
                          fontWeight: FontWeight.w500
                        )
                      ),
                    ),
                  ),
                ),
                            
                Center(
                  child: Container(
                    width: 170,
                    margin: const EdgeInsets.only(top: 7),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xffff8484),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (_isSelect) {
                          _deleteSelecteds();
                        } else {
                          _deleteAllFavorites();
                        }
                  
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Delete", 
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 15, 
                          fontWeight: FontWeight.w500
                        )
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final LayerLink _dropdownLink = LayerLink();
  OverlayEntry? _overlayEntry;

  bool _isDropdownVisible = false;

  void _toggleDropdown() {
    if (_isDropdownVisible) {
      _removeDropdown();
    } else {
      _showDropdown();
    }
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isDropdownVisible = false);
  }

  void _showDropdown () {
    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 130,
        child: CompositedTransformFollower(
          link: _dropdownLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 34),
          child: Material(
            color: Colors.white,
            elevation: 4,
            borderRadius: BorderRadius.circular(5),
            child:Column(
              mainAxisSize: MainAxisSize.min,
              children: type.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedType = item;
                          });
                          _removeDropdown();
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  
                      const Divider(height: 0, thickness: 1,)
                    ],
                  ),
                );
              }).toList(),
            ),
          )
        )
      )
    );
    overlay.insert(_overlayEntry!);
    setState(() => _isDropdownVisible = true);
  }

  @override
  Widget build(BuildContext context) {
    List<Bookmark> filteredItems = bookmarks.where((item) {
      if (item.userId.id_user != widget.currentUser?.id_user) return false;

      if (selectedType == "ALL") return true;
      if (selectedType == "Event" && item.eventId != null) return true;
      if (selectedType == "Destination" && item.destinationId != null) return true;
      return false;
    }).toList();
    
    return Scaffold(
      backgroundColor: const Color(0xfff3f9ff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85), 
        child: Header(title: "Bookmark")
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              children: [
                
                widget.currentUser == null 
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Text(
                              "You are not logged in.",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ButtonCostum(
                            text: "Login / Sign Up",
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: _isSelect == false ? const Color(0xFF8ac4fa) : Colors.black45,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isSelect = !_isSelect;
                                      });
                                    },
                                    child:  Text(
                                      _isSelect == false ? 'Choose' : "Cancel",
                                      style: const TextStyle(
                                        color: Colors.white, 
                                        fontSize: 13, 
                                        fontWeight: FontWeight.w500
                                      )
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffff8484),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: GestureDetector(
                                    onTap: _showDialogDelete,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: Text(
                                            _isSelect == false ? 'Delete All' : "Delete", 
                                            style: const TextStyle(
                                              color: Colors.white, 
                                              fontSize: 13, 
                                              fontWeight: FontWeight.w500
                                            )
                                          ),
                                        ),
                                        const Icon(Icons.delete, color: Colors.white, size: 16,)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                  
                            CompositedTransformTarget(
                              link: _dropdownLink,
                              child: GestureDetector(
                                onTap: _toggleDropdown,
                                child: Container(
                                  height: 30,
                                  width: 130,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF8ac4fa),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        selectedType,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(Icons.arrow_drop_down, color: Colors.white),
                                    ],
                                  ),
                                )
                              ),
                            ),
                  
                          ],
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.71,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(14, 150, 203, 252),
                                blurRadius: 4,
                                offset: Offset(0, -10),
                              ),
                            ]
                          ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              child:Row(
                                children: [
                                  const Text("| ", style: TextStyle(color: Color(0xFF6189af), fontSize: 21)),
                                  
                                  Text(
                                    selectedType == "ALL" ? "All Bookmark" : "Bookmark $selectedType", 
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    )
                                  ),
                                ],
                              ),
                            ),

                            filteredItems.isEmpty
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 50),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      "Destinations and events\nhave not beenbookmarked yet",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredItems.length,
                                itemBuilder:(context, index) {
                                  final bookM = filteredItems[index];
                                  final isEvent = bookM.eventId != null;
                          
                                  final title = isEvent ? bookM.eventId!.name : bookM.destinationId!.name;
                                  final subtitle = isEvent ? formatEventDate(bookM.eventId!.startDate, bookM.eventId!.endDate) : bookM.destinationId!.location;
                                  final image = isEvent ? bookM.eventId!.imageUrl[0] : bookM.destinationId!.imageUrl[0];
                                  final List<String>? category = isEvent ? null : bookM.destinationId!.subCategoryId.map((sub) => sub.categoryId.name).toSet().toList();
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        if(_isSelect == true)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 7),
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                border: Border.all(color: const Color(0xFF547899)),
                                                borderRadius: BorderRadius.circular(3)
                                              ),
                                              child: Checkbox(
                                                fillColor: const WidgetStatePropertyAll(Colors.white),
                                                side: const BorderSide(color: Colors.white),
                                                activeColor: const Color(0xFF547899),
                                                checkColor: const Color(0xFF547899),
                                                value: selected.contains(bookM.id_bookmark),
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    if (value == true) {
                                                      selected.add(bookM.id_bookmark);
                                                    } else {
                                                      selected.remove(bookM.id_bookmark);
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        Expanded(
                                          child: CardItems1(
                                            rating: 4.9,
                                            title: title,
                                            image: image,
                                            subtitle: subtitle,
                                            categories: isEvent ? null : category,
                                            isBookmark: true,
                                            onTap: () {
                                              Navigator.push(
                                                context, 
                                                MaterialPageRoute(builder: (context) => DetailPage(
                                                  destination: isEvent ? null : bookM.destinationId, 
                                                  event: isEvent ? bookM.eventId : null,
                                                  currentUser: widget.currentUser!,
                                                )),
                                              );

                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                              }
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        )
      ),
    );
  }
}