import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/features/marketplace/domain/entities/marketplace_entity.dart';
import 'package:myguard_frontend/features/marketplace/domain/usecases/get_listings_usecase.dart';
import 'package:myguard_frontend/features/marketplace/domain/usecases/marketplace_usecases.dart';

sealed class MarketplaceEvent extends Equatable { const MarketplaceEvent(); @override List<Object?> get props => []; }
class ListingsFetched extends MarketplaceEvent { const ListingsFetched({this.page = 0, this.category}); final int page; final String? category; @override List<Object?> get props => [page, category]; }
class ListingCreated extends MarketplaceEvent { const ListingCreated(this.data); final Map<String, dynamic> data; @override List<Object> get props => [data]; }
class ListingUpdated extends MarketplaceEvent { const ListingUpdated({required this.id, required this.data}); final String id; final Map<String, dynamic> data; @override List<Object> get props => [id, data]; }
class ListingDeleted extends MarketplaceEvent { const ListingDeleted(this.id); final String id; @override List<Object> get props => [id]; }
class ListingMarkedSold extends MarketplaceEvent { const ListingMarkedSold(this.id); final String id; @override List<Object> get props => [id]; }
class InterestExpressed extends MarketplaceEvent { const InterestExpressed({required this.listingId, required this.data}); final String listingId; final Map<String, dynamic> data; @override List<Object> get props => [listingId, data]; }

sealed class MarketplaceState extends Equatable { const MarketplaceState(); @override List<Object?> get props => []; }
class MarketplaceInitial extends MarketplaceState { const MarketplaceInitial(); }
class MarketplaceLoading extends MarketplaceState { const MarketplaceLoading(); }
class ListingsLoaded extends MarketplaceState { const ListingsLoaded({required this.listings, required this.hasMore, required this.page}); final List<ListingEntity> listings; final bool hasMore; final int page; @override List<Object> get props => [listings, hasMore, page]; }
class MarketplaceActionSuccess extends MarketplaceState { const MarketplaceActionSuccess(this.message); final String message; @override List<Object> get props => [message]; }
class MarketplaceError extends MarketplaceState { const MarketplaceError(this.message); final String message; @override List<Object> get props => [message]; }

class MarketplaceBloc extends Bloc<MarketplaceEvent, MarketplaceState> {
  MarketplaceBloc({
    required GetListingsUseCase getListingsUseCase,
    required CreateListingUseCase createListingUseCase,
    required UpdateListingUseCase updateListingUseCase,
    required DeleteListingUseCase deleteListingUseCase,
    required MarkSoldUseCase markSoldUseCase,
    required ExpressInterestUseCase expressInterestUseCase,
  }) : _getListingsUseCase = getListingsUseCase,
       _createListingUseCase = createListingUseCase,
       _updateListingUseCase = updateListingUseCase,
       _deleteListingUseCase = deleteListingUseCase,
       _markSoldUseCase = markSoldUseCase,
       _expressInterestUseCase = expressInterestUseCase,
       super(const MarketplaceInitial()) {
    on<ListingsFetched>(_onFetched);
    on<ListingCreated>(_onCreated);
    on<ListingUpdated>(_onUpdated);
    on<ListingDeleted>(_onDeleted);
    on<ListingMarkedSold>(_onMarkedSold);
    on<InterestExpressed>(_onInterestExpressed);
  }
  final GetListingsUseCase _getListingsUseCase;
  final CreateListingUseCase _createListingUseCase;
  final UpdateListingUseCase _updateListingUseCase;
  final DeleteListingUseCase _deleteListingUseCase;
  final MarkSoldUseCase _markSoldUseCase;
  final ExpressInterestUseCase _expressInterestUseCase;
  final List<ListingEntity> _items = [];

  Future<void> _onFetched(ListingsFetched e, Emitter<MarketplaceState> emit) async { if (e.page == 0) { _items.clear(); emit(const MarketplaceLoading()); } final r = await _getListingsUseCase(page: e.page, category: e.category); r.fold((f) => emit(MarketplaceError(f.message)), (p) { _items.addAll(p.content); emit(ListingsLoaded(listings: List.unmodifiable(_items), hasMore: p.hasNext, page: p.page)); }); }

  Future<void> _onCreated(ListingCreated e, Emitter<MarketplaceState> emit) async { emit(const MarketplaceLoading()); final r = await _createListingUseCase(e.data); r.fold((f) => emit(MarketplaceError(f.message)), (_) => emit(const MarketplaceActionSuccess('Listing created'))); }

  Future<void> _onUpdated(ListingUpdated e, Emitter<MarketplaceState> emit) async { emit(const MarketplaceLoading()); final r = await _updateListingUseCase(e.id, e.data); r.fold((f) => emit(MarketplaceError(f.message)), (_) => emit(const MarketplaceActionSuccess('Listing updated'))); }

  Future<void> _onDeleted(ListingDeleted e, Emitter<MarketplaceState> emit) async { final r = await _deleteListingUseCase(e.id); r.fold((f) => emit(MarketplaceError(f.message)), (_) => emit(const MarketplaceActionSuccess('Listing deleted'))); }

  Future<void> _onMarkedSold(ListingMarkedSold e, Emitter<MarketplaceState> emit) async { final r = await _markSoldUseCase(e.id); r.fold((f) => emit(MarketplaceError(f.message)), (_) => emit(const MarketplaceActionSuccess('Listing marked as sold'))); }

  Future<void> _onInterestExpressed(InterestExpressed e, Emitter<MarketplaceState> emit) async { final r = await _expressInterestUseCase(e.listingId, e.data); r.fold((f) => emit(MarketplaceError(f.message)), (_) => emit(const MarketplaceActionSuccess('Interest expressed'))); }
}
