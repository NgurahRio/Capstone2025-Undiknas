import 'package:flutter/material.dart';
import 'package:mobile/models/user_model.dart';
import 'package:mobile/pages/LandingPage/firstPage.dart';
import 'package:mobile/pages/bottonNavigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimationFirst extends StatefulWidget {
  const AnimationFirst({super.key});

  @override
  State<AnimationFirst> createState() => _AnimationFirstState();
}

class _AnimationFirstState extends State<AnimationFirst>
    with TickerProviderStateMixin {
  bool showLogo = false;
  bool showOval = true;
  bool showName = false;
  Offset logoOffset = const Offset(0, 0.7);
  double logoScale = 1.8;
  late AnimationController _revealController;
  late AnimationController _changesPages;

  @override
  void initState() {
    super.initState();

    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _changesPages = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Logo muncul dari bawah
    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        showLogo = true;
        logoOffset = const Offset(0, -1);
        logoScale = 1.8;
      });
    });

    // Logo naik ke tengah
    Future.delayed(const Duration(milliseconds: 1750), () {
      setState(() {
        logoOffset = const Offset(0, 0);
        logoScale = 1.4;
      });
    });

    // Oval hilang
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        showOval = false;
      });
    });

    // Logo geser ke kiri
    Future.delayed(const Duration(milliseconds: 3200), () {
      setState(() {
        logoOffset = const Offset(-1.5, 0);
      });
    });

    // Nama muncul (reveal dari kiri ke kanan)
    Future.delayed(const Duration(milliseconds: 4500), () {
      setState(() {
        showName = true;
      });
      _revealController.forward();
    });

    Future.delayed(const Duration(milliseconds: 5700), () async {
      _changesPages.forward();

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (!mounted) return;

      if (userId != null) {
        try {
          final user = users.firstWhere((u) => u.id_user == userId);
          User.currentUser = user;
          Navigator.of(context).pushReplacement(_createSmoothFadeRoute(
            BottonNavigation(currentUser: user,)
          ));
        } catch (_) {
          Navigator.of(context).pushReplacement(_createSmoothFadeRoute(const FirstPage()));
        }
      } else {
        Navigator.of(context).pushReplacement(_createSmoothFadeRoute(const FirstPage()));
      }
    });
  }

  Route _createSmoothFadeRoute(Widget nextPage) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 1000),
      pageBuilder: (context, animation, secondaryAnimation) => nextPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
        return FadeTransition(
          opacity: curved,
          child: child,
        );
      },
    );
  }

  @override
  void dispose() {
    _revealController.dispose();
    _changesPages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFF),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Oval
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: showOval ? 1 : 0,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 600),
                  scale: showOval ? 1 : 0.8,
                  child: ClipOval(
                    child: Container(
                      width: 200,
                      height: 60,
                      color: const Color.fromARGB(76, 138, 196, 250),
                    ),
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: Transform.translate(
                offset: const Offset(0, -10),
                child: AnimatedSlide(
                  offset: logoOffset,
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOutBack,
                  child: AnimatedScale(
                    scale: logoScale,
                    duration: const Duration(milliseconds: 1000),
                    child: AnimatedOpacity(
                      opacity: showLogo ? 1 : 0,
                      duration: const Duration(milliseconds: 800),
                      child: Image.asset(
                        'assets/logo.png',
                        width: 90,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            if (showName)
              AnimatedBuilder(
                animation: _revealController,
                builder: (context, child) {
                  final screen = MediaQuery.of(context).size;
                  return Padding(
                    padding: EdgeInsets.only(left: screen.width * 0.22),
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: [
                            _revealController.value,
                            _revealController.value
                          ],
                          colors: const [
                            Colors.transparent,
                            Colors.white,
                          ],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.dstOut,
                      child: Image.asset(
                        'assets/name.png',
                        scale: 0.8,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
