part of 'tv_detail_bloc.dart';

class TvDetailState extends Equatable {
  final RequestState tvDetailState;
  final RequestState recommendationState;
  final TvDetail? tvDetail;
  final List<Tv> recommendations;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const TvDetailState({
    required this.tvDetailState,
    required this.recommendationState,
    required this.tvDetail,
    required this.recommendations,
    required this.message,
    required this.isAddedToWatchlist,
    required this.watchlistMessage,
  });

  factory TvDetailState.initial() {
    return const TvDetailState(
      tvDetailState: RequestState.Empty,
      recommendationState: RequestState.Empty,
      tvDetail: null,
      recommendations: [],
      message: '',
      isAddedToWatchlist: false,
      watchlistMessage: '',
    );
  }

  TvDetailState copyWith({
    RequestState? tvDetailState,
    RequestState? recommendationState,
    TvDetail? tvDetail,
    List<Tv>? recommendations,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return TvDetailState(
      tvDetailState: tvDetailState ?? this.tvDetailState,
      recommendationState: recommendationState ?? this.recommendationState,
      tvDetail: tvDetail ?? this.tvDetail,
      recommendations: recommendations ?? this.recommendations,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    tvDetailState,
    recommendationState,
    tvDetail,
    recommendations,
    message,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}
