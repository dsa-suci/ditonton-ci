part of 'tv_list_bloc.dart';

class TvListState extends Equatable {
  final List<Tv> nowPlayingTvs;
  final List<Tv> popularTvs;
  final List<Tv> topRatedTvs;

  final RequestState nowPlayingState;
  final RequestState popularState;
  final RequestState topRatedState;

  final String message;

  const TvListState({
    required this.nowPlayingTvs,
    required this.popularTvs,
    required this.topRatedTvs,
    required this.nowPlayingState,
    required this.popularState,
    required this.topRatedState,
    required this.message,
  });

  factory TvListState.initial() => const TvListState(
    nowPlayingTvs: [],
    popularTvs: [],
    topRatedTvs: [],
    nowPlayingState: RequestState.Empty,
    popularState: RequestState.Empty,
    topRatedState: RequestState.Empty,
    message: '',
  );

  TvListState copyWith({
    List<Tv>? nowPlayingTvs,
    List<Tv>? popularTvs,
    List<Tv>? topRatedTvs,
    RequestState? nowPlayingState,
    RequestState? popularState,
    RequestState? topRatedState,
    String? message,
  }) {
    return TvListState(
      nowPlayingTvs: nowPlayingTvs ?? this.nowPlayingTvs,
      popularTvs: popularTvs ?? this.popularTvs,
      topRatedTvs: topRatedTvs ?? this.topRatedTvs,
      nowPlayingState: nowPlayingState ?? this.nowPlayingState,
      popularState: popularState ?? this.popularState,
      topRatedState: topRatedState ?? this.topRatedState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    nowPlayingTvs,
    popularTvs,
    topRatedTvs,
    nowPlayingState,
    popularState,
    topRatedState,
    message,
  ];
}
