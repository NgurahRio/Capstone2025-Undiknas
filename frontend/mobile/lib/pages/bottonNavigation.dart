import 'package:flutter/material.dart';
import 'package:mobile/pages/bookmark.dart';
import 'package:mobile/pages/dashboard.dart';
import 'package:mobile/pages/event.dart';
import 'package:mobile/pages/profile.dart';

class BottonNavigation extends StatefulWidget {
  const BottonNavigation({super.key});

  @override
  State<BottonNavigation> createState() => _BottonNavigationState();
}

class _BottonNavigationState extends State<BottonNavigation> {
  int _selectedIndex = 0;
  List<Widget> get screens => [
    Dashboard(),
    EventPage(),
    BookmarkPage(),
    ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget itemsNavigation({required IconData icon, required int selectedIndex}) {
    return  Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: _selectedIndex == selectedIndex ? [Color(0xff8AC4FA), Color(0xFF6189af)] : [const Color.fromARGB(255, 232, 231, 231), const Color.fromARGB(255, 232, 231, 231)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: IconButton(
        icon: Icon(
          icon, 
          color: _selectedIndex == selectedIndex ? Colors.white : const Color.fromARGB(255, 146, 146, 146),
          size: 35,
        ),
        onPressed: () => _onItemTapped(selectedIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: screens,
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  itemsNavigation(icon: Icons.home, selectedIndex: 0),
                  
                  itemsNavigation(icon: Icons.calendar_today_rounded, selectedIndex: 1),
                  
                  itemsNavigation(icon: Icons.bookmark, selectedIndex: 2),
                  
                  itemsNavigation(icon: Icons.person, selectedIndex: 3)
                ],
              ),
            ),
          
          )
        ],
      ),
    );
  }
}