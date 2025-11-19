import 'package:admin_website/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatefulWidget {
  final Widget content;

  const Sidebar({super.key, required this.content});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool hoverLogout = false;

  void _handleLogout() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.logout();
    context.go('/login');
  }

  Widget _listTileCostum({
    required String title,
    required String route,
  }) {
    final currentPath = GoRouterState.of(context).matchedLocation;
    final bool isSelected = currentPath == route;

    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -4),
      title: Text(title),
      titleTextStyle: const TextStyle(fontSize: 15),
      selected: isSelected,
      selectedColor: const Color(0xFF8AC4FA),
      onTap: () {
        if (!isSelected) context.go(route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 2),
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.25),
                  blurRadius: 2,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      textAlign: TextAlign.center,
                      "Travora Admin",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        children: [
                          _listTileCostum(
                            title: "Overview", 
                            route: '/'
                          ),
                          _listTileCostum(
                            title: "Destinations", 
                            route: '/destination'
                          ),
                          _listTileCostum(
                            title: "Events",
                            route: '/event'
                            ),
                          _listTileCostum(
                            title: "Packages", 
                            route: '/package'
                          ),
                          _listTileCostum(
                            title: "Categories", 
                            route: '/category'
                          ),
                          _listTileCostum(
                            title: "Reviews", 
                            route: '/review'
                          ),
                          _listTileCostum(
                            title: "Users", 
                            route: '/user'
                          ),
                          _listTileCostum(
                            title: "SOS", 
                            route: '/sos'
                          ),
                          _listTileCostum(
                            title: "Facilities", 
                            route: '/facility'
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => _handleLogout(),
                        onHover: (value) {
                          setState(() => hoverLogout = value);
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          backgroundColor: hoverLogout
                              ? const Color(0xFFE06666)
                              : const Color(0xFFFF8484),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          children: [
                            Text("Logout", style: TextStyle(fontSize: 13)),
                            Icon(Icons.logout, size: 16),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          Expanded(
            child: widget.content,
          )
        ],
      ),
    );
  }
}
