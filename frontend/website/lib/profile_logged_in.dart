import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart'; // Mengimpor HomePage dari main.dart

// FUNGSI MAIN AGAR BISA DI-RUN SENDIRIAN
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Profile',
    home: ProfileLoggedInPage(),
  ));
}

class ProfileLoggedInPage extends StatelessWidget {
  const ProfileLoggedInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. NAVIGATION BAR (KHUSUS LOGGED IN)
            // Menggunakan NavBarLoggedIn yang tombol loginnya sudah dihapus
            const NavBarLoggedIn(selectedIndex: 3),

            // 2. HERO SECTION
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Gambar Background (Temple/Gunung)
                  Image.network(
                    'https://images.unsplash.com/photo-1577717903315-1691ae25ab3f?q=80&w=1200&auto=format&fit=crop', 
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
                              'Profile',
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

            // 3. PROFILE CONTENT
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 150.0, vertical: 60.0),
              constraints: const BoxConstraints(minHeight: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Section
                  Text(
                    'Profile',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: const Color(0xFF82B1FF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Divider(color: Colors.grey[300], thickness: 1),
                  const SizedBox(height: 40),

                  // User Info
                  Text(
                    'Hallo,',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Riyo Sumedang',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'riyookkkkkk@gmail.com',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // BUTTONS SECTION
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Edit Name Button
                      _buildProfileButton(
                        icon: Icons.edit_outlined,
                        text: 'Edit name',
                        onTap: () {},
                      ),
                      
                      const SizedBox(height: 20),

                      // Change Password Button
                      _buildProfileButton(
                        icon: Icons.lock_outline,
                        text: 'Change password',
                        onTap: () {},
                      ),

                      const SizedBox(height: 40),

                      // Log Out Button (Red)
                      SizedBox(
                        width: 300,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            // Logika Logout dummy
                            print("User logged out");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF685B), // Warna Merah
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Log out',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.logout, color: Colors.white), // Icon di kanan
                            ],
                          ),
                        ),
                      ),
                    ],
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

  // Widget Helper untuk tombol putih (Edit name & Change password)
  Widget _buildProfileButton({required IconData icon, required String text, required VoidCallback onTap}) {
    return Container(
      width: 300,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Icon(icon, color: Colors.black87),
                const SizedBox(width: 15),
                Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
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
    // Navigasi sederhana untuk demo
    if (index == 0) { 
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    } 
    // Tab lain dibiarkan kosong untuk demo tampilan logged in ini
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
                  // TOMBOL LOGIN DIHAPUS DARI SINI
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}