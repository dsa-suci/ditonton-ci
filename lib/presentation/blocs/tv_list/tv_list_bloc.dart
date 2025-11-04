import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:equatable/equatable.dart';

part 'tv_list_event.dart';
part 'tv_list_state.dart';

class TvListBloc extends Bloc<TvListEvent, TvListState> {
  final GetNowPlayingTv getNowPlayingTv;
  final GetPopularTv getPopularTv;
  final GetTopRatedTv getTopRatedTv;

  TvListBloc({
    required this.getNowPlayingTv,
    required this.getPopularTv,
    required this.getTopRatedTv,
  }) : super(TvListState.initial()) {
    on<FetchAllTvLists>(_onFetchAllTvLists);
  }

  Future<void> _onFetchAllTvLists(
    FetchAllTvLists event,
    Emitter<TvListState> emit,
  ) async {
    emit(state.copyWith(nowPlayingState: RequestState.Loading));

    final nowPlayingResult = await getNowPlayingTv.execute();
    final popularResult = await getPopularTv.execute();
    final topRatedResult = await getTopRatedTv.execute();

    nowPlayingResult.fold(
      (failure) {
        emit(
          state.copyWith(
            nowPlayingState: RequestState.Error,
            message: failure.message,
          ),
        );
      },
      (nowPlayingData) {
        emit(
          state.copyWith(
            nowPlayingState: RequestState.Loaded,
            nowPlayingTvs: nowPlayingData,
          ),
        );
      },
    );

    popularResult.fold(
      (failure) {
        emit(
          state.copyWith(
            popularState: RequestState.Error,
            message: failure.message,
          ),
        );
      },
      (popularData) {
        emit(
          state.copyWith(
            popularState: RequestState.Loaded,
            popularTvs: popularData,
          ),
        );
      },
    );

    topRatedResult.fold(
      (failure) {
        emit(
          state.copyWith(
            topRatedState: RequestState.Error,
            message: failure.message,
          ),
        );
      },
      (topRatedData) {
        emit(
          state.copyWith(
            topRatedState: RequestState.Loaded,
            topRatedTvs: topRatedData,
          ),
        );
      },
    );
  }
}
