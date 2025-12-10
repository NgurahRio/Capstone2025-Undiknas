import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart'; // Mengimpor HomePage dan FooterSection dari main.dart

// FUNGSI MAIN AGAR BISA DI-RUN SENDIRIAN
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Bookmark',
    home: BookmarkLoggedInPage(),
  ));
}

class BookmarkLoggedInPage extends StatefulWidget {
  const BookmarkLoggedInPage({Key? key}) : super(key: key);

  @override
  State<BookmarkLoggedInPage> createState() => _BookmarkLoggedInPageState();
}

class _BookmarkLoggedInPageState extends State<BookmarkLoggedInPage> {
  // Data Dummy Bookmark
  final List<Map<String, String>> _bookmarkedItems = [
    {
      'title': 'Monkey Forest Ubud',
      'desc': 'Protected forest with free-roaming monkeys.',
      'image': 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?q=80&w=600&auto=format&fit=crop'
    },
    {
      'title': 'Monkey Forest Ubud', // Duplikasi sesuai gambar contoh
      'desc': 'Protected forest with free-roaming monkeys.',
      'image': 'https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?q=80&w=600&auto=format&fit=crop'
    },
    {
      'title': 'Monkey Forest Ubud',
      'desc': 'Protected forest with free-roaming monkeys.',
      'image': 'https://images.unsplash.com/photo-1533587851505-d119e13fa0d7?q=80&w=600&auto=format&fit=crop'
    },
    {
      'title': 'Monkey Forest Ubud',
      'desc': 'Protected forest with free-roaming monkeys.',
      'image': 'https://images.unsplash.com/photo-1541625602330-2277a4c46182?q=80&w=600&auto=format&fit=crop'
    },
    {
      'title': 'Monkey Forest Ubud',
      'desc': 'Protected forest with free-roaming monkeys.',
      'image': 'https://images.unsplash.com/photo-1534567153574-2b12153a87f0?q=80&w=600&auto=format&fit=crop'
    },
    {
      'title': 'Monkey Forest Ubud',
      'desc': 'Protected forest with free-roaming monkeys.',
      'image': 'https://images.unsplash.com/photo-1575550959106-5a7defe28b56?q=80&w=600&auto=format&fit=crop'
    },
    {
      'title': 'Monkey Forest Ubud',
      'desc': 'Protected forest with free-roaming monkeys.',
      'image': 'https://images.unsplash.com/photo-1555400038-63f5ba517a47?q=80&w=600&auto=format&fit=crop'
    },
    {
      'title': 'Monkey Forest Ubud',
      'desc': 'Protected forest with free-roaming monkeys.',
      'image': 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=600&auto=format&fit=crop'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. NAVIGATION BAR (KHUSUS LOGGED IN - Index 2 Bookmark)
            const NavBarLoggedIn(selectedIndex: 2),

            // 2. HERO SECTION
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1555400038-63f5ba517a47?q=80&w=1200&auto=format&fit=crop', 
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.2),
                    colorBlendMode: BlendMode.darken,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 5,
                              height: 48,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              'Bookmark',
                              style: GoogleFonts.poppins(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 3. BOOKMARK CONTENT
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 150.0, vertical: 60.0),
              constraints: const BoxConstraints(minHeight: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Section Kecil
                  Text(
                    'Bookmark',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: const Color(0xFF82B1FF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Divider(color: Colors.grey[300], thickness: 1),
                  const SizedBox(height: 40),

                  // BUTTONS ACTION ROW
                  Row(
                    children: [
                      // Tombol Choose (Biru)
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF82B1FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4), // Kotak agak bulat
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          elevation: 0,
                        ),
                        child: Text(
                          'Choose',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Tombol Delete All (Merah)
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF685B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          elevation: 0,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Delete All',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(Icons.delete, color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Dropdown Show Destinations
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF82B1FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Show Destinations',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_drop_down, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Header | All Destination
                  Row(
                    children: [
                      Container(width: 4, height: 28, color: Colors.black),
                      const SizedBox(width: 10),
                      Text(
                        'All Destination',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // GRID BOOKMARKS
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.4,
                    ),
                    itemCount: _bookmarkedItems.length,
                    itemBuilder: (context, index) {
                      final item = _bookmarkedItems[index];
                      return _buildBookmarkCard(
                        title: item['title']!,
                        desc: item['desc']!,
                        imageUrl: item['image']!,
                      );
                    },
                  ),
                ],
              ),
            ),

            // 4. FOOTER
            FooterSection(onScrollToTop: () {}),
          ],
        ),
      ),
    );
  }

  // Helper Widget untuk Card
  Widget _buildBookmarkCard({required String title, required String desc, required String imageUrl}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: Stack(
        children: [
          // Gradient
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
                stops: const [0.5, 1.0],
              ),
            ),
          ),
          // Teks
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Badge Adventure
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF82B1FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Adventure',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- CUSTOM NAVBAR KHUSUS LOGGED IN (TANPA TOMBOL LOGIN) ---
class NavBarLoggedIn extends StatefulWidget {
  final int selectedIndex;
  const NavBarLoggedIn({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  State<NavBarLoggedIn> createState() => _NavBarLoggedInState();
}

class _NavBarLoggedInState extends State<NavBarLoggedIn> with SingleTickerProviderStateMixin {
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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20), 
      color: Colors.white,
      height: 90, 
      child: Stack(
        children: [
          // 1. KIRI: LOGO
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 100.0),
              child: InkWell(
                onTap: () {
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
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

          // 2. TENGAH: MENU (Absolute Center)
          Align(
            alignment: Alignment.center,
            child: Theme(
              data: ThemeData(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: SizedBox(
                width: 500, 
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

          // 3. KANAN: TOMBOL (HANYA CHAT, LOGIN DIHILANGKAN)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 100.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}