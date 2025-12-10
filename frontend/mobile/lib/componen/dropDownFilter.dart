import 'package:flutter/material.dart';
import 'package:mobile/componen/buttonCostum.dart';
import 'package:mobile/models/category_model.dart';
import 'package:mobile/models/subCategory_model.dart';

class StyleDropdown extends StatefulWidget {
  final List<dynamic> selectedCategory;
  final List<dynamic> selectedSubCategories;
  final Function(List<dynamic>, List<dynamic>) onSave;
  final VoidCallback onClear;

  const StyleDropdown({
    super.key,
    required this.selectedCategory,
    required this.selectedSubCategories,
    required this.onSave,
    required this.onClear,
  });

  @override
  State<StyleDropdown> createState() => _StyleDropdownState();
}

class _StyleDropdownState extends State<StyleDropdown> {
  late List<dynamic> selectedCategory;
  late List<dynamic> selectedSubCategories;

  @override
  void initState() {
    super.initState();
    selectedCategory = List.from(widget.selectedCategory);
    selectedSubCategories = List.from(widget.selectedSubCategories);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 4,
      borderRadius: BorderRadius.circular(10),
      child: IntrinsicWidth(
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Pick your travel style!", style: TextStyle(fontSize: 22)),
                const Text("Select Fields"),
          
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Wrap(
                    children: categories.map((cat) {
                      final bool isSelected = selectedCategory.contains(cat.id_category);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedCategory.remove(cat.id_category);
                            } else {
                              selectedCategory.add(cat.id_category);
                            }
                          });
                        },
                        child: Card(
                          color: isSelected ? const Color(0xFF8AC4FA) : Colors.white,
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            child: Text(
                              cat.name,
                              style: TextStyle(color: isSelected ? Colors.white : Colors.black),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
          
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFe67167),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: GestureDetector(
                      onTap: widget.onClear,
                      child: const Text('Clear', style: TextStyle(color: Colors.white, fontSize: 15)),
                    ),
                  ),
                ),
          
                if (selectedCategory.isNotEmpty)
                  Center(
                    child: Column(
                      children: selectedCategory.map((catId) {
                        final cat = categories.firstWhere((c) => c.id_category == catId);
                        final subs = subCategories.where((sub) => sub.categoryId.id_category == catId).toList();
                    
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Column(
                            children: [
                              Text(
                                "Explore ${cat.name} style",
                                style: const TextStyle(
                                    color: Color(0xff8ac4fa),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                              Wrap(
                                children: subs.map((sub) {
                                  final isSubSelected = selectedSubCategories.contains(sub.id_subCategory);
                                  return SizedBox(
                                    width: 110,
                                    child: Card(
                                      color: isSubSelected ? const Color(0xFF8AC4FA) : Colors.white,
                                      elevation: 3,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Transform.scale(
                                            scale: 0.7,
                                            child: Checkbox(
                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              visualDensity: VisualDensity.compact,
                                              fillColor: const WidgetStatePropertyAll(Colors.white),
                                              side: const BorderSide(color: Color(0xFF547899), width: 2),
                                              activeColor: Colors.white,
                                              checkColor: const Color(0xFF8AC4FA),
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
                                          ),
                                          Text(
                                            sub.name,
                                            style: TextStyle(
                                                color: isSubSelected ? Colors.white : Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ButtonCostum(
                    text: "Save & Explore",
                    onPressed: () {
                      widget.onSave(selectedCategory, selectedSubCategories);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class FilterApply extends StatefulWidget {
  final List<dynamic> selectedCategory;
  final List<dynamic> selectedSubCategories;
  final List<dynamic> appliedSubCategories;

  final void Function({
    required List<dynamic> selectedCategory,
    required List<dynamic> selectedSubCategories,
    required List<dynamic> appliedSubCategories,
  }) onFilterChanged;

  const FilterApply({
    super.key,
    required this.selectedCategory,
    required this.selectedSubCategories,
    required this.appliedSubCategories,
    required this.onFilterChanged,
  });

  @override
  State<FilterApply> createState() => _FilterApplyState();
}

class _FilterApplyState extends State<FilterApply> {
  late List<dynamic> selectedCategory;
  late List<dynamic> selectedSubCategories;
  late List<dynamic> appliedSubCategories;

  @override
  void initState() {
    super.initState();
    selectedCategory = List.from(widget.selectedCategory);
    selectedSubCategories = List.from(widget.selectedSubCategories);
    appliedSubCategories = List.from(widget.appliedSubCategories);
  }

  void _updateParent() {
    widget.onFilterChanged(
      selectedCategory: selectedCategory,
      selectedSubCategories: selectedSubCategories,
      appliedSubCategories: appliedSubCategories,
    );
  }

  Widget _buildChip({
    required String label,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xff8ac4fa)),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Text(
              label,
              style: const TextStyle(color: Color(0xff8ac4fa)),
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              color: Color(0xff8ac4fa),
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...categories.where((cat) {
          return subCategories.any(
            (sub) =>
                sub.categoryId.id_category == cat.id_category &&
                appliedSubCategories.contains(sub.id_subCategory),
          );
        }).map((cat) {
          return _buildChip(
            label: cat.name,
            onRemove: () {
              setState(() {
                appliedSubCategories.removeWhere((subId) {
                  final sub = subCategories.firstWhere(
                    (s) => s.id_subCategory == subId,
                  );
                  return sub.categoryId.id_category == cat.id_category;
                });

                selectedSubCategories.removeWhere((subId) {
                  final sub = subCategories.firstWhere(
                    (s) => s.id_subCategory == subId,
                  );
                  return sub.categoryId.id_category == cat.id_category;
                });

                selectedCategory.remove(cat.id_category);

                _updateParent();
              });
            },
          );
        }),

        ...appliedSubCategories.map((subId) {
          final sub = subCategories.firstWhere(
            (s) => s.id_subCategory == subId,
          );
          return _buildChip(
            label: sub.name,
            onRemove: () {
              setState(() {
                appliedSubCategories.remove(subId);
                selectedSubCategories.remove(subId);

                _updateParent();
              });
            },
          );
        }),
      ],
    );
  }
}

