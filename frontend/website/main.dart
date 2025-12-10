import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'bookmark.dart';
import 'profile.dart';

// Kunci Global untuk scrolling ke section tertentu
final GlobalKey todaysEventKey = GlobalKey();

void main() {
  runApp(const TravoraApp());
}

class TravoraApp extends StatelessWidget {
  const TravoraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travora Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const HomePage(),
    );
  }
}

// --- HOME PAGE (MAIN SCREEN) ---
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _mainScrollController = ScrollController();
  
  bool _isSearching = false;
  String _searchQuery = "";

  void _handleSearch(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _isSearching = true;
        _searchQuery = query;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_mainScrollController.hasClients) {
          _mainScrollController.animateTo(
            550, 
            duration: const Duration(milliseconds: 500), 
            curve: Curves.easeInOut
          );
        }
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _isSearching = false;
      _searchQuery = "";
    });
    _scrollToTop();
  }

  void _scrollToTop() {
    if (_mainScrollController.hasClients) {
      _mainScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _mainScrollController,
        child: Column(
          children: [
            const NavBar(selectedIndex: 0),
            
            HeroSection(
              onSearch: _handleSearch, 
              initialQuery: _searchQuery
            ),
            
            if (_isSearching)
              SearchResultsSection(
                query: _searchQuery,
                onHomeTap: _clearSearch,
              )
            else ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60.0),
                child: PopularPlacesSection(),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 80.0),
                child: ExploreUbudSection(),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 80.0),
                child: TravelStyleSection(),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 80.0),
                child: TopRatedSection(),
              ),
              Padding(
                key: todaysEventKey, 
                padding: const EdgeInsets.only(bottom: 80.0),
                child: const TodaysEventSection(),
              ),
              const TravoraChatSection(),
            ],
            
            FooterSection(onScrollToTop: _scrollToTop),
          ],
        ),
      ),
    );
  }
}

// --- 1. NAVIGATION BAR (ABSOLUTE CENTER FIXED) ---
class NavBar extends StatefulWidget {
  final int selectedIndex;
  const NavBar({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4, 
      vsync: this, 
      initialIndex: widget.selectedIndex
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection(int index) {
    if (index == 0) { 
       Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (index == 1) { 
      if (ModalRoute.of(context)?.settings.name != '/' && widget.selectedIndex != 0) {
         Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        ).then((_) => _scrollToEvent());
      } else {
        _scrollToEvent();
      }
    } else if (index == 2) { 
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BookmarkPage()),
      );
    } else if (index == 3) { 
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

  void _scrollToEvent() {
    final context = todaysEventKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context, 
        duration: const Duration(milliseconds: 800), 
        curve: Curves.easeInOut
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 20),
      color: Colors.white,
      child: Row(
        // Tidak menggunakan MainAxisAlignment.spaceBetween agar bisa diatur manual dengan Expanded
        children: [
          // 1. BAGIAN KIRI (LOGO) - Dibungkus Expanded
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                   Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Agar tidak memakan seluruh lebar Expanded
                  children: [
                    const Icon(Icons.location_on_outlined, color: Color(0xFF5E9BF5), size: 28),
                    const SizedBox(width: 8),
                    Text(
                      'Travora',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5E9BF5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // 2. BAGIAN TENGAH (MENU) - Ukuran tetap di tengah
          Theme(
            data: ThemeData(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
            child: SizedBox(
              width: 600, 
              child: Center(
                child: TabBar(
                  controller: _tabController,
                  onTap: _handleTabSelection,
                  isScrollable: true,
                  physics: const NeverScrollableScrollPhysics(), 
                  dividerColor: Colors.transparent, 
                  
                  labelColor: Colors.black87,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                  unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16),
                  indicatorColor: const Color(0xFF576D85),
                  indicatorWeight: 3,
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                  tabs: const [
                    Tab(text: 'Home'),
                    Tab(text: 'Event'),
                    Tab(text: 'Bookmark'),
                    Tab(text: 'Profile'),
                  ],
                ),
              ),
            ),
          ),
          
          // 3. BAGIAN KANAN (BUTTONS) - Dibungkus Expanded agar seimbang dengan kiri
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // Rata kanan
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline, size: 18, color: Colors.white),
                  label: const Text('Chat', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF576D85),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF82B1FF),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Log In', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- 2. HERO SECTION (DIKEMBALIKAN KE LEFT ALIGN) ---
class HeroSection extends StatefulWidget {
  final Function(String) onSearch;
  final String initialQuery;

  const HeroSection({Key? key, required this.onSearch, required this.initialQuery}) : super(key: key);

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
  }

  @override
  void didUpdateWidget(covariant HeroSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuery != _searchController.text) {
      _searchController.text = widget.initialQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onSearch(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&q=80',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.2),
            colorBlendMode: BlendMode.darken,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 150.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // PERBAIKAN: Kembali ke CrossAxisAlignment.start (Rata Kiri)
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Row(
                  children: [
                    const Icon(Icons.public, color: Colors.white70, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Let's discover the beauty of Bali",
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                RichText(
                  // PERBAIKAN: Tidak ada textAlign center
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                    children: const [
                      TextSpan(text: 'Evening! ', style: TextStyle(color: Colors.white)),
                      TextSpan(text: 'Ready to explore?', style: TextStyle(color: Color(0xFF82B1FF))),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'The Best Ubud Experience',
                  style: GoogleFonts.poppins(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  width: 600,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: (val) => _submit(),
                          decoration: InputDecoration(
                            hintText: 'Where do you want to go?',
                            hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _submit,
                        child: Container(
                          height: 50,
                          width: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFF576D85),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.search, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- BAGIAN LAINNYA TETAP SAMA (LoginPage, SearchResults, Sections, dll) ---
// Saya sertakan kembali untuk kelengkapan file

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: Color(0xFF5E9BF5), size: 40),
                          const SizedBox(width: 8),
                          Text(
                            'Travora',
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF5E9BF5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Text('Log in', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
                      const SizedBox(height: 30),
                      _buildTextField(label: 'Email'),
                      const SizedBox(height: 20),
                      _buildTextField(label: 'Password', isPassword: true),
                      const SizedBox(height: 10),
                      Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: Text('Forget Password', style: GoogleFonts.poppins(color: Colors.grey)))),
                      const SizedBox(height: 20),
                      SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () { Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF82B1FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), elevation: 0), child: Text('Login', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)))),
                      const SizedBox(height: 20),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Don't have a UBX account? ", style: GoogleFonts.poppins(color: Colors.black)), InkWell(onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUpPage())); }, child: Text("Sign up", style: GoogleFonts.poppins(color: const Color(0xFF82B1FF), fontWeight: FontWeight.bold)))],),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: ClipPath(
              clipper: CustomLoginShapeClipper(),
              child: Container(
                height: double.infinity,
                decoration: const BoxDecoration(image: DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&q=80'), fit: BoxFit.cover)),
                child: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.black.withOpacity(0.3), Colors.transparent])), child: Center(child: Padding(padding: const EdgeInsets.only(left: 100.0, right: 50.0), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.public, color: Colors.white, size: 40), const SizedBox(width: 15), Text("Let's discover the beauty of Bali", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white))],)))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, bool isPassword = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.grey),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(children: [const Icon(Icons.location_on_outlined, color: Color(0xFF5E9BF5), size: 40), const SizedBox(width: 8), Text('Travora', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: const Color(0xFF5E9BF5)))]),
                      const SizedBox(height: 30),
                      Text('Sign up', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
                      const SizedBox(height: 30),
                      _buildTextField(label: 'Name'), const SizedBox(height: 20), _buildTextField(label: 'Email'), const SizedBox(height: 20), _buildTextField(label: 'Password', isPassword: true), const SizedBox(height: 20), _buildTextField(label: 'Confirm Password', isPassword: true),
                      const SizedBox(height: 30),
                      SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF82B1FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), elevation: 0), child: Text('Sign up', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)))),
                      const SizedBox(height: 20),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Already have a UBX account? ", style: GoogleFonts.poppins(color: Colors.black)), InkWell(onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())); }, child: Text("Login", style: GoogleFonts.poppins(color: const Color(0xFF82B1FF), fontWeight: FontWeight.bold)))],),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: ClipPath(
              clipper: CustomLoginShapeClipper(),
              child: Container(
                height: double.infinity,
                decoration: const BoxDecoration(image: DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&q=80'), fit: BoxFit.cover)),
                child: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.black.withOpacity(0.3), Colors.transparent])), child: Center(child: Padding(padding: const EdgeInsets.only(left: 100.0, right: 50.0), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.public, color: Colors.white, size: 40), const SizedBox(width: 15), Text("Let's discover the beauty of Bali", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white))],)))),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTextField({required String label, bool isPassword = false}) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)), child: TextField(obscureText: isPassword, decoration: InputDecoration(border: InputBorder.none, labelText: label, labelStyle: GoogleFonts.poppins(color: Colors.grey), contentPadding: EdgeInsets.zero)));
  }
}

class CustomLoginShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) { final Path path = Path(); path.moveTo(size.width, 0); path.lineTo(size.width, size.height); path.lineTo(100, size.height); path.quadraticBezierTo(-100, size.height / 2, 100, 0); path.close(); return path; }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class SearchResultsSection extends StatelessWidget {
  final String query;
  final VoidCallback onHomeTap;
  const SearchResultsSection({Key? key, required this.query, required this.onHomeTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 150.0, vertical: 40.0),
      constraints: const BoxConstraints(minHeight: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [InkWell(onTap: onHomeTap, child: Text('Home', style: GoogleFonts.poppins(fontSize: 18, color: const Color(0xFF82B1FF), fontWeight: FontWeight.w500))), Text(' > $query', style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500))]),
          const SizedBox(height: 10), Divider(color: Colors.grey[300], thickness: 1), const SizedBox(height: 30),
          Text(query.isEmpty ? "Search Result" : query, style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black)), const SizedBox(height: 10),
          Text('4 Result Found', style: GoogleFonts.poppins(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500)), const SizedBox(height: 40),
          Wrap(spacing: 20, runSpacing: 20, children: [_buildResultCard(imageUrl: 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?q=80&w=600&auto=format&fit=crop', title: 'Monkey Forest Ubud'), _buildResultCard(imageUrl: 'https://images.unsplash.com/photo-1555400038-63f5ba517a47?q=80&w=600&auto=format&fit=crop', title: 'Ulun Danu Beratan'), _buildResultCard(imageUrl: 'https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?q=80&w=600&auto=format&fit=crop', title: 'Campuhan Ridge'), _buildResultCard(imageUrl: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?q=80&w=600&auto=format&fit=crop', title: 'Tanah Lot')]),
        ],
      ),
    );
  }
  Widget _buildResultCard({required String imageUrl, required String title}) {
    return Container(width: 250, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 2, blurRadius: 8, offset: const Offset(0, 2))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.network(imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover)), Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: const [Icon(Icons.star, color: Colors.amber, size: 16), SizedBox(width: 4), Text('4.9', style: TextStyle(fontWeight: FontWeight.bold))]), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)), child: const Text('Adventure', style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)))]), const SizedBox(height: 12), Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis), const SizedBox(height: 6), Text('Protected forest with free-roaming monkeys.', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis), const SizedBox(height: 16), Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF82B1FF), elevation: 0, minimumSize: const Size(80, 32), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))), child: const Text('LEARN MORE', style: TextStyle(fontSize: 10, color: Colors.white))))]))]));
  }
}

class PopularPlacesSection extends StatefulWidget {
  const PopularPlacesSection({Key? key}) : super(key: key);
  @override
  State<PopularPlacesSection> createState() => _PopularPlacesSectionState();
}
class _PopularPlacesSectionState extends State<PopularPlacesSection> {
  final ScrollController _scrollController = ScrollController();
  void _scroll(double offset) {
    if (!_scrollController.hasClients) return;
    double newOffset = _scrollController.offset + offset;
    if (newOffset < 0) newOffset = 0;
    if (newOffset > _scrollController.position.maxScrollExtent) { newOffset = _scrollController.position.maxScrollExtent; }
    _scrollController.animateTo(newOffset, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }
  @override
  void dispose() { _scrollController.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 150.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Populer Place\nNow', style: GoogleFonts.poppins(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.black, height: 1.2)), const SizedBox(height: 20), Text('Discover the most popular\ntravel spots in Bali right now.', style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600], height: 1.5))])),
          const SizedBox(width: 30),
          Expanded(flex: 4, child: Row(children: [InkWell(onTap: () => _scroll(-240), borderRadius: BorderRadius.circular(50), child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.blue.withOpacity(0.3), width: 2), color: Colors.white), child: const Icon(Icons.arrow_back, color: Colors.blue))), const SizedBox(width: 15), Expanded(child: SizedBox(height: 320, child: ListView(controller: _scrollController, scrollDirection: Axis.horizontal, clipBehavior: Clip.hardEdge, children: [_buildPlaceCard(imageUrl: 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?q=80&w=600&auto=format&fit=crop', title: 'Monkey Forest', subtitle: 'Protected forest with\nfree-roaming\nmonkeys.', rating: '4.9'), const SizedBox(width: 20), _buildPlaceCard(imageUrl: 'https://images.unsplash.com/photo-1555400038-63f5ba517a47?q=80&w=600&auto=format&fit=crop', title: 'Ulun Danu Beratan', subtitle: 'Iconic temple on the\nshores of Lake\nBeratan.', rating: '4.9'), const SizedBox(width: 20), _buildPlaceCard(imageUrl: 'https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?q=80&w=600&auto=format&fit=crop', title: 'Campuhan Ridge', subtitle: 'Scenic nature trek\nwith lush valley\nviews.', rating: '4.8'), const SizedBox(width: 20), _buildPlaceCard(imageUrl: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?q=80&w=600&auto=format&fit=crop', title: 'Tanah Lot', subtitle: 'Ancient Hindu shrine\nperched on top of\nan outcrop.', rating: '4.7'), const SizedBox(width: 20), _buildPlaceCard(imageUrl: 'https://images.unsplash.com/photo-1577717903315-1691ae25ab3f?q=80&w=600&auto=format&fit=crop', title: 'Tegalalang Rice', subtitle: 'Famous rice terraces\nusing subak irrigation.', rating: '4.9')]) )), const SizedBox(width: 15), InkWell(onTap: () => _scroll(240), borderRadius: BorderRadius.circular(50), child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.blue.withOpacity(0.3), width: 2), color: Colors.white), child: const Icon(Icons.arrow_forward, color: Colors.blue)))]))
        ],
      ),
    );
  }
  Widget _buildPlaceCard({required String imageUrl, required String title, required String subtitle, required String rating}) {
    return Container(width: 220, height: 320, decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)), child: Stack(children: [Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.8)], stops: const [0.5, 1.0]))), Positioned(top: 15, left: 15, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Row(children: [const Icon(Icons.star, color: Colors.orange, size: 14), const SizedBox(width: 4), Text(rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))]))), Positioned(bottom: 15, left: 15, right: 15, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 4), Text(subtitle, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11, height: 1.3)), const SizedBox(height: 10), Align(alignment: Alignment.bottomRight, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(12)), child: const Text('Adventure', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))))]))]));
  }
}

class ExploreUbudSection extends StatelessWidget {
  const ExploreUbudSection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F7FB),
      padding: const EdgeInsets.symmetric(horizontal: 150.0, vertical: 40.0),
      child: Column(
        children: [
          Text('Explore Ubud', style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 40),
          SizedBox(height: 400, child: Row(children: [Expanded(child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), image: const DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?q=80&w=800&auto=format&fit=crop'), fit: BoxFit.cover)))), const SizedBox(width: 20), Expanded(child: Column(children: [Expanded(child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), image: const DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1554481923-a6918bd997bc?q=80&w=800&auto=format&fit=crop'), fit: BoxFit.cover)))), const SizedBox(height: 20), Expanded(child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), image: const DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1554481923-a6918bd997bc?q=80&w=800&auto=format&fit=crop'), fit: BoxFit.cover))))])), const SizedBox(width: 20), Expanded(child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), image: const DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1537996194471-e657df975ab4?q=80&w=800&auto=format&fit=crop'), fit: BoxFit.cover))))])),
        ],
      ),
    );
  }
}

class TravelStyleSection extends StatelessWidget {
  const TravelStyleSection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 150.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Container(width: 4, height: 28, color: Colors.black), const SizedBox(width: 10), Text('Travel Style', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black))]), ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF82B1FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), elevation: 0), child: const Text('View More', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))]),
          const SizedBox(height: 30),
          Row(children: [_buildTag('Culture', icon: Icons.masks, isSelected: true), const SizedBox(width: 15), _buildTag('Adventure', icon: Icons.explore), const SizedBox(width: 15), _buildTag('Art'), const SizedBox(width: 15), _buildTag('Food'), const SizedBox(width: 15), _buildTag('Historical'), const SizedBox(width: 15), _buildTag('Spiritual'), const SizedBox(width: 15), _buildTag('Festival')]),
          const SizedBox(height: 40),
          Row(children: [Expanded(child: _buildStyleCard(imageUrl: 'https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?q=80&w=400', title: 'Monkey Forest', description: 'Protected forest with free-roaming monkeys.')), const SizedBox(width: 20), Expanded(child: _buildStyleCard(imageUrl: 'https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?q=80&w=400', title: 'Sacred Monkey', description: 'Ancient temple complex in Ubud.')), const SizedBox(width: 20), Expanded(child: _buildStyleCard(imageUrl: 'https://images.unsplash.com/photo-1598091383021-15ddea10925d?q=80&w=400', title: 'Ubud Yoga', description: 'Find inner peace in the heart of Bali.')), const SizedBox(width: 20), Expanded(child: _buildStyleCard(imageUrl: 'https://images.unsplash.com/photo-1516483638261-f4dbaf036963?q=80&w=400', title: 'Local Culture', description: 'Experience the daily life of locals.'))]),
          const SizedBox(height: 40),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_circle_left_outlined, color: Color(0xFF82B1FF), size: 40)), const SizedBox(width: 10), Text('Back', style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[700])), const SizedBox(width: 20), Text('Next', style: GoogleFonts.poppins(fontSize: 18, color: Colors.black)), const SizedBox(width: 10), IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_circle_right_outlined, color: Color(0xFF82B1FF), size: 40))])
        ],
      ),
    );
  }
  Widget _buildTag(String label, {IconData? icon, bool isSelected = false}) { return Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), decoration: BoxDecoration(color: isSelected ? const Color(0xFF82B1FF) : Colors.grey[100], borderRadius: BorderRadius.circular(8), border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[300]!)), child: Row(children: [if (icon != null) ...[Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.black87), const SizedBox(width: 8)], Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600))])); }
  Widget _buildStyleCard({required String imageUrl, required String title, required String description}) { return Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 2, blurRadius: 8, offset: const Offset(0, 2))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.network(imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover)), Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: const [Icon(Icons.star, color: Colors.amber, size: 16), SizedBox(width: 4), Text('4.9', style: TextStyle(fontWeight: FontWeight.bold))]), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)), child: const Text('Adventure', style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)))]), const SizedBox(height: 12), Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis), const SizedBox(height: 6), Text(description, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis), const SizedBox(height: 16), Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF82B1FF), elevation: 0, minimumSize: const Size(80, 32), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))), child: const Text('LEARN MORE', style: TextStyle(fontSize: 10, color: Colors.white))))]))])); }
}

class TopRatedSection extends StatelessWidget {
  const TopRatedSection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F7FB),
      padding: const EdgeInsets.symmetric(horizontal: 150.0, vertical: 40.0),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Container(width: 4, height: 28, color: Colors.black), const SizedBox(width: 10), Text('Top-Rated Travel Experiences', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black))]), Row(children: [Text('All', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black, decoration: TextDecoration.underline)), const SizedBox(width: 20), Text('Adventure', style: GoogleFonts.poppins(fontSize: 18, color: Colors.black87)), const SizedBox(width: 20), Text('Culture', style: GoogleFonts.poppins(fontSize: 18, color: Colors.black87))])]),
          const SizedBox(height: 40),
          Row(children: [Expanded(child: _buildTopRatedCard(imageUrl: 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?q=80&w=600&auto=format&fit=crop', title: 'Monkey Forest Ubud', description: 'Protected forest with free-roaming monkeys.')), const SizedBox(width: 20), Expanded(child: _buildTopRatedCard(imageUrl: 'https://images.unsplash.com/photo-1555400038-63f5ba517a47?q=80&w=600&auto=format&fit=crop', title: 'Ulun Danu Beratan', description: 'Iconic temple on the shores of Lake Beratan.')), const SizedBox(width: 20), Expanded(child: _buildTopRatedCard(imageUrl: 'https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?q=80&w=600&auto=format&fit=crop', title: 'Campuhan Ridge', description: 'Scenic nature trek with lush valley views.')), const SizedBox(width: 20), Expanded(child: _buildTopRatedCard(imageUrl: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?q=80&w=600&auto=format&fit=crop', title: 'Tanah Lot', description: 'Ancient Hindu shrine perched on top of an outcrop.'))]),
          const SizedBox(height: 40),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_circle_left_outlined, color: Color(0xFF82B1FF), size: 40)), const SizedBox(width: 10), Text('Back', style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[700])), const SizedBox(width: 20), Text('Next', style: GoogleFonts.poppins(fontSize: 18, color: Colors.black)), const SizedBox(width: 10), IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_circle_right_outlined, color: Color(0xFF82B1FF), size: 40))])
        ],
      ),
    );
  }
  Widget _buildTopRatedCard({required String imageUrl, required String title, required String description}) { return Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 2, blurRadius: 8, offset: const Offset(0, 2))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.network(imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover)), Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: const [Icon(Icons.star, color: Colors.amber, size: 16), SizedBox(width: 4), Text('4.9', style: TextStyle(fontWeight: FontWeight.bold))]), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)), child: const Text('Adventure', style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)))]), const SizedBox(height: 12), Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis), const SizedBox(height: 6), Text(description, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis), const SizedBox(height: 16), Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF82B1FF), elevation: 0, minimumSize: const Size(80, 32), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))), child: const Text('LEARN MORE', style: TextStyle(fontSize: 10, color: Colors.white))))]))])); }
}

class TodaysEventSection extends StatefulWidget {
  const TodaysEventSection({Key? key}) : super(key: key);
  @override
  State<TodaysEventSection> createState() => _TodaysEventSectionState();
}
class _TodaysEventSectionState extends State<TodaysEventSection> {
  DateTime _focusedDay = DateTime.utc(2025, 5, 27); 
  DateTime? _selectedDay = DateTime.utc(2025, 5, 27);
  final List<Map<String, String>> events = [ { 'title': 'Legong Dance', 'location': 'Ubud Palace', 'description': 'Graceful traditional Balinese dance with gamelan music', 'image': 'https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?q=80&w=400', }, { 'title': 'Kecak Fire Dance', 'location': 'Pura Dalem Ubud', 'description': 'Dramatic performance involving fire and chanting choir.', 'image': 'https://images.unsplash.com/photo-1555400038-63f5ba517a47?q=80&w=400', }, { 'title': 'Traditional Market', 'location': 'Ubud Market', 'description': 'Explore local crafts and fresh produce in the morning.', 'image': 'https://images.unsplash.com/photo-1577717903315-1691ae25ab3f?q=80&w=400', } ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 150.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Container(width: 4, height: 28, color: Colors.black), const SizedBox(width: 10), Text("Today's Event", style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black))]),
          const SizedBox(height: 10),
          Text("Events available today, on the ${_selectedDay?.day ?? '-'}th.", style: GoogleFonts.poppins(fontSize: 18, color: Colors.black87)),
          const SizedBox(height: 40),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: LayoutBuilder(builder: (context, constraints) { double cardWidth = (constraints.maxWidth - 20) / 2; return Wrap(spacing: 20, runSpacing: 20, children: events.map((event) => SizedBox(width: cardWidth, child: _buildEventCard(event))).toList()); })),
              const SizedBox(width: 40),
              Expanded(flex: 2, child: Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 5, blurRadius: 15, offset: const Offset(0, 5))]), child: TableCalendar(firstDay: DateTime.utc(2024, 1, 1), lastDay: DateTime.utc(2030, 12, 31), focusedDay: _focusedDay, calendarFormat: CalendarFormat.month, selectedDayPredicate: (day) { return isSameDay(_selectedDay, day); }, onDaySelected: (selectedDay, focusedDay) { setState(() { _selectedDay = selectedDay; _focusedDay = focusedDay; }); ScaffoldMessenger.of(context).hideCurrentSnackBar(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Showing events for ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}'), duration: const Duration(seconds: 1), backgroundColor: const Color(0xFF5E9BF5))); }, onPageChanged: (focusedDay) { _focusedDay = focusedDay; }, headerStyle: HeaderStyle(titleCentered: false, formatButtonVisible: false, titleTextStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold), leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.grey), rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.black), headerMargin: const EdgeInsets.only(bottom: 20)), daysOfWeekStyle: DaysOfWeekStyle(weekdayStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600]), weekendStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600])), calendarStyle: CalendarStyle(defaultTextStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.black87), weekendTextStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.black87), outsideTextStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[300]), selectedDecoration: const BoxDecoration(color: Color(0xFF82B1FF), shape: BoxShape.circle), selectedTextStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold), todayDecoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle, border: Border.all(color: const Color(0xFF82B1FF))), todayTextStyle: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF82B1FF), fontWeight: FontWeight.bold))))),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildEventCard(Map<String, String> event) { return Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.withOpacity(0.1)), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, 4))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.network(event['image'] ?? 'https://via.placeholder.com/150', height: 150, width: double.infinity, fit: BoxFit.cover)), Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(event['title'] ?? 'No Title', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Row(children: [const Icon(Icons.location_on, size: 14, color: Colors.blue), const SizedBox(width: 4), Text(event['location'] ?? 'Unknown Location', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]))]), const SizedBox(height: 8), Text(event['description'] ?? 'No Description', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500], fontStyle: FontStyle.italic), maxLines: 2, overflow: TextOverflow.ellipsis), const SizedBox(height: 16), Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF82B1FF), elevation: 0, minimumSize: const Size(100, 32), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))), child: const Text('FREE ACCESS', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))))]))])); }
}

class TravoraChatSection extends StatelessWidget {
  const TravoraChatSection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F7FB),
      padding: const EdgeInsets.symmetric(horizontal: 150.0, vertical: 80.0),
      child: Row(
        children: [
          Expanded(flex: 1, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Need quick answers?', style: GoogleFonts.poppins(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.black)), const SizedBox(height: 20), Text("Meet Travora’s smart WhatsApp assistant — your travel buddy for instant answers and recommendations.", style: GoogleFonts.poppins(fontSize: 18, color: Colors.black87, height: 1.5)), const SizedBox(height: 40), ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.chat_bubble, color: Colors.white), label: const Text('Chat', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF64829F), padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))])),
          const SizedBox(width: 80),
          Expanded(flex: 1, child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))]), child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Column(children: [Container(padding: const EdgeInsets.all(20), color: const Color(0xFF64829F), child: Row(children: [const Icon(Icons.chat, color: Colors.white, size: 28), const SizedBox(width: 12), Text('Travora chat', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white))])), Container(padding: const EdgeInsets.all(24), color: Colors.white, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildChatBubble('Halo! Saya Asisten Chat. Mau cari apa hari ini?', isUser: false), _buildChatBubble('Wisata yang terpopuler di ubud', isUser: true), _buildChatBubble('Berikut 5 wisata yang terpopuler : Monkey Forest........', isUser: false), _buildChatBubble('Tolong arah ke wisata Monkey', isUser: true), _buildChatBubble('Mau buka Google Maps?', isUser: false)])), Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.grey[50], border: Border(top: BorderSide(color: Colors.grey.shade200))), child: Row(children: [Expanded(child: Text('ketik pertanyaanmu disini', style: GoogleFonts.poppins(color: Colors.grey[400]))), Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(border: Border.all(color: Colors.blue.withOpacity(0.3)), borderRadius: BorderRadius.circular(8)), child: Text('Kirim', style: GoogleFonts.poppins(color: Colors.blue, fontWeight: FontWeight.bold))) ]))])))),
        ],
      ),
    );
  }
  Widget _buildChatBubble(String text, {required bool isUser}) { return Align(alignment: isUser ? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), constraints: const BoxConstraints(maxWidth: 300), decoration: BoxDecoration(color: isUser ? const Color(0xFF82B1FF) : Colors.grey[100], borderRadius: BorderRadius.only(topLeft: const Radius.circular(12), topRight: const Radius.circular(12), bottomLeft: isUser ? const Radius.circular(12) : Radius.zero, bottomRight: isUser ? Radius.zero : const Radius.circular(12))), child: Text(text, style: GoogleFonts.poppins(color: isUser ? Colors.white : Colors.black87, fontSize: 14)))); }
}

class FooterSection extends StatelessWidget {
  final VoidCallback onScrollToTop;
  const FooterSection({Key? key, required this.onScrollToTop}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 150.0, vertical: 50.0),
      child: Column(
        children: [
          Stack(alignment: Alignment.center, children: [Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.location_on_outlined, color: Color(0xFF5E9BF5), size: 36), const SizedBox(width: 8), Text('Travora', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: const Color(0xFF5E9BF5)))]), Align(alignment: Alignment.centerRight, child: InkWell(onTap: onScrollToTop, borderRadius: BorderRadius.circular(30), child: Container(width: 50, height: 50, decoration: const BoxDecoration(color: Color(0xFF82B1FF), shape: BoxShape.circle), child: const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 30))))]),
          const SizedBox(height: 40),
          Divider(color: Colors.grey[300], thickness: 1),
          const SizedBox(height: 20),
          Align(alignment: Alignment.centerRight, child: Text('Copyright © 2025 • Travora.', style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87)))
        ],
      ),
    );
  }
}