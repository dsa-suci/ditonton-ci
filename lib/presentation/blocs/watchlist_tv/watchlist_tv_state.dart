part of 'watchlist_tv_bloc.dart';

class WatchlistTvState extends Equatable {
  final List<Tv> watchlistTv;
  final RequestState watchlistState;
  final String message;

  const WatchlistTvState({
    required this.watchlistTv,
    required this.watchlistState,
    required this.message,
  });

  factory WatchlistTvState.initial() => const WatchlistTvState(
    watchlistTv: [],
    watchlistState: RequestState.Empty,
    message: '',
  );

  WatchlistTvState copyWith({
    List<Tv>? watchlistTv,
    RequestState? watchlistState,
    String? message,
  }) {
    return WatchlistTvState(
      watchlistTv: watchlistTv ?? this.watchlistTv,
      watchlistState: watchlistState ?? this.watchlistState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [watchlistTv, watchlistState, message];
}
