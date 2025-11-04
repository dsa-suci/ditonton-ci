import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';

part 'movie_search_event.dart';
part 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;

  MovieSearchBloc({required this.searchMovies}) : super(MovieSearchEmpty()) {
    on<OnQueryChanged>(_onQueryChanged);
  }

  Future<void> _onQueryChanged(
    OnQueryChanged event,
    Emitter<MovieSearchState> emit,
  ) async {
    final query = event.query;

    if (query.isEmpty) {
      emit(MovieSearchEmpty());
      return;
    }

    emit(MovieSearchLoading());

    final result = await searchMovies.execute(query);

    result.fold(
      (failure) => emit(MovieSearchError(failure.message)),
      (movies) => emit(MovieSearchHasData(movies)),
    );
  }
}
