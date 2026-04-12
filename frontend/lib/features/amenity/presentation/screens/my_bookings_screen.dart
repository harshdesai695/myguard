import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: const Text('My Bookings'), bottom: const TabBar(tabs: [Tab(text: 'Upcoming'), Tab(text: 'Past')])),
        body: const TabBarView(children: [
          AppEmptyWidget(message: 'No upcoming bookings', icon: Icons.calendar_today_outlined),
          AppEmptyWidget(message: 'No past bookings', icon: Icons.history_rounded),
        ]),
      ),
    );
  }
}
