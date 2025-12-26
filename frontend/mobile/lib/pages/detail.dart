import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/componen/Detail/FacilitySection.dart';
import 'package:mobile/componen/Detail/ReviewSection.dart';
import 'package:mobile/componen/formatDate.dart';
import 'package:mobile/componen/WhatsApp.dart';
import 'package:mobile/componen/buttonCostum.dart';
import 'package:mobile/componen/cardItems.dart';
import 'package:mobile/componen/formatImage.dart';
import 'package:mobile/componen/headerCustom.dart';
import 'package:mobile/models/bookmark_model.dart';
import 'package:mobile/models/destination_model.dart';
import 'package:mobile/models/event_model.dart';
import 'package:mobile/models/package_model.dart';
import 'package:mobile/models/review_model.dart';
import 'package:mobile/models/subPackage.dart';
import 'package:mobile/models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailPage extends StatefulWidget {
  final Destination? destination;
  final Event? event;
  final int? idFavorite;

  const DetailPage({
    super.key,
    this.destination,
    this.event,
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
  SubPackage? selectedSubPackage;
  List<Destination> destinations = [];
  List<Event> events = [];
  List<Package> packages = [];
  List<Review> reviews = [];

  Future<void> loadData() async {
    try {
      final dest = await getDestinations();
      final evt = await getEvents();
      final pkg = await getPackages();
      final rev = await getReviews();
      setState(() {
        destinations = dest;
        events = evt;
        packages = pkg;
        reviews = rev;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _openMap(String query) async {
    final Uri url = Uri.parse(query);

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
    loadData();

    _isfavorites = isBookmarked(
      userId: User.currentUser!.id_user,
      destination: widget.destination,
      event: widget.event,
    );
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
    bool isSafety = false,
  }) {
    final overlay = Overlay.of(context);
    final RenderBox renderBox = keyButton.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        child: CompositedTransformFollower(
          targetAnchor: isSafety ? Alignment.topRight : Alignment.topLeft,
          followerAnchor: isSafety ? Alignment.topRight : Alignment.topLeft,
          link: link,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
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

  void showAllReviews(BuildContext context) {
    final allReviews = widget.destination != null
        ? reviews.where((r) => r.destinationId?.id_destination == widget.destination!.id_destination).toList()
        : reviews.where((r) => r.eventId?.id_event == widget.event!.id_event).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: const Text(
                      "All Reviews",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: allReviews.length,
                      itemBuilder: (context, index) {
                        final rev = allReviews[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                margin: EdgeInsets.only(right: 7),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: rev.userId.image.isNotEmpty
                                  ?  ClipOval(
                                      child: Image(
                                        image: formatImage(rev.userId.image),
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon( 
                                      Icons.account_circle,
                                      size: 40,
                                      color: Colors.grey[400],
                                    ),
                              ),

                              Expanded(
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(rev.userId.username,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500
                                              )
                                            ),
                                    
                                            if(rev.userId.id_user == User.currentUser!.id_user)
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 7),
                                                child: Text(
                                                  "(you)",
                                                  style: const TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300
                                                  )
                                                ),
                                              ),
                                          ],
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
                                            rev.comment,
                                            textAlign: TextAlign.justify,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                            )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
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

  void toggleBookmark({
    required User user,
    Destination? destination,
    Event? event,
  }) {
    assert(
      (destination != null && event == null) ||
      (destination == null && event != null),
      'Either destination or event must be provided, not both',
    );

    final index = bookmarks.indexWhere((b) =>
        b.userId.id_user == user.id_user &&
        (destination != null
            ? b.destinationId?.id_destination == destination.id_destination
            : b.eventId?.id_event == event!.id_event));

    if (index != -1) {
      bookmarks.removeAt(index);
    } else {
      bookmarks.add(
        Bookmark(
          id_bookmark: DateTime.now().millisecondsSinceEpoch,
          userId: user,
          destinationId: destination,
          eventId: event,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final  isDestination = widget.destination != null;
    final destination = widget.destination;
    final event = widget.event;

    final images = isDestination ? destination!.imageUrl : event!.imageUrl;

    final avarageRating = isDestination
      ? averageRatingForDestination(destination!.id_destination, reviews)
      : averageRatingForEvent(event!.id_event, reviews);

    final comments = (isDestination
      ? reviews.where((rat) => rat.destinationId?.id_destination == destination!.id_destination)
      : reviews.where((rat) => rat.eventId?.id_event == event!.id_event)
    ).toList();

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
                    return Image(
                      image: formatImage(images[index]),
                      fit: BoxFit.cover,
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
                                      height: 1.2,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
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
                                      toggleBookmark(
                                        user: User.currentUser!,
                                        destination: widget.destination,
                                        event: widget.event,
                                      );

                                      _isfavorites = isBookmarked(
                                        userId: User.currentUser!.id_user,
                                        destination: widget.destination,
                                        event: widget.event,
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: const Icon(
                                      Icons.location_on,
                                      size: 18,
                                      color: Color(0xAC000000),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      isDestination
                                          ? destination?.location ?? '-'
                                          : event?.destinationId?.location ??
                                            event?.location ??
                                            '-',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                                children: destination!.subCategoryId
                                    .map((sub) => sub.categoryId.name)
                                    .toSet()
                                    .map((catName) => Container(
                                          width: 100,
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF8AC4FA),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            catName,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),

                            if(isDestination && destination.facilities != null)
                              FacilitySection(facilities: destination.facilities!),

                              Padding(
                                padding: const EdgeInsets.only(bottom: 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if(isDestination)
                                      Text(
                                        "Show Tours : ${destination.operational}", 
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
                                          "Date Event : ${formatEventDate(event!.startDate, event.endDate)}",
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
                                        : StatefulBuilder(
                                          builder: (context, setLocalState) {
                                            return GridView.count(
                                                crossAxisCount: 2,
                                                shrinkWrap: true,
                                                crossAxisSpacing: 8,
                                                mainAxisSpacing: 8,
                                                childAspectRatio: 2.7,
                                                physics: const NeverScrollableScrollPhysics(),
                                                children: destinationPackages.expand((pkg) => pkg.subPackages.entries.map((entry) {
                                                    final subPkg = entry.key;
                                                    final data = entry.value;
                                            
                                                    // ignore: unused_local_variable
                                                    final price = data["price"] as int;
                                                    // ignore: unused_local_variable
                                                    final includes = List<Map<String, dynamic>>.from(data["include"]);
                                            
                                                    final isSelected =
                                                        selectedPackage == pkg && selectedSubPackage == subPkg;
                                            
                                                    return GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedPackage = pkg;
                                                          selectedSubPackage = subPkg;
                                                        });
                                                      },
                                                      child: AnimatedContainer(
                                                        duration: const Duration(milliseconds: 200),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(5),
                                                          border: Border.all(
                                                            color: isSelected
                                                                ? const Color(0xFF8AC4FA)
                                                                : Colors.grey.shade300,
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
                                                                  Image(
                                                                    image: formatImage(subPkg.icon)
                                                                  ),
                                                                  Text(
                                                                    subPkg.name.replaceAll(' ', '\n'),
                                                                    style: const TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 15,
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
                                                                    alignment: Alignment.topLeft,
                                                                    color: const Color(0xFF8AC4FA),
                                                                    width: 21,
                                                                    height: 21,
                                                                    child: const Icon(Icons.check, color: Colors.white, size: 14),
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  })).toList(),
                                                );
                                            }
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
                                                  const Icon(Icons.confirmation_num_rounded, color: Color(0xFF8AC4FA)),
                                                  Text(
                                                    currencyFormatter.format(event.price),
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w900,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : _buildFreeEntryBox(),

                                  if (selectedPackage != null && selectedSubPackage != null)
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(top: 20),
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: const [
                                          BoxShadow(
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
                                            selectedSubPackage!.name,
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
                                    
                                          ...List<Map<String, dynamic>>.from(
                                            selectedPackage!.subPackages[selectedSubPackage!]!["include"],
                                          ).map((item) => SizedBox(
                                                width: 300,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 3),
                                                  child: Row(
                                                    children: [
                                                      Image(
                                                        image: formatImage(item["image"]),
                                                        width: 25,
                                                        height: 25,
                                                      ),
                                                      const SizedBox(width: 18),
                                                      Expanded(
                                                        child: Text(
                                                          item["name"],
                                                          style: const TextStyle(color: Color(0xFF919191)),
                                                        ),
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
                                            currencyFormatter.format(
                                              selectedPackage!.subPackages[selectedSubPackage!]!["price"],
                                            ),
                                            style: const TextStyle(
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
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
                                  if (isDestination && destination.sos != null)
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
                                            _isDropdownSos = false;
                                          } else {
                                            _overlayDoDont?.remove();
                                            _overlayDoDont = null;
                                            _isDropdownDoDont = false;
                                            _overlaySafety?.remove();
                                            _overlaySafety = null;
                                            _isDropdownSafety = false;

                                            final sos = destination.sos!;

                                            _showDropdown(
                                              link: _sosLink,
                                              keyButton: _sosKey,
                                              onSaveOverlay: (overlay) => _overlaySos = overlay,
                                              onVisibleChange: () {
                                                _isDropdownSos = true;
                                              },
                                              content: ConstrainedBox(
                                                constraints: const BoxConstraints(maxWidth: 200),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 10),
                                                      child: Wrap(
                                                        crossAxisAlignment: WrapCrossAlignment.center,
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
                                                      sos.address,
                                                      textAlign: TextAlign.center,
                                                      style: const TextStyle(fontWeight: FontWeight.w400),
                                                    ),

                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 15),
                                                      child: Row(
                                                        children: [
                                                          const Icon(Icons.phone, color: Color(0xFF8AC4FA)),
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
                                                      onPressed: () {
                                                        openWhatsApp(sos.phone);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),

                                  if ((isDestination
                                          ? destination.dos?.isNotEmpty ?? false
                                          : event?.dos?.isNotEmpty ?? false) ||
                                      (isDestination
                                          ? destination.donts?.isNotEmpty ?? false
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
                                            _isDropdownDoDont = false;
                                          } else {
                                            _overlaySos?.remove();
                                            _overlaySos = null;
                                            _isDropdownSos = false;
                                            _overlaySafety?.remove();
                                            _overlaySafety = null;
                                            _isDropdownSafety = false;

                                            final dosList = isDestination
                                                ? destination.dos ?? []
                                                : event!.dos ?? [];
                                            final dontsList = isDestination
                                                ? destination.donts ?? []
                                                : event!.donts ?? [];

                                            _showDropdown(
                                              link: _doDontLink,
                                              keyButton: _doDontKey,
                                              onSaveOverlay: (overlay) => _overlayDoDont = overlay,
                                              onVisibleChange: () {
                                                _isDropdownDoDont = true;
                                              },
                                              content: SizedBox(
                                                width: 200,
                                                child: ConstrainedBox(
                                                  constraints: const BoxConstraints(
                                                    maxHeight: 300
                                                  ),
                                                  child: SingleChildScrollView(
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
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),

                                  if ((isDestination
                                          ? destination.safetyGuidelines?.isNotEmpty ?? false
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
                                            _isDropdownSafety = false;
                                          } else {
                                            _overlaySos?.remove();
                                            _overlaySos = null;
                                            _isDropdownSos = false;
                                            _overlayDoDont?.remove();
                                            _overlayDoDont = null;
                                            _isDropdownDoDont = false;

                                            final safetyList = isDestination
                                                ? destination.safetyGuidelines ?? []
                                                : event!.safetyGuidelines ?? [];

                                            _showDropdown(
                                              link: _safetyLink,
                                              keyButton: _safetyKey,
                                              onSaveOverlay: (overlay) => _overlaySafety = overlay,
                                              onVisibleChange: () {
                                                _isDropdownSafety = true;
                                              },
                                              isSafety: true,
                                              content: SizedBox(
                                                width: 180,
                                                child: ConstrainedBox(
                                                  constraints: const BoxConstraints(
                                                    maxHeight: 300
                                                  ),
                                                  child: SingleChildScrollView(
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
                                        ? destination.latitude
                                        : event?.destinationId?.latitude ??
                                          event?.latitude ?? 0,
                                      isDestination
                                        ? destination.longitude
                                        : event?.destinationId?.longitude ??
                                          event?.longitude ?? 0
                                    ),
                                    zoom: 14,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId: const MarkerId('destination'),
                                      position: LatLng(
                                        isDestination
                                          ? destination.latitude
                                          : event?.destinationId?.latitude ??
                                            event?.latitude ?? 0,
                                        isDestination
                                          ? destination.longitude
                                          : event?.destinationId?.longitude ??
                                            event?.longitude ?? 0
                                      ),
                                    ),
                                  },
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: () => _openMap(
                                isDestination
                                  ? destination.maps
                                  : event?.destinationId != null
                                    ? event!.destinationId!.maps
                                    : event!.maps
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
                              child: ReviewSection(
                                review: comments.take(5).toList(),
                                averageRating: avarageRating,
                                onSeeAll: () => showAllReviews(context),
                                onWrite: () {
                                  showcommentPopup(
                                    context,
                                    destinationId: isDestination ? destination.id_destination : null,
                                    eventId: !isDestination ? event!.id_event : null,
                                    onSuccess: () async {
                                      final newReviews = await getReviews();
                                      setState(() {
                                        reviews = newReviews;
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ]
                          ]
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
                                  final ratDest = averageRatingForDestination(item.id_destination, reviews);

                                  return CardItems2(
                                    image: item.imageUrl[0],
                                    title: item.name,
                                    subTitle: item.description,
                                    rating: ratDest,
                                    categories: item.subCategoryId
                                      .map((sub) => sub.categoryId.name)
                                      .toSet()
                                      .toList(),
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
                                      subtitle: formatEventDate(item.startDate, item.endDate),
                                      image: item.imageUrl.first,
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