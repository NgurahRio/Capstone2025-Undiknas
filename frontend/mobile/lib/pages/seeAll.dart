import 'package:flutter/material.dart';
import 'package:mobile/componen/cardItems.dart';
import 'package:mobile/componen/dropDownFilter.dart';
import 'package:mobile/componen/headerCustom.dart';
import 'package:mobile/models/destination_model.dart';
import 'package:mobile/models/rating_model.dart';
import 'package:mobile/pages/detail.dart';

class SeeAllPage extends StatefulWidget {
  final List<dynamic> selectedCategories;
  final List<dynamic> selectedSubCategories;
  final List<dynamic> appliedSubCategories;
  final void Function(List<dynamic> cats, List<dynamic> subs, List<dynamic> applied) onSaveStyle;

  SeeAllPage({
    super.key,
    required this.selectedCategories,
    required this.selectedSubCategories,
    required this.appliedSubCategories,
    required this.onSaveStyle
  });

  @override
  State<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {

  final LayerLink _editLink = LayerLink();
  final GlobalKey _editKey = GlobalKey();
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

  void _showDropdown() {
    final overlay = Overlay.of(context);
    final RenderBox renderBox = _editKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width + 275,
        child: CompositedTransformFollower(
          link: _editLink,
          showWhenUnlinked: false,
          offset: Offset(-275, 34),
          child: StyleDropdown(
            selectedCategory: widget.selectedCategories,
            selectedSubCategories: widget.selectedSubCategories,
            onSave: (cats, subs) {
              setState(() {
                widget.selectedCategories
                  ..clear()
                  ..addAll(cats);
                widget.selectedSubCategories
                  ..clear()
                  ..addAll(subs);
                widget.appliedSubCategories
                  ..clear()
                  ..addAll(subs);
              });

              widget.onSaveStyle(
                widget.selectedCategories,
                widget.selectedSubCategories,
                widget.appliedSubCategories,
              );

              _removeDropdown();
            },
            onClear: () {
              setState(() {
                widget.selectedCategories.clear();
                widget.selectedSubCategories.clear();
                widget.appliedSubCategories.clear();
              });

              widget.onSaveStyle(
                widget.selectedCategories,
                widget.selectedSubCategories,
                widget.appliedSubCategories,
              );

              _removeDropdown();

            },
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
    setState(() => _isDropdownVisible = true);
  }

  @override
  Widget build(BuildContext context) {

    final filteredDestinations = destinations.where(
      (dest) => widget.appliedSubCategories.contains(dest.subCategoryId.id_subCategory),
    ).toList();

    return Scaffold(
      backgroundColor: Color(0xfff3f9ff),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(85), 
        child: Header(onTap: () {})
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2)
                      ),
                      child: Icon(Icons.arrow_back_rounded, size: 20,)
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "Recomended Your Style", 
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        )
                      ),
                    ),
                  ),

                  CompositedTransformTarget(
                    link: _editLink,
                    key: _editKey,
                    child: GestureDetector(
                      onTap: _toggleDropdown,
                      child: Container(
                        alignment: Alignment.center,
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xff8ac4fa),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Edit Style",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 17, right: 17, bottom: 5),
              child: FilterApply(
                key: ValueKey(widget.appliedSubCategories.length),
                selectedCategory: widget.selectedCategories,
                selectedSubCategories: widget.selectedSubCategories,
                appliedSubCategories: widget.appliedSubCategories,
                onFilterChanged: ({
                  required selectedCategory,
                  required selectedSubCategories,
                  required appliedSubCategories,
                }) {
                  setState(() {
                    widget.selectedCategories
                      ..clear()
                      ..addAll(selectedCategory);
                    widget.selectedSubCategories
                      ..clear()
                      ..addAll(selectedSubCategories);
                    widget.appliedSubCategories
                      ..clear()
                      ..addAll(appliedSubCategories);
                  });
              
                  widget.onSaveStyle(
                    widget.selectedCategories,
                    widget.selectedSubCategories,
                    widget.appliedSubCategories,
                  );
                },
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.6835 
                  ), 
                  itemCount: filteredDestinations.length,
                  itemBuilder: (context, index) {
                    final item = filteredDestinations[index];
                    final ratDest = averageRatingForDestination(item.id_destination);
                    return CardItems2(
                      image: item.imageUrl[0], 
                      title: item.name, 
                      subTitle: item.description,
                      rating: ratDest,
                      category: item.subCategoryId.categoryId.name,
                      isDestination: true,
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => DetailPage(
                            destination: item, 
                            event: null,
                          )),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}