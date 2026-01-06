import 'package:flutter/material.dart';
import 'package:mobile/componen/formatDate.dart';
import 'package:mobile/componen/cardItems.dart';
import 'package:mobile/componen/dropDownFilter.dart';
import 'package:mobile/componen/headerCustom.dart';
import 'package:mobile/models/category_model.dart';
import 'package:mobile/models/destination_model.dart';
import 'package:mobile/models/event_model.dart';
import 'package:mobile/models/review_model.dart';
import 'package:mobile/models/subCategory_model.dart';
import 'package:mobile/pages/detail.dart';
import 'package:mobile/pages/seeAll.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  final TextEditingController _searchController = TextEditingController();

  List<dynamic> selectedCategory = [];
  List<dynamic> selectedSubCategories = [];
  List<dynamic> appliedSubCategories = [];
  List<Destination> searchedDestinations = [];
  List<Destination> destinations = [];
  List<Event> events = [];
  List<Category> categories = [];
  List<SubCategory> subCategories = [];
  List<Review> reviews = [];
  bool _isSearchActive = false;
  bool selectStyle = true;

  Future<void> loadData() async {
    try {
      final dest = await getDestinations();
      final evt = await getEvents();
      final cat = await getCategories();
      final subCat = await getSubCategories(cat);
      final rev = await getReviews();
      if (!mounted) return;
      setState(() {
        destinations = dest;
        events = evt;
        categories = cat;
        subCategories = subCat;
        reviews = rev;
      });
    } catch (e) {
      debugPrint("LOAD ERROR: $e");
    }
  }

  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        searchedDestinations = [];
      } else {
        searchedDestinations = destinations
            .where((d) => d.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 0 && hour < 10) {
      return "Morning!";
    } else if (hour >= 10 && hour < 15) {
      return "Afternoon!";
    } else if (hour >= 15 && hour < 18) {
      return "Evening!";
    } else {
      return "Night!";
    }
  }

  List<String> imageDiscount = [
    "assets/discount.png",
    "assets/discount.png",
  ];

  void _clearFilterStyle() {
    setState(() {
      selectedCategory = [];
      selectedSubCategories = [];
      appliedSubCategories = [];
      selectStyle = true;

      _overlayEntry?.remove();
      _showDropdown();
    });
  }

  final LayerLink _layerLink = LayerLink();
  final GlobalKey _dropdownKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isDropdownVisible = false;

  void _toggleDropdown() {
    if (_isDropdownVisible) {
      _removeDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    final overlay = Overlay.of(context);
    final RenderBox renderBox = _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 46),  
          child: StyleDropdown(
            selectedCategory: selectedCategory,
            selectedSubCategories: selectedSubCategories,
            onSave: (cats, subs) {
              FocusScope.of(context).unfocus();
              setState(() {
                selectedCategory = cats;
                selectedSubCategories = subs;
                appliedSubCategories = List.from(subs);
              });
              _removeDropdown();
            },
            onClear: _clearFilterStyle,
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
    setState(() => _isDropdownVisible = true);
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isDropdownVisible = false);
  }

  @override
  void initState() {
    super.initState();
    loadData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Widget _subHeader ({required String title, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 30, top: 15, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Row(
            children: [
              const Text("| ", style: TextStyle(color: Color(0xFF6189af), fontSize: 17)),
              
              Text(
                title, 
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                )
              ),
            ],
          ),

          if(onTap != null)
            InkWell(
              onTap: onTap,
              child: const Text(
                "See All",
                style: TextStyle(color: Color(0xFF8AC4FA), fontSize: 14),
              ),
            )
        ],
      ),
    );
  }

  Widget _bodySubHeader({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: Row(
          children: List.generate(
            itemCount,
            (index) => itemBuilder(context, index),
          ),
        ),
      ),
    );
  }

  final FocusNode _searchFocusNode = FocusNode();

  void _navigateTo(Widget page) async {
    FocusScope.of(context).unfocus();
    if (_isDropdownVisible) _removeDropdown();

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );

    if (!mounted) return;
    await loadData();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final filteredDestinations = destinations.where((dest) {
      return dest.subCategoryId.any(
        (sub) => appliedSubCategories.contains(sub.id_subCategory),
      );
    }).take(4).toList();
    
    final String selectedStyle = appliedSubCategories.isNotEmpty
      ? (() {
          final selectedCats = categories.where(
            (cat) => subCategories.any(
              (sub) => 
                sub.categoryId.id_category == cat.id_category && appliedSubCategories.contains(sub.id_subCategory),
            )
          ).map((cat) => cat.name).toSet().toList();

          
          final selectedSubs = appliedSubCategories.map(
            (subId) {
              final sub = subCategories.firstWhere(
                (s) => s.id_subCategory == subId,
              );
              return sub.name;
            }).toSet().toList();

          return [...selectedCats, ...selectedSubs].join(', ');
        })()
      : '';


    final ratings = {
      for (var dest in destinations)
        dest.id_destination: averageRatingForDestination(dest.id_destination, reviews),
    };

    final topRatedDestinations = destinations.where((d) => ratings[d.id_destination]! >= 4).toList();

    final today = DateTime.now();

    final todayEvents = events.where((event) {
      try {
        final start = DateTime.parse(event.startDate);
        final end = event.endDate != null
            ? DateTime.parse(event.endDate!)
            : start;

        final todayOnly = DateTime(today.year, today.month, today.day);

        return !todayOnly.isBefore(
                  DateTime(start.year, start.month, start.day)) &&
              !todayOnly.isAfter(
                  DateTime(end.year, end.month, end.day));
      } catch (_) {
        return false;
      }
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xfff3f9ff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85), 
        child: Header()
      ),

      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: () {
            final shouldCloseDropdown = _isDropdownVisible;
            final shouldDeactivateSearch = _isSearchActive;
            if (!shouldCloseDropdown && !shouldDeactivateSearch) return;

            FocusScope.of(context).unfocus();
            if (shouldCloseDropdown) _removeDropdown();
            if (shouldDeactivateSearch) {
              setState(() => _isSearchActive = false);
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 90),
              child: Column(
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                      ),
                      image: DecorationImage(
                        image: AssetImage("assets/gambar1.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
              
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${getGreeting()} Ready to explore?",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight:FontWeight.w900,
                                  fontSize: 26,
                                  shadows: [
                                    Shadow(
                                      color: Color.fromARGB(255, 56, 56, 56),
                                      offset: Offset(0, 3),
                                      blurRadius: 6,
                                    )
                                  ]
                                ),
                              ),
                              const Text(
                                "The Best Ubud Experience",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  shadows: [
                                    Shadow(
                                      color: Color.fromARGB(255, 56, 56, 56),
                                      offset: Offset(0, 3),
                                      blurRadius: 6,
                                    )
                                  ]
                                ),
                              ),
                            ],
                          ),
              
                          CompositedTransformTarget(
                            link: _layerLink,
                            key: _dropdownKey,
                            child: Container(
                              height: 45,
                              width: double.infinity,
                              padding: const EdgeInsets.only(left: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: TextField(
                                focusNode: _searchFocusNode,
                                autofocus: false,
                                controller: _searchController,
                                onChanged: _performSearch,
                                readOnly: !_isSearchActive,
                                onTap: () {
                                  setState(() {
                                    _isSearchActive = true;
                                    _toggleDropdown();
                                  });
                                  FocusScope.of(context).requestFocus(_searchFocusNode);
                                },
                                decoration: InputDecoration(
                                  hintText: selectedStyle.isNotEmpty 
                                    ? selectedStyle 
                                    : "Where  do you want to go?",
                                  hintStyle: const TextStyle(
                                    color: Color.fromARGB(255, 95, 95, 95),
                                    fontSize: 14
                                  ),
                                  border: InputBorder.none,
                                  suffixIcon: Container(
                                    width: 45,
                                    height: 45,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF8AC4FA),
                                      borderRadius: BorderRadius.horizontal(right: Radius.circular(15))
                                    ),
                                    child: const Icon(Icons.search, color: Colors.white,),
                                  )
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                    
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
          
                      if (_searchController.text.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _subHeader(title: "Search Results"),
          
                            Padding(
                              padding: const EdgeInsets.only(left: 25, bottom: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _searchController.text,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                    )
                                  ),
          
                                  Row(
                                    children: [
                                      Text(
                                        "${searchedDestinations.length} ",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const Text(
                                        "Results Found",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromARGB(255, 80, 80, 80),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ),
          
                            if (searchedDestinations.isEmpty)
                              const Padding(
                                padding: EdgeInsets.only(left: 20, bottom: 10),
                                child: Text("No results found."),
                              ),
          
                            if (searchedDestinations.isNotEmpty)
                              _bodySubHeader(
                                itemCount: searchedDestinations.length,
                                itemBuilder: (context, index) {
                                  final item = searchedDestinations[index];
                                  final ratDest = averageRatingForDestination(item.id_destination, reviews);
                                  final image = item.imageUrl.first;
                                  final cats = item.subCategoryId.isNotEmpty
                                      ? item.subCategoryId
                                          .map((sub) => sub.categoryId.name)
                                          .toSet()
                                          .toList()
                                      : <String>[];
          
                                  return CardItems2(
                                    image: image,
                                    title: item.name,
                                    subTitle: item.description,
                                    rating: ratDest,
                                    categories: cats,
                                    isDestination: true,
                                    onTap: () => _navigateTo(
                                      DetailPage(
                                        destination: item, 
                                        event: null,
                                      )
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
              
                      if (appliedSubCategories.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _subHeader(
                              title: "Recommended Your Style",
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  _isSearchActive = false;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SeeAllPage(
                                      selectedCategories: selectedCategory,
                                      selectedSubCategories: selectedSubCategories,
                                      appliedSubCategories: appliedSubCategories,
                                      onSaveStyle: (cats, subs, applied) {
                                        setState(() {
                                          selectedCategory = List.from(cats);
                                          selectedSubCategories = List.from(subs);
                                          appliedSubCategories = List.from(applied);
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: FilterApply(
                                key: ValueKey(appliedSubCategories.length),
                                selectedCategory: selectedCategory,
                                selectedSubCategories: selectedSubCategories,
                                appliedSubCategories: appliedSubCategories,
                                categories: categories,
                                subCategories: subCategories,
                                onFilterChanged: ({
                                  required selectedCategory,
                                  required selectedSubCategories,
                                  required appliedSubCategories,
                                }) {
                                  setState(() {
                                    this.selectedCategory = selectedCategory;
                                    this.selectedSubCategories = selectedSubCategories;
                                    this.appliedSubCategories = appliedSubCategories;
                                  });
                                },
                              ),
                            ),
              
              
                            _bodySubHeader(
                              itemCount: filteredDestinations.length, 
                              itemBuilder: (context, index) {
                                final item = filteredDestinations[index];
                                final ratDest = averageRatingForDestination(item.id_destination, reviews);
                                return CardItems2(
                                  image: item.imageUrl.first, 
                                  title: item.name, 
                                  subTitle: item.description,
                                  rating: ratDest,
                                  categories: item.subCategoryId
                                    .map((sub) => sub.categoryId.name)
                                    .toSet()
                                    .toList(),
                                  isDestination: true,
                                  onTap: () => _navigateTo(
                                    DetailPage(
                                      destination: item, 
                                      event: null,
                                    )
                                  )
                                );
                              }
                            )
                          ],
                        ),
              
                      
                      if(topRatedDestinations.isNotEmpty) ...[
                        _subHeader(
                          title: "Popular Places Now",
                        ),
                        _bodySubHeader(
                          itemCount: topRatedDestinations.length, 
                          itemBuilder: (context, index) {
                            final item = topRatedDestinations[index];
                            final ratDest = averageRatingForDestination(item.id_destination, reviews);
                            return CardItems1(
                              image: item.imageUrl.first,
                              rating: ratDest,
                              title: item.name,
                              subtitle: item.location,
                              categories: item.subCategoryId
                                .map((sub) => sub.categoryId.name)
                                .toSet()
                                .toList(),
                              onTap: () => _navigateTo(
                                DetailPage(
                                  destination: item, 
                                  event: null,
                                )),
                            );
                          },
                        ),
                      ],
              
                      const Padding(
                        padding: EdgeInsets.only(left: 20, top: 15, bottom: 5),
                        child: Text(
                          "#SpecialForYou", 
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          )
                        ),
                      ),
              
                      _bodySubHeader(
                        itemCount: imageDiscount.length, 
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              height: 240,
                              width: 350,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(image: AssetImage(imageDiscount[0]), fit: BoxFit.cover)
                              ),
                            )
                          );
                        }  
                      ),
              
                      if(todayEvents.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _subHeader(title: "Today's Event"),
              
                            _bodySubHeader(
                              itemCount: todayEvents.length, 
                              itemBuilder: (context, index) {
                                final item = todayEvents[index];
                                final ratEvent = averageRatingForEvent(item.id_event, reviews);
                                return CardItems2(
                                  rating: ratEvent,
                                  image: item.imageUrl.first, 
                                  title: item.name,
                                  location: item.location, 
                                  clock: "${item.startTime} - ${item.endTime}",
                                  subTitle: formatEventDate(item.startDate, item.endDate),
                                  price: item.price,
                                  onTap: () => _navigateTo(
                                    DetailPage(
                                      destination: null, 
                                      event: item,
                                    )
                                  )
                                );
                              }
                            ),
                          ],
                        ),
              
              
                      _subHeader(title: "All Destination"),
              
                      _bodySubHeader(
                        itemCount: destinations.length, 
                        itemBuilder: (context, index) {
                          final item = destinations[index];
                          final ratDest = averageRatingForDestination(item.id_destination, reviews);
                          return CardItems2(
                            image: item.imageUrl.first, 
                            title: item.name, 
                            subTitle: item.description,
                            rating: ratDest,
                            categories: item.subCategoryId
                              .map((sub) => sub.categoryId.name)
                              .toSet()
                              .toList(),
                            isDestination: true,
                            onTap: () async {
                              final dest = await getDestinationById(item.id_destination);

                               _navigateTo(
                                DetailPage(
                                  destination: dest, 
                                  event: null,
                                )
                              );
                            }
                          );
                        }
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
