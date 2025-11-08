import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/componen/buttonCostum.dart';
import 'package:mobile/componen/cardItems.dart';
import 'package:mobile/componen/headerCustom.dart';
import 'package:mobile/models/destination_model.dart';
import 'package:mobile/models/event_model.dart';
import 'package:mobile/models/package.dart';
import 'package:mobile/models/rating_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailPage extends StatefulWidget {
  final Destination? destination;
  final Event? event;
  final bool isInitialFavorite;
  final int? idFavorite;

  DetailPage({
    super.key,
    this.destination,
    this.event,
    this.isInitialFavorite = false,
    this.idFavorite,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _DetailPageState extends State<DetailPage> {

  late bool _isfavorites;

  Package? selectedPackage;

  Future<void> _openMap(String query) async {
    final Uri url = Uri.parse("$query");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } 
  }

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'IDR. ',
    decimalDigits: 0,
  );

  Widget _ratingStars({ required double rating, bool position = true }) {
    return StarRating(
      size: 15,
      rating: rating,
      color: Colors.amber,
      borderColor: Colors.grey,
      starCount: 5,
      mainAxisAlignment: position ? MainAxisAlignment.center : MainAxisAlignment.start,
    );
  }

  @override
  void initState() {
    super.initState();
    _isfavorites = widget.isInitialFavorite;
  }

  Widget _BottonInfo({
    required String title,
    required VoidCallback onTap,
    bool isSos = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
          decoration: BoxDecoration(
            color: isSos ? const Color(0XFFFF8484) : const Color(0xFF8AC4FA),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  OverlayEntry? _overlaySos;
  final LayerLink _sosLink = LayerLink();
  final GlobalKey _sosKey = GlobalKey();
  bool _isDropdownSos = false;

  OverlayEntry? _overlayDoDont;
  final LayerLink _doDontLink = LayerLink();
  final GlobalKey _doDontKey = GlobalKey();
  bool _isDropdownDoDont = false;

  OverlayEntry? _overlaySafety;
  final LayerLink _safetyLink = LayerLink();
  final GlobalKey _safetyKey = GlobalKey();
  bool _isDropdownSafety = false;

  void _showDropdown({
    required LayerLink link,
    required GlobalKey keyButton,
    required ValueSetter<OverlayEntry> onSaveOverlay,
    required VoidCallback onVisibleChange,
    required Widget content,
  }) {
    final overlay = Overlay.of(context);
    final RenderBox renderBox = keyButton.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        child: CompositedTransformFollower(
          link: link,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 8),
          child: Material(
            color: Colors.white,
            elevation: 4,
            borderRadius: BorderRadius.circular(20),
            child: IntrinsicWidth(
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: content,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    onSaveOverlay(overlayEntry);
    onVisibleChange();
  }

  void showReviewPopup(BuildContext context) {
    double rating = 0.0;
    TextEditingController reviewController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Write your review",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: TextField(
                          controller: reviewController,
                          maxLength: 300,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: "What did you like about this trip?",
                            hintStyle: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 235, 244, 251),
                            contentPadding: EdgeInsets.all(8),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            counterText: "",
                          ),
                        ),
                      ),

                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "300 characters letf",
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 25),
                        child: Column(
                          children: [
                            const Text(
                              "Give Stars",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                              ),
                            ),
                        
                            StarRating(
                              rating: rating,
                              starCount: 5,
                              size: 30,
                              color: Colors.amber,
                              borderColor: Colors.amber,
                              onRatingChanged: (value) {
                                setState(() {
                                  rating = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      ButtonCostum(
                        text: "Submit Review", 
                        height: 50,
                        onPressed: () {
                          if (reviewController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please write your review first!"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          print("Rating: $rating");
                          print("Review: ${reviewController.text}");

                          Navigator.pop(context); // Tutup popup
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFreeEntryBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD9D8D8)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Image.asset("assets/icons/freeEntry.png", height: 25),
            const Text(
              "FREE ENTRY",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final  isDestination = widget.destination != null;
    final destination = widget.destination;
    final event = widget.event;

    final images = isDestination ? destination!.imageUrl : event!.imageUrl;

    final avarageRating = isDestination
      ? averageRatingForDestination(destination!.id_destination)
      : averageRatingForEvent(event!.id_event);

    final reviews = isDestination
      ? ratings.where((rat) => rat.destinationId?.id_destination == destination!.id_destination).toList()
      : ratings.where((rat) => rat.eventId?.id_event == event!.id_event).toList();

    final destinationPackages = packages.where(
      (pkg) => pkg.destinationId.id_destination == destination?.id_destination
    ).toList();

    return Scaffold(
      backgroundColor: const Color(0xfff3f9ff),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85), 
        child: Header(
          onTapBack: () => Navigator.pop(context),
          title: isDestination ? "Destination" : "Event",
          onTap: () {},
        )
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: PageView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 280),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    isDestination
                                        ? destination!.name
                                        : event!.name,
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _isfavorites
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: const Color(0xFF8AC4FA),
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isfavorites = !_isfavorites;
                                    });
                                  },
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 18,
                                  color: Color(0xAC000000),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isDestination
                                    ? destination!.location
                                    : event!.location,
                                  style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 25, bottom: 15),
                              child: Text(
                                isDestination
                                  ? destination!.description
                                  : event!.description,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w300),
                              ),
                            ),

                            if (isDestination) ...[
                              Wrap(
                                spacing: 12,
                                runSpacing: 4,
                                children: [
                                  Container(
                                    width: 100,
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF8AC4FA),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      destination!.subCategoryId.categoryId.name,
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: 100,
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF8AC4FA),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      destination.subCategoryId.name,
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            if(isDestination)
                              Padding(
                                padding: const EdgeInsets.only(top: 20, bottom: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        "Facilities", 
                                        style: TextStyle(
                                          fontSize: 20, 
                                          fontWeight: FontWeight.w500, 
                                          color: Colors.black
                                        )
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: destination!.facilities!.map((f) {
                                          return Container(
                                            margin: const EdgeInsets.only(right: 15),
                                            child: Column(
                                              children: [
                                                Image.asset(  
                                                  f.icon,
                                                  width: 30,
                                                  height: 30,
                                                  color: Colors.black,
                                                ),
                                                Text(
                                                  f.name.replaceAll(' ', '\n'),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                )
                              ),

                              Padding(
                                padding: const EdgeInsets.only(bottom: 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if(isDestination)
                                      Text(
                                        "Show Tours : ${destination!.operation}", 
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),

                                    if (!isDestination) ...[
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          "Date Event : ${DateFormat('dd MMMM yyyy', 'en_US').format(event!.date)}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Time Event : ${event.startTime} - ${event.endTime}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
    
                            Padding(
                              padding: const EdgeInsets.only(bottom: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      "Available Ticket", 
                                      style: TextStyle(
                                        fontSize: 20, 
                                        fontWeight: FontWeight.w500, 
                                        color: Colors.black
                                      )
                                    ),
                                  ),

                                  isDestination 
                                    ? destinationPackages.isEmpty
                                        ? _buildFreeEntryBox()
                                        : GridView.count(
                                            crossAxisCount: 2,
                                            shrinkWrap: true,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                            childAspectRatio: 2.7,
                                            physics: const NeverScrollableScrollPhysics(),
                                            children: packages.map((pkg) {
                                              final isSelected = selectedPackage == pkg;
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedPackage = pkg;
                                                  });
                                                },
                                                child: AnimatedContainer(
                                                  height: 100,
                                                  duration: const Duration(milliseconds: 200),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(5),
                                                    border: Border.all(
                                                      color: isSelected ? const Color(0xFF8AC4FA) : Colors.grey.shade300,
                                                      width: isSelected ? 3 : 1,
                                                    ),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Center(
                                                        child: Wrap(
                                                          spacing: 6,
                                                          crossAxisAlignment: WrapCrossAlignment.center,
                                                          children: [
                                                            Image.asset(pkg.subPackageId.icon),
                                                            Text(
                                                              pkg.subPackageId.name.replaceAll(' ', '\n'),
                                                              style: const TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 15,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      if (isSelected)
                                                        Positioned(
                                                          top: 0,
                                                          left: 0,
                                                          child: ClipPath(
                                                            clipper: TriangleClipper(),
                                                            child: Container(
                                                              color: const Color(0xFF8AC4FA),
                                                              width: 21,
                                                              height: 21,
                                                              child: const Align(
                                                                alignment: Alignment.topLeft,
                                                                child: Icon(
                                                                  Icons.check,
                                                                  color: Colors.white,
                                                                  size: 14,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          )
                                    : event!.price != null 
                                      ? Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(vertical: 13),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: const Color(0xFFD9D8D8)),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: Wrap(
                                                spacing: 5,
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                children: [
                                                  Icon(Icons.confirmation_num_rounded, color: const Color(0xFF8AC4FA)),
                                                  Text(
                                                    currencyFormatter.format(event.price),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w900,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : _buildFreeEntryBox(),

                                  if (selectedPackage != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: [
                                            const BoxShadow(
                                              color: Color(0x17000000),
                                              blurRadius: 10,
                                              offset: Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              selectedPackage!.subPackageId.name,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            const Padding(
                                              padding: EdgeInsets.only(top: 6),
                                              child: Text(
                                                "Includes:",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),

                                            ...selectedPackage!.includes.map((item) => SizedBox(
                                              width: 300,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 3),
                                                child: Row(
                                                  children: [
                                                    Image.asset(item["icon"]!, width: 25, height: 25),
                                                
                                                    const SizedBox(width: 18,),
                                                
                                                    Expanded(
                                                      child: Text(
                                                        item["name"]!,
                                                        style: const TextStyle(color: Color(0xFF919191)),
                                                      )
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                                            
                                            const Padding(
                                              padding: EdgeInsets.only(top: 8),
                                              child: Wrap(
                                                spacing: 3,
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                children: [
                                                  Icon(Icons.block, color: Color(0XFFFF8484), size: 15,),
                                                  Text(
                                                    "Not Included",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            ...selectedPackage!.notIncluded.map((item) => SizedBox(
                                              width: 300,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 3),
                                                child: Row(
                                                  children: [
                                                    Image.asset(item["icon"]!, width: 25, height: 25),
                                                
                                                    const SizedBox(width: 18,),
                                                
                                                    Expanded(
                                                      child: Text(
                                                        item["name"]!,
                                                        style: const TextStyle(color: Color(0xFF919191)),
                                                      )
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 16, bottom: 10),
                                              child: Divider(color: Colors.grey[300]),
                                            ),

                                            Text(
                                              currencyFormatter.format(selectedPackage!.price),
                                              style: const TextStyle(
                                                color: Colors.orange,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            ),

                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (isDestination &&
                                      destination?.sosNearby != null &&
                                      destination!.sosNearby!.isNotEmpty)
                                    CompositedTransformTarget(
                                      link: _sosLink,
                                      key: _sosKey,
                                      child: _BottonInfo(
                                        isSos: true,
                                        title: "SOS",
                                        onTap: () {
                                          if (_isDropdownSos) {
                                            _overlaySos?.remove();
                                            _overlaySos = null;
                                            setState(() => _isDropdownSos = false);
                                          } else {
                                            _overlayDoDont?.remove();
                                            _overlayDoDont = null;
                                            _isDropdownDoDont = false;
                                            _overlaySafety?.remove();
                                            _overlaySafety = null;
                                            _isDropdownSafety = false;

                                            _showDropdown(
                                              link: _sosLink,
                                              keyButton: _sosKey,
                                              onSaveOverlay: (sos) => _overlaySos = sos,
                                              onVisibleChange: () =>
                                                  setState(() => _isDropdownSos = true),
                                              content: SizedBox(
                                                width: 220,
                                                child: Column(
                                                  children: destination.sosNearby!.map((sos) {
                                                    return Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(bottom: 10),
                                                          child: Wrap(
                                                            crossAxisAlignment:
                                                                WrapCrossAlignment.center,
                                                            spacing: 4,
                                                            children: [
                                                              Image.asset(
                                                                "assets/icons/sos.png",
                                                                scale: 0.8,
                                                              ),
                                                              const Text(
                                                                "Nearby hospital",
                                                                style: TextStyle(
                                                                  fontSize: 19,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Text(
                                                          sos.name,
                                                          style: const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          textAlign: TextAlign.center,
                                                          sos.address,
                                                          style: const TextStyle(
                                                              fontWeight: FontWeight.w400),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(vertical: 15),
                                                          child: Row(
                                                            children: [
                                                              const Icon(Icons.phone,
                                                                  color: Color(0xFF8AC4FA)),
                                                              Text(
                                                                sos.phone,
                                                                style: const TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        ButtonCostum(
                                                          height: 48,
                                                          text: "Call Now",
                                                          onPressed: () {},
                                                        ),
                                                      ],
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),

                                  if ((isDestination
                                          ? destination?.dos?.isNotEmpty ?? false
                                          : event?.dos?.isNotEmpty ?? false) ||
                                      (isDestination
                                          ? destination?.donts?.isNotEmpty ?? false
                                          : event?.donts?.isNotEmpty ?? false))
                                    CompositedTransformTarget(
                                      link: _doDontLink,
                                      key: _doDontKey,
                                      child: _BottonInfo(
                                        title: "Do & Don't",
                                        onTap: () {
                                          if (_isDropdownDoDont) {
                                            _overlayDoDont?.remove();
                                            _overlayDoDont = null;
                                            setState(() => _isDropdownDoDont = false);
                                          } else {
                                            _overlaySos?.remove();
                                            _overlaySos = null;
                                            _isDropdownSos = false;
                                            _overlaySafety?.remove();
                                            _overlaySafety = null;
                                            _isDropdownSafety = false;

                                            final dosList = isDestination
                                                ? destination!.dos ?? []
                                                : event!.dos ?? [];
                                            final dontsList = isDestination
                                                ? destination!.donts ?? []
                                                : event!.donts ?? [];

                                            _showDropdown(
                                              link: _doDontLink,
                                              keyButton: _doDontKey,
                                              onSaveOverlay: (overlay) => _overlayDoDont = overlay,
                                              onVisibleChange: () =>
                                                  setState(() => _isDropdownDoDont = true),
                                              content: SizedBox(
                                                width: 200,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    if (dosList.isNotEmpty) ...[
                                                      const Padding(
                                                        padding: EdgeInsets.only(bottom: 10),
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.check_box, color: Colors.green),
                                                            SizedBox(width: 5),
                                                            Text("Do"),
                                                          ],
                                                        ),
                                                      ),
                                                      ...dosList.map(
                                                        (dos) => Padding(
                                                          padding: const EdgeInsets.only(bottom: 10),
                                                          child: Text(dos),
                                                        ),
                                                      ),
                                                    ],
                                                    if (dontsList.isNotEmpty) ...[
                                                      const Padding(
                                                        padding: EdgeInsets.only(bottom: 10),
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.close, color: Colors.red),
                                                            SizedBox(width: 5),
                                                            Text("Don't"),
                                                          ],
                                                        ),
                                                      ),
                                                      ...dontsList.map(
                                                        (dont) => Padding(
                                                          padding: const EdgeInsets.only(bottom: 10),
                                                          child: Text(dont),
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),

                                  if ((isDestination
                                          ? destination?.safetyGuidelines?.isNotEmpty ?? false
                                          : event?.safetyGuidelines?.isNotEmpty ?? false))
                                    CompositedTransformTarget(
                                      link: _safetyLink,
                                      key: _safetyKey,
                                      child: _BottonInfo(
                                        title: "Safety Guidelines",
                                        onTap: () {
                                          if (_isDropdownSafety) {
                                            _overlaySafety?.remove();
                                            _overlaySafety = null;
                                            setState(() => _isDropdownSafety = false);
                                          } else {
                                            _overlaySos?.remove();
                                            _overlaySos = null;
                                            _isDropdownSos = false;
                                            _overlayDoDont?.remove();
                                            _overlayDoDont = null;
                                            _isDropdownDoDont = false;

                                            final safetyList = isDestination
                                                ? destination!.safetyGuidelines ?? []
                                                : event!.safetyGuidelines ?? [];

                                            _showDropdown(
                                              link: _safetyLink,
                                              keyButton: _safetyKey,
                                              onSaveOverlay: (overlay) => _overlaySafety = overlay,
                                              onVisibleChange: () =>
                                                  setState(() => _isDropdownSafety = true),
                                              content: SizedBox(
                                                width: 180,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(bottom: 10),
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.shield_outlined,
                                                              color: Colors.orange),
                                                          SizedBox(width: 5),
                                                          Text("Safety Guidelines"),
                                                        ],
                                                      ),
                                                    ),
                                                    ...safetyList.map(
                                                      (safety) => Padding(
                                                        padding: const EdgeInsets.only(bottom: 10),
                                                        child: Text(safety),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),


                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Container(
                                height: 150, 
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFD9D8D8)),
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      isDestination
                                        ? destination!.latitude
                                        : event!.latitude,
                                      isDestination
                                        ? destination!.longitude
                                        : event!.longitude
                                    ),
                                    zoom: 14,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId: const MarkerId('destination'),
                                      position: LatLng(
                                        isDestination
                                          ? destination!.latitude
                                          : event!.latitude,
                                        isDestination
                                          ? destination!.longitude
                                          : event!.longitude
                                      ),
                                    ),
                                  },
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: () => _openMap(
                                isDestination
                                  ? destination!.maps
                                  : event!.maps,
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 220, 220, 220),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Text(
                                  textAlign: TextAlign.center,
                                  "View on Google Maps",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              width: double.infinity,
                              child: Container(
                                margin: const EdgeInsets.only(top: 30, bottom: 20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F9FF),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    reviews.isEmpty
                                      ? const Padding(
                                          padding: EdgeInsets.only(top: 20),
                                          child: Text("Belum ada ulasan",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500
                                            )
                                          ),
                                        )
                                      : Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 15),
                                              child: Column(
                                                children: [
                                                  const Text("Reviews",
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w700,
                                                    )
                                                  ),

                                                  Text(avarageRating.toStringAsFixed(1),
                                                    style: const TextStyle(
                                                      fontSize: 37,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w900,
                                                    )
                                                  ),

                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 7),
                                                    child: _ratingStars(rating: avarageRating),
                                                  ),

                                                  Text(
                                                    "Based on ${reviews.length} reviews",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w300
                                                    )
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(top: 5, bottom: 20),
                                              child: Divider(
                                                thickness: 2,
                                                color: Colors.white,
                                              ),
                                            ),
                                            ...reviews.map((rev) {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 30),
                                                child: Column(
                                                  crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                  children: [
                                                    Text(rev.userId.userName,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500
                                                      )
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(right: 5),
                                                              child: _ratingStars(
                                                                rating: rev.rating,
                                                                position: false
                                                              ),
                                                            ),

                                                            Text(
                                                              rev.rating.toStringAsFixed(1),
                                                              style: const TextStyle(
                                                                fontSize: 13,
                                                                color: Colors.black,
                                                              ))
                                                          ],
                                                        ),

                                                        Text(
                                                          TimeOfDay.fromDateTime(rev.createdAt).format(context),
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey,
                                                          )
                                                        )
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 5),
                                                      child: Text(
                                                        rev.review,
                                                        textAlign: TextAlign.justify,
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.grey,
                                                        )
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                          ],
                                        ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                                      child: ButtonCostum(
                                        text: "Write a review", 
                                        onPressed: () {
                                          showReviewPopup(context);
                                        }
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 15, bottom: 5),
                        child: Row(
                          children: [
                            const Text("| ", style: TextStyle(color: Color(0xFF6189af), fontSize: 17)),
                            
                            Text(
                              "ALL ${isDestination ? "Destinations" : "Events"}", 
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              )
                            ),
                          ],
                        ),
                      ),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          child: Row(
                            children: List.generate(
                              isDestination ? destinations.length : events.length,
                              (index) {
                                if (isDestination) {
                                  final item = destinations[index];
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
                                } else {
                                  final item = events[index];

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: CardItems1(
                                      title: item.name,
                                      subtitle: item.formattedDate,
                                      image: item.imageUrl[0],
                                      onTap: () {
                                        Navigator.push(
                                          context,  
                                          MaterialPageRoute(builder: (context) => DetailPage(
                                            destination: null, 
                                            event: item,
                                          )),
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}