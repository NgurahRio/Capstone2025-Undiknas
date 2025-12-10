import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart'; // Wajib tambah package flutter_map
import 'package:latlong2/latlong.dart' as latLng; // Wajib tambah package latlong2
import 'main.dart'; // Mengimpor NavBar dan FooterSection dari main.dart

class DestinationPage extends StatefulWidget {
  const DestinationPage({Key? key}) : super(key: key);

  @override
  State<DestinationPage> createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  // Daftar URL gambar untuk galeri utama
  final List<String> _galleryImages = [
    'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?q=80&w=1200&auto=format&fit=crop', // Monyet 1
    'https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?q=80&w=1200&auto=format&fit=crop', // Monyet 2
    'https://images.unsplash.com/photo-1516483638261-f4dbaf036963?q=80&w=1200&auto=format&fit=crop', // Monyet 3 / Hutan
  ];

  // Data Dummy untuk Rekomendasi
  final List<Map<String, String>> _recommendations = [
    {
      'title': 'Monkey Forest Ubud',
      'desc': 'Protected forest with free-roaming monkeys.',
      'image': 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?q=80&w=600&auto=format&fit=crop'
    },
    {
      'title': 'Jungle Trekking',
      'desc': 'Explore the lush greenery of Bali.',
      'image': 'https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?q=80&w=600&auto=format&fit=crop'
    },
    {
      'title': 'Jeep Adventure',
      'desc': 'Off-road experience in Mount Batur.',
      'image': 'https://images.unsplash.com/photo-1533587851505-d119e13fa0d7?q=80&w=600&auto=format&fit=crop'
    },
    {
      'title': 'Cycling Tour',
      'desc': 'Ride through rice terraces and villages.',
      'image': 'https://images.unsplash.com/photo-1541625602330-2277a4c46182?q=80&w=600&auto=format&fit=crop'
    },
    {
      'title': 'Night Safari',
      'desc': 'Experience wildlife at night.',
      'image': 'https://images.unsplash.com/photo-1534567153574-2b12153a87f0?q=80&w=600&auto=format&fit=crop'
    },
    {
      'title': 'Bali Safari',
      'desc': 'Meet the wild animals of Indonesia.',
      'image': 'https://images.unsplash.com/photo-1575550959106-5a7defe28b56?q=80&w=600&auto=format&fit=crop'
    },
    {
      'title': 'Besakih Temple',
      'desc': 'The mother temple of Bali.',
      'image': 'https://images.unsplash.com/photo-1555400038-63f5ba517a47?q=80&w=600&auto=format&fit=crop'
    },
    {
      'title': 'Hidden Canyon',
      'desc': 'Secret nature spot for adventurers.',
      'image': 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=600&auto=format&fit=crop'
    },
  ];

  int _currentImageIndex = 0;
  int _selectedTicketIndex = 0; // 0: Solo, 1: Romantic, 2: Group, 3: Family

  // Fungsi untuk kembali ke gambar sebelumnya
  void _previousImage() {
    setState(() {
      if (_currentImageIndex > 0) {
        _currentImageIndex--;
      } else {
        _currentImageIndex = _galleryImages.length - 1; // Loop ke gambar terakhir
      }
    });
  }

  // Fungsi untuk lanjut ke gambar berikutnya
  void _nextImage() {
    setState(() {
      if (_currentImageIndex < _galleryImages.length - 1) {
        _currentImageIndex++;
      } else {
        _currentImageIndex = 0; // Loop kembali ke awal
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. NAVIGATION BAR
            const NavBar(selectedIndex: 0),

            // 2. HERO SECTION (GAMBAR ATAS)
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
                              'Destination',
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

            // 3. CONTENT SECTION UTAMA
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 150.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Breadcrumbs
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Home',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: const Color(0xFF82B1FF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        ' > ',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Destination',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Divider(color: Colors.grey[300], thickness: 1),
                  const SizedBox(height: 40),

                  // GAMBAR GALERI
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: ClipRRect(
                      key: ValueKey<int>(_currentImageIndex),
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        _galleryImages[_currentImageIndex],
                        width: double.infinity,
                        height: 500,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),

                  // NAVIGASI GALERI
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: _previousImage,
                        borderRadius: BorderRadius.circular(30),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFF82B1FF), width: 2),
                              ),
                              child: const Icon(Icons.arrow_back, color: Color(0xFF82B1FF)),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              'Back',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                      InkWell(
                        onTap: _nextImage,
                        borderRadius: BorderRadius.circular(30),
                        child: Row(
                          children: [
                            Text(
                              'Next',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFF82B1FF), width: 2),
                              ),
                              child: const Icon(Icons.arrow_forward, color: Color(0xFF82B1FF)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 80),

                  // --- DETAIL DESKRIPSI (Layout 2 Kolom) ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // KOLOM KIRI (Info, Fasilitas, Tiket)
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Judul & Bookmark
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Monkey Forest Ubud',
                                  style: GoogleFonts.poppins(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const Icon(Icons.bookmark, color: Color(0xFF82B1FF), size: 40),
                              ],
                            ),
                            // Lokasi
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.grey, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'JL. Monkey Forest, Ubud, Gianyar, Bali',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Deskripsi Teks
                            Text(
                              'Discover the sacred Monkey Forest in Ubud, where hundreds of playful monkeys live freely among ancient temples and lush jungle.',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Tags Buttons
                            Row(
                              children: [
                                _buildTagButton('Adventure'),
                                const SizedBox(width: 10),
                                _buildTagButton('Spiritual'),
                              ],
                            ),

                            const SizedBox(height: 40),

                            // Section Facilities
                            Text(
                              'Facilities',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildFacilityIcon(Icons.photo_camera_outlined, 'Photo area'),
                                _buildFacilityIcon(Icons.local_parking_outlined, 'Parking'),
                                _buildFacilityIcon(Icons.wc_outlined, 'Toilet'),
                                _buildFacilityIcon(Icons.person_outline, 'Local guide'),
                                _buildFacilityIcon(Icons.storefront_outlined, 'Souvenir shop'),
                                _buildFacilityIcon(Icons.accessible_forward, 'Wheelchair access'),
                              ],
                            ),

                            const SizedBox(height: 40),

                            // Section Available Ticket
                            Text(
                              'Available Ticket',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Ticket Tabs
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildTicketTab(0, 'Solo Trip', Icons.person),
                                  const SizedBox(width: 10),
                                  _buildTicketTab(1, 'Romantic Getaway', Icons.favorite),
                                  const SizedBox(width: 10),
                                  _buildTicketTab(2, 'Group Tour', Icons.groups),
                                  const SizedBox(width: 10),
                                  _buildTicketTab(3, 'Family Package', Icons.family_restroom),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Safety Buttons
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFEF685B), // Warna merah SOS
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  ),
                                  child: Text('SOS', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF82B1FF),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    ),
                                    child: Text('Do & Don\'t', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF82B1FF),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    ),
                                    child: Text('Safety Guidelines', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            
                            // Ticket Detail Card
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 5),
                                  )
                                ],
                                border: Border.all(color: Colors.grey.shade100),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getTicketTitle(_selectedTicketIndex), // Dynamic Title
                                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 15),
                                  Text('Includes:', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
                                  const SizedBox(height: 10),
                                  _buildListItem(Icons.login, 'Entrance fee'),
                                  _buildListItem(Icons.checkroom, 'Traditional Balinese attire (sarong & sash) for temple visit'),
                                  _buildListItem(Icons.local_parking, 'Free Parking Lot'),
                                  const SizedBox(height: 15),
                                  Text('Not Included', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFFEF685B))),
                                  const SizedBox(height: 10),
                                  _buildListItem(Icons.directions_car_filled_outlined, 'Pickup / Drop-off to the destination', isIncluded: false),
                                  _buildListItem(Icons.hotel_outlined, 'Accommodation / additional lodging', isIncluded: false),
                                  const SizedBox(height: 20),
                                  const Divider(),
                                  const SizedBox(height: 10),
                                  Text(
                                    'IDR. 80.000',
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFEBC136), // Warna kuning emas
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 60), // Spacer antar kolom

                      // KOLOM KANAN (Peta & Review)
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            // Map Card
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 200,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: FlutterMap(
                                        options: MapOptions(
                                          initialCenter: const latLng.LatLng(-8.51914, 115.26319), // Koordinat Monkey Forest Ubud
                                          initialZoom: 15.0,
                                          interactionOptions: const InteractionOptions(
                                            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                                          ),
                                        ),
                                        children: [
                                          TileLayer(
                                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                            userAgentPackageName: 'com.travora.app',
                                          ),
                                          MarkerLayer(
                                            markers: [
                                              Marker(
                                                point: const latLng.LatLng(-8.51914, 115.26319),
                                                width: 40,
                                                height: 40,
                                                child: const Icon(
                                                  Icons.location_on,
                                                  color: Colors.red,
                                                  size: 40,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey[300],
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: Text('View on Google Maps', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 40),

                            // Reviews Card
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Reviews',
                                    style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '4.9',
                                    style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold, color: const Color(0xFFEBC136)),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(5, (index) => const Icon(Icons.star, color: Color(0xFFEBC136), size: 20)),
                                  ),
                                  const SizedBox(height: 5),
                                  Text('Based on 5 reviews', style: GoogleFonts.poppins(color: Colors.grey)),
                                  const SizedBox(height: 20),
                                  const Divider(),
                                  // List Review Static
                                  _buildReviewItem('Riyo Sumedang (you)', 'saya sangat merekomendasikan tempat ini.', '1 hari lalu'),
                                  _buildReviewItem('Nielsun', 'Tempat yang indah', '1 hari lalu'),
                                  _buildReviewItem('Enok kumalo', 'Amazinggg !', '1 hari lalu'),
                                  _buildReviewItem('Chrisstian', 'A lush forest with free-roaming monkeys...', '1 hari lalu'),
                                  _buildReviewItem('Wahyuzz', 'Tempat ni sangat bagus untuk wisata bareng pasangan', '1 hari lalu'),
                                  
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Review the place',
                                            hintStyle: GoogleFonts.poppins(fontSize: 12),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                            filled: true,
                                            fillColor: Colors.grey[100],
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0)
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(color: Color(0xFF82B1FF)),
                                          elevation: 0,
                                        ),
                                        child: Text('Kirim', style: GoogleFonts.poppins(color: const Color(0xFF82B1FF))),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                
                  const SizedBox(height: 80),

                  // --- BAGIAN BARU: ALL DESTINATION (RECOMMENDATIONS) ---
                  Row(
                    children: [
                      Container(width: 4, height: 28, color: Colors.black),
                      const SizedBox(width: 10),
                      Text('All Destination', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
                    ],
                  ),
                  const SizedBox(height: 40),
                  
                  // GRID REKOMENDASI (2 KOLOM)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // Agar scroll mengikuti parent
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.4, // Menyesuaikan rasio gambar card
                    ),
                    itemCount: _recommendations.length,
                    itemBuilder: (context, index) {
                      final item = _recommendations[index];
                      return _buildRecommendationCard(
                        context,
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

  // --- WIDGET BUILDERS HELPER ---
  
  // Widget untuk Card Rekomendasi
  Widget _buildRecommendationCard(BuildContext context, {required String title, required String desc, required String imageUrl}) {
    return GestureDetector(
      onTap: () {
        // Navigasi Push ke Halaman Destination Baru (Reload)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DestinationPage()),
        );
      },
      child: Container(
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
            // Gradient Overlay agar teks terbaca
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
            // Teks Konten
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
      ),
    );
  }

  Widget _buildTagButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF82B1FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFacilityIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.black87),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.poppins(fontSize: 12)),
      ],
    );
  }

  Widget _buildTicketTab(int index, String title, IconData icon) {
    bool isSelected = _selectedTicketIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTicketIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          border: Border.all(color: isSelected ? const Color(0xFF82B1FF) : Colors.grey.shade300, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF82B1FF) : Colors.grey, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(IconData icon, String text, {bool isIncluded = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: isIncluded ? const Color(0xFF82B1FF) : const Color(0xFFEF685B)),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 14, color: isIncluded ? Colors.black54 : const Color(0xFFEF685B)))),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, String comment, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12)),
              Text(time, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
            ],
          ),
          Row(children: List.generate(5, (index) => const Icon(Icons.star, size: 10, color: Color(0xFFEBC136)))),
          const SizedBox(height: 4),
          Text(comment, style: GoogleFonts.poppins(fontSize: 11, color: Colors.black87)),
        ],
      ),
    );
  }
  
  String _getTicketTitle(int index) {
    switch (index) {
      case 0: return 'Solo Trip';
      case 1: return 'Romantic Getaway';
      case 2: return 'Group Tour';
      case 3: return 'Family Package';
      default: return 'Ticket';
    }
  }
}