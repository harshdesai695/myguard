import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:myguard_frontend/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:myguard_frontend/features/auth/presentation/screens/login_screen.dart';
import 'package:myguard_frontend/features/auth/presentation/screens/register_screen.dart';
import 'package:myguard_frontend/features/auth/presentation/screens/resident_home_screen.dart';
import 'package:myguard_frontend/features/auth/presentation/screens/splash_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/admin_home_screen.dart';
import 'package:myguard_frontend/features/guard/presentation/screens/guard_home_screen.dart';
import 'package:myguard_frontend/features/visitor/presentation/bloc/visitor_bloc.dart';
import 'package:myguard_frontend/features/visitor/presentation/screens/visitor_history_screen.dart';
import 'package:myguard_frontend/features/visitor/presentation/screens/visitor_pre_approve_screen.dart';
import 'package:myguard_frontend/injection.dart';

class AppRouter {
  AppRouter._();

  static GoRouter router(AuthBloc authBloc) => GoRouter(
        initialLocation: '/',
        debugLogDiagnostics: true,
        redirect: (context, state) {
          final authState = authBloc.state;
          final isAuthRoute = state.matchedLocation.startsWith('/auth');
          final isSplash = state.matchedLocation == '/';

          if (isSplash) return null;

          if (authState is AuthUnauthenticated && !isAuthRoute) {
            return '/auth/login';
          }
          if (authState is AuthAuthenticated && isAuthRoute) {
            return _homeRouteForRole(authState.user.role);
          }

          return null;
        },
        routes: [
          GoRoute(path: '/', builder: (_, __) => const SplashScreen()),

          // Auth
          GoRoute(path: '/auth/login', builder: (_, __) => const LoginScreen()),
          GoRoute(path: '/auth/register', builder: (_, __) => const RegisterScreen()),
          GoRoute(path: '/auth/forgot-password', builder: (_, __) => const ForgotPasswordScreen()),

          // Resident Shell
          ShellRoute(
            builder: (context, state, child) => _ResidentShell(child: child),
            routes: [
              GoRoute(path: '/resident', builder: (_, __) => const ResidentHomeScreen()),
              GoRoute(path: '/resident/gate', builder: (_, __) => BlocProvider(create: (_) => sl<VisitorBloc>(), child: const VisitorHistoryScreen())),
              GoRoute(path: '/resident/services', builder: (_, __) => const _PlaceholderScreen(title: 'Services')),
              GoRoute(path: '/resident/community', builder: (_, __) => const _PlaceholderScreen(title: 'Community')),
              GoRoute(path: '/resident/profile', builder: (_, __) => const _PlaceholderScreen(title: 'Profile')),
            ],
          ),

          // Resident sub-routes
          GoRoute(path: '/resident/visitor/pre-approve', builder: (_, __) => BlocProvider(create: (_) => sl<VisitorBloc>(), child: const VisitorPreApproveScreen())),
          GoRoute(path: '/resident/visitor/:id', builder: (_, state) => _PlaceholderScreen(title: 'Visitor ${state.pathParameters['id']}')),
          GoRoute(path: '/resident/daily-help', builder: (_, __) => const _PlaceholderScreen(title: 'Daily Helps')),
          GoRoute(path: '/resident/amenities', builder: (_, __) => const _PlaceholderScreen(title: 'Amenities')),
          GoRoute(path: '/resident/helpdesk', builder: (_, __) => const _PlaceholderScreen(title: 'Helpdesk')),
          GoRoute(path: '/resident/notices', builder: (_, __) => const _PlaceholderScreen(title: 'Notices')),
          GoRoute(path: '/resident/polls', builder: (_, __) => const _PlaceholderScreen(title: 'Polls')),
          GoRoute(path: '/resident/vehicles', builder: (_, __) => const _PlaceholderScreen(title: 'Vehicles')),
          GoRoute(path: '/resident/marketplace', builder: (_, __) => const _PlaceholderScreen(title: 'Marketplace')),
          GoRoute(path: '/resident/pets', builder: (_, __) => const _PlaceholderScreen(title: 'Pets')),
          GoRoute(path: '/resident/emergency', builder: (_, __) => const _PlaceholderScreen(title: 'Emergency')),
          GoRoute(path: '/resident/emergency/panic', builder: (_, __) => const _PlaceholderScreen(title: 'Panic')),
          GoRoute(path: '/resident/material-gatepass', builder: (_, __) => const _PlaceholderScreen(title: 'Material Gatepass')),
          GoRoute(path: '/resident/documents', builder: (_, __) => const _PlaceholderScreen(title: 'Documents')),

          // Guard Shell
          ShellRoute(
            builder: (context, state, child) => _GuardShell(child: child),
            routes: [
              GoRoute(path: '/guard', builder: (_, __) => const GuardHomeScreen()),
              GoRoute(path: '/guard/gate', builder: (_, __) => const _PlaceholderScreen(title: 'Gate')),
              GoRoute(path: '/guard/patrol', builder: (_, __) => const _PlaceholderScreen(title: 'Patrol')),
              GoRoute(path: '/guard/alerts', builder: (_, __) => const _PlaceholderScreen(title: 'Alerts')),
              GoRoute(path: '/guard/profile', builder: (_, __) => const _PlaceholderScreen(title: 'Profile')),
            ],
          ),

          // Admin Shell
          ShellRoute(
            builder: (context, state, child) => _AdminShell(child: child),
            routes: [
              GoRoute(path: '/admin', builder: (_, __) => const AdminHomeScreen()),
              GoRoute(path: '/admin/manage', builder: (_, __) => const _PlaceholderScreen(title: 'Manage')),
              GoRoute(path: '/admin/reports', builder: (_, __) => const _PlaceholderScreen(title: 'Reports')),
              GoRoute(path: '/admin/settings', builder: (_, __) => const _PlaceholderScreen(title: 'Settings')),
              GoRoute(path: '/admin/profile', builder: (_, __) => const _PlaceholderScreen(title: 'Profile')),
            ],
          ),
        ],
      );

  static String _homeRouteForRole(String role) {
    switch (role) {
      case 'ROLE_ADMIN':
        return '/admin';
      case 'ROLE_GUARD':
        return '/guard';
      default:
        return '/resident';
    }
  }
}

// Shell widgets with bottom navigation
class _ResidentShell extends StatelessWidget {
  const _ResidentShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.door_front_door_outlined), selectedIcon: Icon(Icons.door_front_door), label: 'Gate'),
          NavigationDestination(icon: Icon(Icons.build_outlined), selectedIcon: Icon(Icons.build), label: 'Services'),
          NavigationDestination(icon: Icon(Icons.forum_outlined), selectedIcon: Icon(Icons.forum), label: 'Community'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/resident/gate')) return 1;
    if (location.startsWith('/resident/services')) return 2;
    if (location.startsWith('/resident/community')) return 3;
    if (location.startsWith('/resident/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0: context.go('/resident');
      case 1: context.go('/resident/gate');
      case 2: context.go('/resident/services');
      case 3: context.go('/resident/community');
      case 4: context.go('/resident/profile');
    }
  }
}

class _GuardShell extends StatelessWidget {
  const _GuardShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.door_front_door_outlined), selectedIcon: Icon(Icons.door_front_door), label: 'Gate'),
          NavigationDestination(icon: Icon(Icons.shield_outlined), selectedIcon: Icon(Icons.shield), label: 'Patrol'),
          NavigationDestination(icon: Icon(Icons.warning_amber_outlined), selectedIcon: Icon(Icons.warning_amber), label: 'Alerts'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/guard/gate')) return 1;
    if (location.startsWith('/guard/patrol')) return 2;
    if (location.startsWith('/guard/alerts')) return 3;
    if (location.startsWith('/guard/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0: context.go('/guard');
      case 1: context.go('/guard/gate');
      case 2: context.go('/guard/patrol');
      case 3: context.go('/guard/alerts');
      case 4: context.go('/guard/profile');
    }
  }
}

class _AdminShell extends StatelessWidget {
  const _AdminShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.manage_accounts_outlined), selectedIcon: Icon(Icons.manage_accounts), label: 'Manage'),
          NavigationDestination(icon: Icon(Icons.analytics_outlined), selectedIcon: Icon(Icons.analytics), label: 'Reports'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/admin/manage')) return 1;
    if (location.startsWith('/admin/reports')) return 2;
    if (location.startsWith('/admin/settings')) return 3;
    if (location.startsWith('/admin/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0: context.go('/admin');
      case 1: context.go('/admin/manage');
      case 2: context.go('/admin/reports');
      case 3: context.go('/admin/settings');
      case 4: context.go('/admin/profile');
    }
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text(title, style: Theme.of(context).textTheme.headlineMedium)),
  );
}
