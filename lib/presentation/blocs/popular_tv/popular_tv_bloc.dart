import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:equatable/equatable.dart';

part 'popular_tv_event.dart';
part 'popular_tv_state.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTv getPopularTv;

  PopularTvBloc(this.getPopularTv) : super(PopularTvEmpty()) {
    on<FetchPopularTv>(_onFetchPopularTv);
  }

  Future<void> _onFetchPopularTv(
    FetchPopularTv event,
    Emitter<PopularTvState> emit,
  ) async {
    emit(PopularTvLoading());

    final result = await getPopularTv.execute();

    result.fold(
      (failure) => emit(PopularTvError(failure.message)),
      (tvsData) => emit(PopularTvHasData(tvsData)),
    );
  }
}
