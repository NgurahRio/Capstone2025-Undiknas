import 'package:admin_website/components/ButtonCostum.dart';
import 'package:admin_website/components/CardCostum.dart';
import 'package:admin_website/components/HeaderCostum.dart';
import 'package:admin_website/components/TextFieldCostum.dart';
import 'package:admin_website/models/category_model.dart';
import 'package:admin_website/models/subCategory_model.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  TextEditingController searchCategory = TextEditingController();
  TextEditingController category = TextEditingController();
  Map<int, TextEditingController> subControllers = {};

  List<Category> categories = [];
  List<SubCategory> subCategories = [];
  List<Category> categorySearch = [];
  bool isLoading = true;

  Future<void> loadData() async {
    try {
      final cats = await getCategories();
      final subs = await getSubCategories(cats);

      for (var cat in cats) {
        subControllers[cat.id_category] ??= TextEditingController();
      }

      setState(() {
        categories = cats;
        categorySearch = cats;
        subCategories = subs;
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
      debugPrint(e.toString());
    }
  }

  void _searchFunction() {
    String query = searchCategory.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        categorySearch = categories;
      } else {
        categorySearch = categories.where(
          (cat) =>  cat.name.toLowerCase().contains(query)
        ).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
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
                icon: const Icon(Icons.close, color: Colors.red),
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

  Future<void> addCategory() async {
    String name = category.text.trim();
    if (name.isEmpty) return;

    final success = await createCategory(name);

    if (success) {
      await loadData();
      category.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category berhasil ditambahkan')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambahkan category')),
      );
    }
  }

  Future<void> addSubCategory(Category cat) async {
    final controller = subControllers[cat.id_category];
    if (controller == null) return;

    final name = controller.text.trim();
    if (name.isEmpty) return;

    final newSub = await createSubCategory(
      name: name,
      categoryId: cat.id_category,
      categories: categories,
    );

    if (newSub != null) {
      await loadData();
      controller.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subcategory berhasil ditambahkan')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambahkan subcategory')),
      );
    }
  }

  void removeCategory (int categoryId) async {
    try {
      await deleteCategory(categoryId);
      setState(() {
        categories.removeWhere((c) => c.id_category == categoryId);
        subCategories.removeWhere((sub) => sub.categoryId == categoryId);
        final ctl = subControllers.remove(categoryId);
        ctl?.dispose();
        searchCategory.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus category: ${e.toString()}')),
      );
    }
  }

  void removeSubCategory (int subCategoryId) async{
    try {
      await deleteSubCategory(subCategoryId);
      setState(() {
        subCategories.removeWhere((s) => s.id_subCategory == subCategoryId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subcategory berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus subcategory: ${e.toString()}')),
      );
      return;
    }
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

                if (isLoading)
                  Center(
                    child: const CircularProgressIndicator()
                  )
                else 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35),
                    child: CardCostum(
                      content: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        child: Wrap(
                          spacing: 5,
                          children: [
                    
                            ...categories.map((cat) {
                              return valueBox(
                                title: cat.name, 
                                onTap: () => removeCategory(cat.id_category),
                              );
                            })
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
                              style: const TextStyle(fontSize: 20),
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
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            child: Wrap(
                              spacing: 5,
                              children: [
                        
                                ...subCategories.where((sub) => sub.categoryId.id_category == cat.id_category).map((subs) {
                                  return valueBox(
                                    title: subs.name, 
                                    onTap: () => removeSubCategory(subs.id_subCategory),
                                  );
                                })
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