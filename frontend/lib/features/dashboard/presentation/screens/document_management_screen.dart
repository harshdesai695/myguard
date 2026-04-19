import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/communication/presentation/bloc/document_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class DocumentManagementScreen extends StatefulWidget {
  const DocumentManagementScreen({super.key});

  @override
  State<DocumentManagementScreen> createState() =>
      _DocumentManagementScreenState();
}

class _DocumentManagementScreenState extends State<DocumentManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DocumentCubit>().loadDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Document Management')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/admin/documents/upload'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Upload'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: BlocBuilder<DocumentCubit, DocumentState>(
        builder: (context, state) {
          if (state is DocumentLoading) {
            return const AppShimmerList();
          }
          if (state is DocumentError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<DocumentCubit>().loadDocuments(),
            );
          }
          if (state is DocumentsLoaded) {
            final documents = state.documents;
            if (documents.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => context.read<DocumentCubit>().loadDocuments(),
                child: ListView(
                  children: const [
                    SizedBox(height: 200),
                    AppEmptyWidget(
                      message: 'No documents uploaded yet.',
                      icon: Icons.folder_outlined,
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () => context.read<DocumentCubit>().loadDocuments(),
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: documents.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final doc = documents[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.description_rounded,
                          color: AppColors.primary),
                      title: Text(doc.title, style: AppTypography.bodyMedium),
                      subtitle: Text(doc.type, style: AppTypography.caption),
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
