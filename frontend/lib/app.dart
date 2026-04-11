import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/core/config/app_router.dart';
import 'package:myguard_frontend/design_system/app_theme.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myguard_frontend/injection.dart';

class MyGuardApp extends StatelessWidget {
  const MyGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: Builder(
        builder: (context) {
          final authBloc = context.read<AuthBloc>();
          final router = AppRouter.router(authBloc);

          return MaterialApp.router(
            title: 'MyGuard',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
