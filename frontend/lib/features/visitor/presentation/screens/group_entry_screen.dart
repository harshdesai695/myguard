import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class GroupEntryScreen extends StatefulWidget {
  const GroupEntryScreen({super.key});
  @override
  State<GroupEntryScreen> createState() => _GroupEntryScreenState();
}

class _GroupEntryScreenState extends State<GroupEntryScreen> {
  final _flatC = TextEditingController();
  final _purposeC = TextEditingController();
  final List<Map<String, TextEditingController>> _visitors = [{'name': TextEditingController(), 'phone': TextEditingController()}];

  @override
  void dispose() { _flatC.dispose(); _purposeC.dispose(); for (final v in _visitors) { v['name']!.dispose(); v['phone']!.dispose(); } super.dispose(); }

  void _addVisitor() => setState(() => _visitors.add({'name': TextEditingController(), 'phone': TextEditingController()}));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Entry')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(label: 'Flat Number', controller: _flatC, hint: 'e.g., A-101', prefixIcon: const Icon(Icons.apartment_outlined, size: 20)),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: 'Purpose', controller: _purposeC, hint: 'e.g., Party, Event', prefixIcon: const Icon(Icons.description_outlined, size: 20)),
              const SizedBox(height: AppSpacing.lg),
              Row(children: [
                Text('Visitors (${_visitors.length})', style: AppTypography.titleMedium),
                const Spacer(),
                TextButton.icon(onPressed: _addVisitor, icon: const Icon(Icons.add, size: 18), label: const Text('Add')),
              ]),
              const SizedBox(height: AppSpacing.sm),
              ...List.generate(_visitors.length, (i) => Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(children: [
                    Row(children: [
                      Text('Visitor ${i + 1}', style: AppTypography.labelMedium),
                      const Spacer(),
                      if (_visitors.length > 1) IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => setState(() { _visitors[i]['name']!.dispose(); _visitors[i]['phone']!.dispose(); _visitors.removeAt(i); })),
                    ]),
                    const SizedBox(height: AppSpacing.xs),
                    AppTextField(label: 'Name', controller: _visitors[i]['name']!, hint: 'Visitor name'),
                    const SizedBox(height: AppSpacing.sm),
                    AppTextField(label: 'Phone', controller: _visitors[i]['phone']!, hint: 'Phone number', keyboardType: TextInputType.phone),
                  ]),
                ),
              )),
              const SizedBox(height: AppSpacing.lg),
              AppButton(label: 'Log Group Entry', onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_visitors.length} visitors logged')))),
            ],
          ),
        ),
      ),
    );
  }
}
