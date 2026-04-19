import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/features/amenity/presentation/bloc/amenity_bloc.dart';
import 'package:myguard_frontend/features/amenity/presentation/screens/amenity_list_screen.dart';
import 'package:myguard_frontend/features/amenity/presentation/screens/amenity_detail_screen.dart';
import 'package:myguard_frontend/features/amenity/presentation/screens/amenity_booking_screen.dart';
import 'package:myguard_frontend/features/amenity/presentation/screens/my_bookings_screen.dart';
import 'package:myguard_frontend/features/amenity/presentation/screens/booking_detail_screen.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/user_management_cubit.dart';
import 'package:myguard_frontend/features/auth/presentation/screens/community_screen.dart';
import 'package:myguard_frontend/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:myguard_frontend/features/auth/presentation/screens/login_screen.dart';
import 'package:myguard_frontend/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:myguard_frontend/features/auth/presentation/screens/profile_screen.dart';
import 'package:myguard_frontend/features/auth/presentation/screens/register_screen.dart';
import 'package:myguard_frontend/features/auth/presentation/screens/resident_home_screen.dart';
import 'package:myguard_frontend/features/auth/presentation/screens/services_screen.dart';
import 'package:myguard_frontend/features/auth/presentation/screens/splash_screen.dart';
import 'package:myguard_frontend/features/communication/presentation/bloc/notice_cubit.dart';
import 'package:myguard_frontend/features/communication/presentation/bloc/poll_bloc.dart';
import 'package:myguard_frontend/features/communication/presentation/bloc/community_group_cubit.dart';
import 'package:myguard_frontend/features/communication/presentation/bloc/document_cubit.dart';
import 'package:myguard_frontend/features/dashboard/presentation/bloc/dashboard_cubit.dart';
import 'package:myguard_frontend/features/communication/presentation/screens/documents_screen.dart';
import 'package:myguard_frontend/features/communication/presentation/screens/notice_board_screen.dart';
import 'package:myguard_frontend/features/communication/presentation/screens/notice_detail_screen.dart';
import 'package:myguard_frontend/features/communication/presentation/screens/notice_create_screen.dart';
import 'package:myguard_frontend/features/communication/presentation/screens/poll_list_screen.dart';
import 'package:myguard_frontend/features/communication/presentation/screens/poll_vote_screen.dart';
import 'package:myguard_frontend/features/communication/presentation/screens/poll_create_screen.dart';
import 'package:myguard_frontend/features/communication/presentation/screens/community_group_list_screen.dart';
import 'package:myguard_frontend/features/communication/presentation/screens/community_chat_screen.dart';
import 'package:myguard_frontend/features/communication/presentation/screens/document_upload_screen.dart';
import 'package:myguard_frontend/features/dailyhelp/presentation/bloc/dailyhelp_cubit.dart';
import 'package:myguard_frontend/features/dailyhelp/presentation/screens/daily_help_list_screen.dart';
import 'package:myguard_frontend/features/dailyhelp/presentation/screens/daily_help_detail_screen.dart';
import 'package:myguard_frontend/features/dailyhelp/presentation/screens/daily_help_register_screen.dart';
import 'package:myguard_frontend/features/dailyhelp/presentation/screens/daily_help_check_in_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/admin_home_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/admin_manage_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/admin_reports_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/admin_settings_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/society_management_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/flat_management_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/user_management_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/user_detail_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/visitor_reports_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/guard_management_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/guard_shift_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/guard_patrol_report_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/notice_management_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/poll_management_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/amenity_management_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/booking_management_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/helpdesk_management_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/helpdesk_reports_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/vehicle_management_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/material_gatepass_management_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/emergency_contact_management_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/document_management_screen.dart';
import 'package:myguard_frontend/features/dashboard/presentation/screens/move_in_out_screen.dart';
import 'package:myguard_frontend/features/emergency/presentation/bloc/emergency_cubit.dart';
import 'package:myguard_frontend/features/emergency/presentation/screens/emergency_contacts_screen.dart';
import 'package:myguard_frontend/features/emergency/presentation/screens/panic_button_screen.dart';
import 'package:myguard_frontend/features/emergency/presentation/screens/child_alerts_screen.dart';
import 'package:myguard_frontend/features/guard/presentation/bloc/patrol_cubit.dart';
import 'package:myguard_frontend/features/guard/presentation/screens/guard_home_screen.dart';
import 'package:myguard_frontend/features/guard/presentation/screens/patrol_screen.dart';
import 'package:myguard_frontend/features/guard/presentation/screens/patrol_checkpoint_scan_screen.dart';
import 'package:myguard_frontend/features/guard/presentation/screens/panic_alerts_screen.dart';
import 'package:myguard_frontend/features/guard/presentation/screens/e_intercom_screen.dart';
import 'package:myguard_frontend/features/society/presentation/bloc/society_bloc.dart';
import 'package:myguard_frontend/features/helpdesk/presentation/bloc/helpdesk_bloc.dart';
import 'package:myguard_frontend/features/helpdesk/presentation/screens/helpdesk_ticket_list_screen.dart';
import 'package:myguard_frontend/features/helpdesk/presentation/screens/helpdesk_create_ticket_screen.dart';
import 'package:myguard_frontend/features/helpdesk/presentation/screens/helpdesk_ticket_detail_screen.dart';
import 'package:myguard_frontend/features/marketplace/presentation/bloc/marketplace_bloc.dart';
import 'package:myguard_frontend/features/marketplace/presentation/screens/marketplace_browse_screen.dart';
import 'package:myguard_frontend/features/marketplace/presentation/screens/marketplace_listing_detail_screen.dart';
import 'package:myguard_frontend/features/marketplace/presentation/screens/marketplace_create_listing_screen.dart';
import 'package:myguard_frontend/features/marketplace/presentation/screens/my_listings_screen.dart';
import 'package:myguard_frontend/features/material/presentation/bloc/material_cubit.dart' as mat;
import 'package:myguard_frontend/features/material/presentation/screens/material_gatepass_screen.dart';
import 'package:myguard_frontend/features/material/presentation/screens/material_gatepass_create_screen.dart';
import 'package:myguard_frontend/features/material/presentation/screens/material_gatepass_detail_screen.dart';
import 'package:myguard_frontend/features/material/presentation/screens/material_verify_screen.dart';
import 'package:myguard_frontend/features/pet/presentation/bloc/pet_cubit.dart';
import 'package:myguard_frontend/features/pet/presentation/screens/pet_directory_screen.dart';
import 'package:myguard_frontend/features/pet/presentation/screens/pet_register_screen.dart';
import 'package:myguard_frontend/features/pet/presentation/screens/pet_profile_screen.dart';
import 'package:myguard_frontend/features/pet/presentation/screens/vaccination_add_screen.dart';
import 'package:myguard_frontend/features/vehicle/presentation/bloc/vehicle_cubit.dart';
import 'package:myguard_frontend/features/vehicle/presentation/screens/vehicle_list_screen.dart';
import 'package:myguard_frontend/features/vehicle/presentation/screens/vehicle_register_screen.dart';
import 'package:myguard_frontend/features/vehicle/presentation/screens/vehicle_detail_screen.dart';
import 'package:myguard_frontend/features/vehicle/presentation/screens/vehicle_lookup_screen.dart';
import 'package:myguard_frontend/features/vehicle/presentation/screens/vehicle_log_screen.dart';
import 'package:myguard_frontend/features/visitor/presentation/bloc/visitor_bloc.dart';
import 'package:myguard_frontend/features/visitor/presentation/screens/visitor_history_screen.dart';
import 'package:myguard_frontend/features/visitor/presentation/screens/visitor_pre_approve_screen.dart';
import 'package:myguard_frontend/features/visitor/presentation/screens/visitor_detail_screen.dart';
import 'package:myguard_frontend/features/visitor/presentation/screens/guest_invite_screen.dart';
import 'package:myguard_frontend/features/visitor/presentation/screens/recurring_invite_screen.dart';
import 'package:myguard_frontend/features/visitor/presentation/screens/visitor_entry_screen.dart';
import 'package:myguard_frontend/features/visitor/presentation/screens/visitor_exit_screen.dart';
import 'package:myguard_frontend/features/visitor/presentation/screens/qr_scan_screen.dart';
import 'package:myguard_frontend/features/visitor/presentation/screens/group_entry_screen.dart';
import 'package:myguard_frontend/injection.dart';
class AppRouter {
  AppRouter._();
  static GoRouter router(AuthBloc authBloc) => GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final authState = authBloc.state;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      final isSplash = state.matchedLocation == '/';
      if (isSplash) return null;
      if (authState is AuthUnauthenticated && !isAuthRoute) return '/auth/login';
      if (authState is AuthAuthenticated) {
        if (isAuthRoute) return _homeRouteForRole(authState.user.role);
        final role = authState.user.role;
        final loc = state.matchedLocation;
        if (loc.startsWith('/admin') && role != 'ROLE_ADMIN') return _homeRouteForRole(role);
        if (loc.startsWith('/guard') && role != 'ROLE_GUARD') return _homeRouteForRole(role);
        if (loc.startsWith('/resident') && role == 'ROLE_GUARD') return _homeRouteForRole(role);
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/auth/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/auth/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/auth/forgot-password', builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(path: '/auth/otp', builder: (_, __) => const OtpVerificationScreen()),
      ShellRoute(builder: (_, __, child) => _ResidentShell(child: child), routes: [
        GoRoute(path: '/resident', builder: (_, __) => const ResidentHomeScreen()),
        GoRoute(path: '/resident/gate', builder: (_, __) => BlocProvider(create: (_) => sl<VisitorBloc>(), child: const VisitorHistoryScreen())),
        GoRoute(path: '/resident/services', builder: (_, __) => const ServicesScreen()),
        GoRoute(path: '/resident/community', builder: (_, __) => const CommunityScreen()),
        GoRoute(path: '/resident/profile', builder: (_, __) => const ProfileScreen()),
      ]),
      GoRoute(path: '/resident/visitor/pre-approve', builder: (_, __) => BlocProvider(create: (_) => sl<VisitorBloc>(), child: const VisitorPreApproveScreen())),
      GoRoute(path: '/resident/visitor/guest-invite', builder: (_, __) => const GuestInviteScreen()),
      GoRoute(path: '/resident/visitor/recurring', builder: (_, __) => const RecurringInviteScreen()),
      GoRoute(path: '/resident/visitor/:id', builder: (_, s) => BlocProvider(create: (_) => sl<VisitorBloc>(), child: VisitorDetailScreen(visitorId: s.pathParameters['id']!))),
      GoRoute(path: '/resident/daily-help', builder: (_, __) => BlocProvider(create: (_) => sl<DailyHelpCubit>(), child: const DailyHelpListScreen())),
      GoRoute(path: '/resident/daily-help/register', builder: (_, __) => const DailyHelpRegisterScreen()),
      GoRoute(path: '/resident/daily-help/:id', builder: (_, s) => DailyHelpDetailScreen(helpId: s.pathParameters['id']!)),
      GoRoute(path: '/resident/amenities', builder: (_, __) => BlocProvider(create: (_) => sl<AmenityBloc>(), child: const AmenityListScreen())),
      GoRoute(path: '/resident/amenities/my-bookings', builder: (_, __) => const MyBookingsScreen()),
      GoRoute(path: '/resident/amenities/booking/:id', builder: (_, s) => BlocProvider(create: (_) => sl<AmenityBloc>(), child: BookingDetailScreen(bookingId: s.pathParameters['id']!))),
      GoRoute(path: '/resident/amenities/:id', builder: (_, s) => AmenityDetailScreen(amenityId: s.pathParameters['id']!)),
      GoRoute(path: '/resident/amenities/book/:id', builder: (_, s) => AmenityBookingScreen(amenityId: s.pathParameters['id']!)),
      GoRoute(path: '/resident/helpdesk', builder: (_, __) => BlocProvider(create: (_) => sl<HelpdeskBloc>(), child: const HelpdeskTicketListScreen())),
      GoRoute(path: '/resident/helpdesk/create', builder: (_, __) => const HelpdeskCreateTicketScreen()),
      GoRoute(path: '/resident/helpdesk/:id', builder: (_, s) => HelpdeskTicketDetailScreen(ticketId: s.pathParameters['id']!)),
      GoRoute(path: '/resident/notices', builder: (_, __) => BlocProvider(create: (_) => sl<NoticeCubit>(), child: const NoticeBoardScreen())),
      GoRoute(path: '/resident/notices/:id', builder: (_, s) => BlocProvider(create: (_) => sl<NoticeCubit>(), child: NoticeDetailScreen(noticeId: s.pathParameters['id']!))),
      GoRoute(path: '/resident/polls', builder: (_, __) => BlocProvider(create: (_) => sl<PollBloc>(), child: const PollListScreen())),
      GoRoute(path: '/resident/polls/:id', builder: (_, s) => PollVoteScreen(pollId: s.pathParameters['id']!)),
      GoRoute(path: '/resident/documents', builder: (_, __) => BlocProvider(create: (_) => sl<DocumentCubit>(), child: const DocumentsScreen())),
      GoRoute(path: '/resident/vehicles', builder: (_, __) => BlocProvider(create: (_) => sl<VehicleCubit>(), child: const VehicleListScreen())),
      GoRoute(path: '/resident/vehicles/register', builder: (_, __) => const VehicleRegisterScreen()),
      GoRoute(path: '/resident/vehicles/:id', builder: (_, s) => BlocProvider(create: (_) => sl<VehicleCubit>(), child: VehicleDetailScreen(vehicleId: s.pathParameters['id']!))),
      GoRoute(path: '/resident/material-gatepass', builder: (_, __) => BlocProvider(create: (_) => sl<mat.MaterialCubit>(), child: const MaterialGatepassScreen())),
      GoRoute(path: '/resident/material-gatepass/create', builder: (_, __) => const MaterialGatepassCreateScreen()),
      GoRoute(path: '/resident/material-gatepass/:id', builder: (_, s) => BlocProvider(create: (_) => sl<mat.MaterialCubit>(), child: MaterialGatepassDetailScreen(gatepassId: s.pathParameters['id']!))),
      GoRoute(path: '/resident/marketplace', builder: (_, __) => BlocProvider(create: (_) => sl<MarketplaceBloc>(), child: const MarketplaceBrowseScreen())),
      GoRoute(path: '/resident/marketplace/create', builder: (_, __) => const MarketplaceCreateListingScreen()),
      GoRoute(path: '/resident/marketplace/my-listings', builder: (_, __) => BlocProvider(create: (_) => sl<MarketplaceBloc>(), child: const MyListingsScreen())),
      GoRoute(path: '/resident/marketplace/:id', builder: (_, s) => BlocProvider(create: (_) => sl<MarketplaceBloc>(), child: MarketplaceListingDetailScreen(listingId: s.pathParameters['id']!))),
      GoRoute(path: '/resident/pets', builder: (_, __) => BlocProvider(create: (_) => sl<PetCubit>(), child: const PetDirectoryScreen())),
      GoRoute(path: '/resident/pets/register', builder: (_, __) => const PetRegisterScreen()),
      GoRoute(path: '/resident/pets/:id', builder: (_, s) => PetProfileScreen(petId: s.pathParameters['id']!)),
      GoRoute(path: '/resident/pets/:id/vaccination', builder: (_, s) => VaccinationAddScreen(petId: s.pathParameters['id']!)),
      GoRoute(path: '/resident/emergency', builder: (_, __) => BlocProvider(create: (_) => sl<EmergencyCubit>(), child: const EmergencyContactsScreen())),
      GoRoute(path: '/resident/emergency/panic', builder: (_, __) => const PanicButtonScreen()),
      GoRoute(path: '/resident/emergency/child-alerts', builder: (_, __) => BlocProvider(create: (_) => sl<EmergencyCubit>(), child: const ChildAlertsScreen())),
      GoRoute(path: '/resident/groups', builder: (_, __) => BlocProvider(create: (_) => sl<CommunityGroupCubit>(), child: const CommunityGroupListScreen())),
      GoRoute(path: '/resident/groups/:id', builder: (_, s) => BlocProvider(create: (_) => sl<CommunityGroupCubit>(), child: CommunityChatScreen(groupId: s.pathParameters['id']!))),
      ShellRoute(builder: (_, __, child) => _GuardShell(child: child), routes: [
        GoRoute(path: '/guard', builder: (_, __) => const GuardHomeScreen()),
        GoRoute(path: '/guard/gate', builder: (_, __) => BlocProvider(create: (_) => sl<VisitorBloc>(), child: const VisitorEntryScreen())),
        GoRoute(path: '/guard/patrol', builder: (_, __) => BlocProvider(create: (_) => sl<PatrolCubit>(), child: const PatrolScreen())),
        GoRoute(path: '/guard/alerts', builder: (_, __) => const PanicAlertsScreen()),
        GoRoute(path: '/guard/profile', builder: (_, __) => const ProfileScreen()),
      ]),
      GoRoute(path: '/guard/visitor/exit', builder: (_, __) => const VisitorExitScreen()),
      GoRoute(path: '/guard/visitor/qr-scan', builder: (_, __) => const QrScanScreen()),
      GoRoute(path: '/guard/visitor/group-entry', builder: (_, __) => const GroupEntryScreen()),
      GoRoute(path: '/guard/daily-help/check-in', builder: (_, __) => const DailyHelpCheckInScreen()),
      GoRoute(path: '/guard/patrol/scan', builder: (_, __) => const PatrolCheckpointScanScreen()),
      GoRoute(path: '/guard/e-intercom', builder: (_, __) => const EIntercomScreen()),
      GoRoute(path: '/guard/vehicle-log', builder: (_, __) => const VehicleLogScreen()),
      GoRoute(path: '/guard/vehicle-lookup', builder: (_, __) => BlocProvider(create: (_) => sl<VehicleCubit>(), child: const VehicleLookupScreen())),
      GoRoute(path: '/guard/material-verify', builder: (_, __) => const MaterialVerifyScreen()),
      ShellRoute(builder: (_, __, child) => _AdminShell(child: child), routes: [
        GoRoute(path: '/admin', builder: (_, __) => BlocProvider(create: (_) => sl<DashboardCubit>(), child: const AdminHomeScreen())),
        GoRoute(path: '/admin/manage', builder: (_, __) => const AdminManageScreen()),
        GoRoute(path: '/admin/reports', builder: (_, __) => const AdminReportsScreen()),
        GoRoute(path: '/admin/settings', builder: (_, __) => const AdminSettingsScreen()),
        GoRoute(path: '/admin/profile', builder: (_, __) => const ProfileScreen()),
      ]),
      GoRoute(path: '/admin/society', builder: (_, __) => BlocProvider(create: (_) => sl<SocietyBloc>(), child: const SocietyManagementScreen())),
      GoRoute(path: '/admin/flats', builder: (_, __) => BlocProvider(create: (_) => sl<SocietyBloc>(), child: const FlatManagementScreen())),
      GoRoute(path: '/admin/users', builder: (_, __) => BlocProvider(create: (_) => sl<UserManagementCubit>(), child: const UserManagementScreen())),
      GoRoute(path: '/admin/users/:uid', builder: (_, s) => BlocProvider(create: (_) => sl<UserManagementCubit>(), child: UserDetailScreen(uid: s.pathParameters['uid']!))),
      GoRoute(path: '/admin/visitors', builder: (_, __) => BlocProvider(create: (_) => sl<DashboardCubit>(), child: const VisitorReportsScreen())),
      GoRoute(path: '/admin/guards', builder: (_, __) => BlocProvider(create: (_) => sl<UserManagementCubit>(), child: const GuardManagementScreen())),
      GoRoute(path: '/admin/guards/shifts', builder: (_, __) => BlocProvider(create: (_) => sl<PatrolCubit>(), child: const GuardShiftScreen())),
      GoRoute(path: '/admin/guards/patrol-report', builder: (_, __) => BlocProvider(create: (_) => sl<PatrolCubit>(), child: const GuardPatrolReportScreen())),
      GoRoute(path: '/admin/notices', builder: (_, __) => BlocProvider(create: (_) => sl<NoticeCubit>(), child: const NoticeManagementScreen())),
      GoRoute(path: '/admin/notices/create', builder: (_, __) => BlocProvider(create: (_) => sl<NoticeCubit>(), child: const NoticeCreateScreen())),
      GoRoute(path: '/admin/polls', builder: (_, __) => BlocProvider(create: (_) => sl<PollBloc>(), child: const PollManagementScreen())),
      GoRoute(path: '/admin/polls/create', builder: (_, __) => BlocProvider(create: (_) => sl<PollBloc>(), child: const PollCreateScreen())),
      GoRoute(path: '/admin/amenities', builder: (_, __) => BlocProvider(create: (_) => sl<AmenityBloc>(), child: const AmenityManagementScreen())),
      GoRoute(path: '/admin/amenities/bookings', builder: (_, __) => BlocProvider(create: (_) => sl<AmenityBloc>(), child: const BookingManagementScreen())),
      GoRoute(path: '/admin/helpdesk', builder: (_, __) => BlocProvider(create: (_) => sl<HelpdeskBloc>(), child: const HelpdeskManagementScreen())),
      GoRoute(path: '/admin/helpdesk/reports', builder: (_, __) => BlocProvider(create: (_) => sl<HelpdeskBloc>(), child: const HelpdeskReportsScreen())),
      GoRoute(path: '/admin/vehicles', builder: (_, __) => BlocProvider(create: (_) => sl<VehicleCubit>(), child: const VehicleManagementScreen())),
      GoRoute(path: '/admin/material-gatepasses', builder: (_, __) => BlocProvider(create: (_) => sl<mat.MaterialCubit>(), child: const MaterialGatepassManagementScreen())),
      GoRoute(path: '/admin/emergency-contacts', builder: (_, __) => BlocProvider(create: (_) => sl<EmergencyCubit>(), child: const EmergencyContactManagementScreen())),
      GoRoute(path: '/admin/documents', builder: (_, __) => BlocProvider(create: (_) => sl<DocumentCubit>(), child: const DocumentManagementScreen())),
      GoRoute(path: '/admin/documents/upload', builder: (_, __) => BlocProvider(create: (_) => sl<DocumentCubit>(), child: const DocumentUploadScreen())),
      GoRoute(path: '/admin/move-in-out', builder: (_, __) => BlocProvider(create: (_) => sl<DashboardCubit>(), child: const MoveInOutScreen())),
    ],
  );
  static String _homeRouteForRole(String role) => switch (role) { 'ROLE_ADMIN' => '/admin', 'ROLE_GUARD' => '/guard', _ => '/resident' };
}

class _ResidentShell extends StatelessWidget {
  const _ResidentShell({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Scaffold(body: child, bottomNavigationBar: NavigationBar(
    selectedIndex: _idx(context), onDestinationSelected: (i) => _go(i, context),
    destinations: const [
      NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.door_front_door_outlined), selectedIcon: Icon(Icons.door_front_door), label: 'Gate'),
      NavigationDestination(icon: Icon(Icons.build_outlined), selectedIcon: Icon(Icons.build), label: 'Services'),
      NavigationDestination(icon: Icon(Icons.forum_outlined), selectedIcon: Icon(Icons.forum), label: 'Community'),
      NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
    ],
  ));
  int _idx(BuildContext c) { final l = GoRouterState.of(c).matchedLocation; if (l.startsWith('/resident/gate')) return 1; if (l.startsWith('/resident/services')) return 2; if (l.startsWith('/resident/community')) return 3; if (l.startsWith('/resident/profile')) return 4; return 0; }
  void _go(int i, BuildContext c) { switch (i) { case 0: c.go('/resident'); case 1: c.go('/resident/gate'); case 2: c.go('/resident/services'); case 3: c.go('/resident/community'); case 4: c.go('/resident/profile'); } }
}

class _GuardShell extends StatelessWidget {
  const _GuardShell({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Scaffold(body: child, bottomNavigationBar: NavigationBar(
    selectedIndex: _idx(context), onDestinationSelected: (i) => _go(i, context),
    destinations: const [
      NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.door_front_door_outlined), selectedIcon: Icon(Icons.door_front_door), label: 'Gate'),
      NavigationDestination(icon: Icon(Icons.shield_outlined), selectedIcon: Icon(Icons.shield), label: 'Patrol'),
      NavigationDestination(icon: Icon(Icons.warning_amber_outlined), selectedIcon: Icon(Icons.warning_amber), label: 'Alerts'),
      NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
    ],
  ));
  int _idx(BuildContext c) { final l = GoRouterState.of(c).matchedLocation; if (l.startsWith('/guard/gate')) return 1; if (l.startsWith('/guard/patrol')) return 2; if (l.startsWith('/guard/alerts')) return 3; if (l.startsWith('/guard/profile')) return 4; return 0; }
  void _go(int i, BuildContext c) { switch (i) { case 0: c.go('/guard'); case 1: c.go('/guard/gate'); case 2: c.go('/guard/patrol'); case 3: c.go('/guard/alerts'); case 4: c.go('/guard/profile'); } }
}

class _AdminShell extends StatelessWidget {
  const _AdminShell({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Scaffold(body: child, bottomNavigationBar: NavigationBar(
    selectedIndex: _idx(context), onDestinationSelected: (i) => _go(i, context),
    destinations: const [
      NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
      NavigationDestination(icon: Icon(Icons.manage_accounts_outlined), selectedIcon: Icon(Icons.manage_accounts), label: 'Manage'),
      NavigationDestination(icon: Icon(Icons.analytics_outlined), selectedIcon: Icon(Icons.analytics), label: 'Reports'),
      NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
      NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
    ],
  ));
  int _idx(BuildContext c) { final l = GoRouterState.of(c).matchedLocation; if (l.startsWith('/admin/manage')) return 1; if (l.startsWith('/admin/reports')) return 2; if (l.startsWith('/admin/settings')) return 3; if (l.startsWith('/admin/profile')) return 4; return 0; }
  void _go(int i, BuildContext c) { switch (i) { case 0: c.go('/admin'); case 1: c.go('/admin/manage'); case 2: c.go('/admin/reports'); case 3: c.go('/admin/settings'); case 4: c.go('/admin/profile'); } }
}
