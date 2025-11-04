part of 'movie_list_bloc.dart';

abstract class MovieListState extends Equatable {
  const MovieListState();

  @override
  List<Object?> get props => [];
}

class MovieListInitial extends MovieListState {}

class MovieListLoading extends MovieListState {}

class MovieListError extends MovieListState {
  final String message;
  const MovieListError(this.message);

  @override
  List<Object?> get props => [message];
}

// Success states for each category
class MovieNowPlayingLoaded extends MovieListState {
  final List<Movie> movies;
  const MovieNowPlayingLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

class MoviePopularLoaded extends MovieListState {
  final List<Movie> movies;
  const MoviePopularLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

class MovieTopRatedLoaded extends MovieListState {
  final List<Movie> movies;
  const MovieTopRatedLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}
