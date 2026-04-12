import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/features/marketplace/domain/entities/marketplace_entity.dart';
import 'package:myguard_frontend/features/marketplace/domain/usecases/get_listings_usecase.dart';

sealed class MarketplaceEvent extends Equatable { const MarketplaceEvent(); @override List<Object?> get props => []; }
class ListingsFetched extends MarketplaceEvent { const ListingsFetched({this.page = 0, this.category}); final int page; final String? category; @override List<Object?> get props => [page, category]; }

sealed class MarketplaceState extends Equatable { const MarketplaceState(); @override List<Object?> get props => []; }
class MarketplaceInitial extends MarketplaceState { const MarketplaceInitial(); }
class MarketplaceLoading extends MarketplaceState { const MarketplaceLoading(); }
class ListingsLoaded extends MarketplaceState { const ListingsLoaded({required this.listings, required this.hasMore, required this.page}); final List<ListingEntity> listings; final bool hasMore; final int page; @override List<Object> get props => [listings, hasMore, page]; }
class MarketplaceError extends MarketplaceState { const MarketplaceError(this.message); final String message; @override List<Object> get props => [message]; }

class MarketplaceBloc extends Bloc<MarketplaceEvent, MarketplaceState> {
  MarketplaceBloc({required GetListingsUseCase getListingsUseCase}) : _getListingsUseCase = getListingsUseCase, super(const MarketplaceInitial()) { on<ListingsFetched>(_onFetched); }
  final GetListingsUseCase _getListingsUseCase; final List<ListingEntity> _items = [];

  Future<void> _onFetched(ListingsFetched e, Emitter<MarketplaceState> emit) async { if (e.page == 0) { _items.clear(); emit(const MarketplaceLoading()); } final r = await _getListingsUseCase(page: e.page, category: e.category); r.fold((f) => emit(MarketplaceError(f.message)), (p) { _items.addAll(p.content); emit(ListingsLoaded(listings: List.unmodifiable(_items), hasMore: p.hasNext, page: p.page)); }); }
}
