import 'package:admin_website/layout/sidebar.dart';
import 'package:admin_website/pages/auth/login.dart';
import 'package:admin_website/pages/content/category.dart';
import 'package:admin_website/pages/content/destination.dart';
import 'package:admin_website/pages/content/event.dart';
import 'package:admin_website/pages/content/facility.dart';
import 'package:admin_website/pages/content/overview.dart';
import 'package:admin_website/pages/content/package.dart';
import 'package:admin_website/pages/content/review.dart';
import 'package:admin_website/pages/content/sos.dart';
import 'package:admin_website/pages/content/user.dart';
import 'package:admin_website/services/auth_service.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter(AuthService authService) {
  return GoRouter(
    redirect: (context, state) {
      final loggedIn = authService.isLoggedIn;
      final loggingIn = state.matchedLocation == '/login';

      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, content) => Sidebar(content: content),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const OverviewPage()),
          GoRoute(path: '/destination', builder: (context, state) => const DestinationPage()),
          GoRoute(path: '/event', builder: (context, state) => const EventPage()),
          GoRoute(path: '/package', builder: (context, state) => const PackagePage()),
          GoRoute(path: '/category', builder: (context, state) => const CategoryPage()),
          GoRoute(path: '/review', builder: (context, state) => const ReviewPage()),
          GoRoute(path: '/user', builder: (context, state) => const UserPage()),
          GoRoute(path: '/sos', builder: (context, state) => const SosPage()),
          GoRoute(path: '/facility', builder: (context, state) => const FacilityPage()),
        ],
      ),
    ],
  );
}