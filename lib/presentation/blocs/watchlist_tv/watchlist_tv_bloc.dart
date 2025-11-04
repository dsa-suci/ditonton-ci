import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTv getWatchlistTv;

  WatchlistTvBloc({required this.getWatchlistTv})
    : super(WatchlistTvState.initial()) {
    on<FetchWatchlistTv>(_onFetchWatchlistTv);
  }

  Future<void> _onFetchWatchlistTv(
    FetchWatchlistTv event,
    Emitter<WatchlistTvState> emit,
  ) async {
    emit(state.copyWith(watchlistState: RequestState.Loading));

    final result = await getWatchlistTv.execute();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            watchlistState: RequestState.Error,
            message: failure.message,
          ),
        );
      },
      (tvList) {
        emit(
          state.copyWith(
            watchlistState: RequestState.Loaded,
            watchlistTv: tvList,
          ),
        );
      },
    );
  }
}
