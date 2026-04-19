import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/features/communication/domain/entities/communication_entity.dart';
import 'package:myguard_frontend/features/communication/domain/usecases/communication_usecases.dart';

sealed class DocumentState extends Equatable { const DocumentState(); @override List<Object?> get props => []; }
class DocumentInitial extends DocumentState { const DocumentInitial(); }
class DocumentLoading extends DocumentState { const DocumentLoading(); }
class DocumentsLoaded extends DocumentState { const DocumentsLoaded({required this.documents, required this.hasMore}); final List<DocumentEntity> documents; final bool hasMore; @override List<Object> get props => [documents, hasMore]; }
class DocumentActionSuccess extends DocumentState { const DocumentActionSuccess(this.message); final String message; @override List<Object> get props => [message]; }
class DocumentError extends DocumentState { const DocumentError(this.message); final String message; @override List<Object> get props => [message]; }

class DocumentCubit extends Cubit<DocumentState> {
  DocumentCubit({
    required GetDocumentsUseCase getDocumentsUseCase,
    required UploadDocumentUseCase uploadDocumentUseCase,
  }) : _getDocumentsUseCase = getDocumentsUseCase,
       _uploadDocumentUseCase = uploadDocumentUseCase,
       super(const DocumentInitial());
  final GetDocumentsUseCase _getDocumentsUseCase;
  final UploadDocumentUseCase _uploadDocumentUseCase;
  final List<DocumentEntity> _items = [];

  Future<void> loadDocuments({int page = 0, String? societyId}) async {
    if (page == 0) { _items.clear(); emit(const DocumentLoading()); }
    final r = await _getDocumentsUseCase(page: page, societyId: societyId);
    r.fold((f) => emit(DocumentError(f.message)), (p) { _items.addAll(p.content); emit(DocumentsLoaded(documents: List.unmodifiable(_items), hasMore: p.hasNext)); });
  }

  Future<void> uploadDocument(Map<String, dynamic> data) async {
    emit(const DocumentLoading());
    final r = await _uploadDocumentUseCase(data);
    r.fold((f) => emit(DocumentError(f.message)), (_) => emit(const DocumentActionSuccess('Document uploaded')));
  }
}
