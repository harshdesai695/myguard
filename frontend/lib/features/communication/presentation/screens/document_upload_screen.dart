import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/communication/presentation/bloc/document_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_snackbar.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String _selectedCategory = 'BYLAWS';
  String? _selectedFileName;

  final List<String> _categories = ['BYLAWS', 'MEETING_MINUTES', 'FINANCIAL_REPORT', 'CIRCULAR', 'OTHER'];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DocumentCubit, DocumentState>(
      listener: (context, state) {
        if (state is DocumentActionSuccess) {
          AppSnackbar.success(context, message: state.message);
          Navigator.of(context).pop();
        } else if (state is DocumentError) {
          AppSnackbar.error(context, message: state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Upload Document')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _titleController,
                  label: 'Document Title',
                  hint: 'Enter document title',
                  prefixIcon: const Icon(Icons.title_rounded, size: 20),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category_outlined),
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c.replaceAll('_', ' ')))).toList(),
                  onChanged: (v) => setState(() => _selectedCategory = v!),
                ),
                const SizedBox(height: AppSpacing.lg),
                InkWell(
                  onTap: _pickFile,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey300, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.grey50,
                    ),
                    child: Center(
                      child: _selectedFileName != null
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.insert_drive_file_outlined, size: 32, color: AppColors.primary),
                                const SizedBox(height: AppSpacing.xs),
                                Text(_selectedFileName!, style: AppTypography.bodyMedium),
                                const SizedBox(height: 4),
                                Text('Tap to change', style: AppTypography.caption.copyWith(color: AppColors.grey500)),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.cloud_upload_outlined, size: 32, color: AppColors.grey400),
                                const SizedBox(height: AppSpacing.xs),
                                Text('Tap to select file', style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500)),
                                Text('PDF, DOC, XLSX supported', style: AppTypography.caption.copyWith(color: AppColors.grey400)),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                BlocBuilder<DocumentCubit, DocumentState>(
                  builder: (context, state) {
                    return AppButton(
                      onPressed: state is DocumentLoading ? null : _submit,
                      label: state is DocumentLoading ? 'Uploading...' : 'Upload Document',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pickFile() {
    // File picker integration - to be wired via file_picker package
    setState(() => _selectedFileName = 'document.pdf');
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a file')));
      return;
    }
    context.read<DocumentCubit>().uploadDocument({
      'title': _titleController.text.trim(),
      'type': _selectedCategory,
      'fileUrl': 'pending_upload',
    });
  }
}
