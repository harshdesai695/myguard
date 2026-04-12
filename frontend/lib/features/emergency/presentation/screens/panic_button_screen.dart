import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';

class PanicButtonScreen extends StatefulWidget {
  const PanicButtonScreen({super.key});
  @override
  State<PanicButtonScreen> createState() => _PanicButtonScreenState();
}

class _PanicButtonScreenState extends State<PanicButtonScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _triggered = false;

  @override
  void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3)); _controller.addStatusListener((s) { if (s == AnimationStatus.completed) setState(() => _triggered = true); }); }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panic / SOS')),
      body: Center(
        child: _triggered
            ? Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.check_circle_rounded, size: 80, color: AppColors.success),
                const SizedBox(height: AppSpacing.lg),
                Text('Alert Sent!', style: AppTypography.headingLarge),
                const SizedBox(height: AppSpacing.sm),
                Text('Security has been notified', style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600)),
                const SizedBox(height: AppSpacing.xl),
                OutlinedButton(onPressed: () => setState(() { _triggered = false; _controller.reset(); }), child: const Text('Reset')),
              ])
            : Column(mainAxisSize: MainAxisSize.min, children: [
                Text('Press and hold for 3 seconds', style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600)),
                const SizedBox(height: AppSpacing.xl),
                GestureDetector(
                  onLongPressStart: (_) => _controller.forward(),
                  onLongPressEnd: (_) { if (!_triggered) _controller.reset(); },
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) => Container(
                      width: 160, height: 160,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.error, border: Border.all(color: AppColors.error.withValues(alpha: 0.3), width: 8 + (_controller.value * 16))),
                      child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.sos_rounded, size: 48, color: Colors.white),
                        Text('SOS', style: AppTypography.headingMedium.copyWith(color: Colors.white)),
                      ])),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Use only in emergencies', style: AppTypography.caption.copyWith(color: AppColors.error)),
              ]),
      ),
    );
  }
}
