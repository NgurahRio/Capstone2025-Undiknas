import 'package:admin_website/components/ButtonCostum.dart';
import 'package:admin_website/components/CardCostum.dart';
import 'package:admin_website/components/HeaderCostum.dart';
import 'package:admin_website/components/TextFieldCostum.dart';
import 'package:admin_website/models/category_model.dart';
import 'package:admin_website/models/subCategory_model.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  TextEditingController searchCategory = TextEditingController();
  TextEditingController category = TextEditingController();
  Map<int, TextEditingController> subControllers = {};

  List<Category> categorySearch = [];

  void _searchFunction() {
    String query = searchCategory.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        categorySearch = categories;
      } else {
        categorySearch = categories.where(
          (dest) =>  dest.name.toLowerCase().contains(query)
        ).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    for (var cat in categories) {
      subControllers[cat.id_category] = TextEditingController();
    }

    categorySearch = categories;
    searchCategory.addListener(_searchFunction);
  }

  Widget valueBox ({
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 120,
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0xFF8AC4FA),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Wrap(
          spacing: 3,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),

            SizedBox(
              width: 20,
              height: 20,
              child: IconButton(
                iconSize: 15,
                padding: EdgeInsets.zero,
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: onTap, 
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    category.dispose();
    searchCategory.dispose();
    for (var c in subControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void addCategory() {
    String name = category.text.trim();
    if (name.isEmpty) return;

    setState(() {
      final maxId = categories.isEmpty ? 0 : categories.map((c) => c.id_category).reduce(max);
      final newId = maxId + 1;

      final newCat = Category(id_category: newId, name: name);
      categories.add(newCat);

      subControllers[newId] = TextEditingController();
    });

    category.clear();
  }

  void addSubCategory(Category cat) {
    final controller = subControllers[cat.id_category];
    if (controller == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Internal error: controller tidak ditemukan')),
      );
      return;
    }

    String name = controller.text.trim();
    if (name.isEmpty) return;

    setState(() {
      final maxId = subCategories.isEmpty ? 0 : subCategories.map((s) => s.id_subCategory).reduce(max);
      final newId = maxId + 1;

      subCategories.add(SubCategory(
        id_subCategory: newId,
        name: name,
        categoryId: cat,
      ));
    });

    controller.clear();
  }

  void deleteCategory(int categoryId) {
    setState(() {
      categories.removeWhere((c) => c.id_category == categoryId);

      subCategories.removeWhere((sub) => sub.categoryId == categoryId);

      final ctl = subControllers.remove(categoryId);
      ctl?.dispose();

      searchCategory.clear();
    });
  }

  void deleteSubCategory(int subCategoryId) {
    setState(() {
      subCategories.removeWhere((s) => s.id_subCategory == subCategoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [

                HeaderCostum(controller: searchCategory),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Manage Categories",
                        style: TextStyle(fontSize: 20),
                      ),

                      Wrap(
                        spacing: 10,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [

                          TextFieldCostum(
                            width: 230,
                            controller: category, 
                            text: "New categori",
                          ),

                          ButtonCostum(
                            text: "Add Category", 
                            onPressed: addCategory,
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 35),
                  child: CardCostum(
                    content: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: Wrap(
                        spacing: 5,
                        children: [
                  
                          ...categories.map((cat) {
                            return valueBox(
                              title: cat.name, 
                              onTap: () => deleteCategory(cat.id_category),
                            );
                          }).toList()
                        ],
                      ),
                    )
                  ),
                ),

                ...categorySearch.map((cat) {
                  return Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Sub tags ${cat.name}",
                              style: TextStyle(fontSize: 20),
                            ),

                            Wrap(
                              spacing: 10,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [

                                TextFieldCostum(
                                  width: 230,
                                  controller: subControllers[cat.id_category]!, 
                                  text: "New Subs Adventure"
                                ),

                                ButtonCostum(
                                  text: "Add", 
                                  onPressed: () => addSubCategory(cat),
                                  width: 80,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: CardCostum(
                          content: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            child: Wrap(
                              spacing: 5,
                              children: [
                        
                                ...subCategories.where((sub) => sub.categoryId.id_category == cat.id_category).map((subs) {
                                  return valueBox(
                                    title: subs.name, 
                                    onTap: () => deleteSubCategory(subs.id_subCategory),
                                  );
                                }).toList()
                              ],
                            ),
                          )
                        ),
                      ),
                    ],
                  );
                })

              ],
            ),
          ),
        )
      ),
    );
  }
}