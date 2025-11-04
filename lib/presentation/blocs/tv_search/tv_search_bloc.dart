import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:equatable/equatable.dart';

part 'tv_search_event.dart';
part 'tv_search_state.dart';

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTv searchTv;

  TvSearchBloc({required this.searchTv}) : super(TvSearchState.initial()) {
    on<OnQueryChanged>(_onQueryChanged);
  }

  Future<void> _onQueryChanged(
    OnQueryChanged event,
    Emitter<TvSearchState> emit,
  ) async {
    final query = event.query;

    if (query.isEmpty) {
      emit(
        state.copyWith(
          state: RequestState.Empty,
          searchResult: [],
          message: '',
        ),
      );
      return;
    }

    emit(state.copyWith(state: RequestState.Loading));

    final result = await searchTv.execute(query);

    result.fold(
      (failure) {
        emit(
          state.copyWith(state: RequestState.Error, message: failure.message),
        );
      },
      (data) {
        emit(state.copyWith(state: RequestState.Loaded, searchResult: data));
      },
    );
  }
}
