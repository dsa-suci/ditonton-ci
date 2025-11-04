import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(MovieListInitial()) {
    on<FetchNowPlayingMovies>(_onFetchNowPlaying);
    on<FetchPopularMovies>(_onFetchPopular);
    on<FetchTopRatedMovies>(_onFetchTopRated);
  }

  Future<void> _onFetchNowPlaying(
    FetchNowPlayingMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(MovieListLoading());

    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) => emit(MovieListError(failure.message)),
      (movies) => emit(MovieNowPlayingLoaded(movies)),
    );
  }

  Future<void> _onFetchPopular(
    FetchPopularMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(MovieListLoading());

    final result = await getPopularMovies.execute();
    result.fold(
      (failure) => emit(MovieListError(failure.message)),
      (movies) => emit(MoviePopularLoaded(movies)),
    );
  }

  Future<void> _onFetchTopRated(
    FetchTopRatedMovies event,
    Emitter<MovieListState> emit,
  ) async {
    emit(MovieListLoading());

    final result = await getTopRatedMovies.execute();
    result.fold(
      (failure) => emit(MovieListError(failure.message)),
      (movies) => emit(MovieTopRatedLoaded(movies)),
    );
  }
}
