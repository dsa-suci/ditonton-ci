import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/blocs/movie_list/movie_list_bloc.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieListBloc movieListBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  final tMovieList = <Movie>[
    Movie(
      id: 2,
      adult: false,
      backdropPath: 'backdrop.jpg',
      genreIds: [1],
      originalTitle: 'Recommendation Movie Original',
      overview: 'Overview',
      popularity: 100.0,
      posterPath: 'poster.jpg',
      releaseDate: '2025-01-01',
      title: 'Recommendation Movie',
      video: false,
      voteAverage: 7.0,
      voteCount: 50,
    ),
  ];

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();

    movieListBloc = MovieListBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

  test('initial state should be MovieListInitial', () {
    expect(movieListBloc.state, MovieListInitial());
  });

  blocTest<MovieListBloc, MovieListState>(
    'emits [MovieListLoading, MovieNowPlayingLoaded] when FetchNowPlayingMovies is successful',
    build: () {
      when(
        mockGetNowPlayingMovies.execute(),
      ).thenAnswer((_) async => Right(tMovieList));
      return movieListBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingMovies()),
    expect: () => [MovieListLoading(), MovieNowPlayingLoaded(tMovieList)],
  );

  blocTest<MovieListBloc, MovieListState>(
    'emits [MovieListLoading, MoviePopularLoaded] when FetchPopularMovies is successful',
    build: () {
      when(
        mockGetPopularMovies.execute(),
      ).thenAnswer((_) async => Right(tMovieList));
      return movieListBloc;
    },
    act: (bloc) => bloc.add(FetchPopularMovies()),
    expect: () => [MovieListLoading(), MoviePopularLoaded(tMovieList)],
  );

  blocTest<MovieListBloc, MovieListState>(
    'emits [MovieListLoading, MovieTopRatedLoaded] when FetchTopRatedMovies is successful',
    build: () {
      when(
        mockGetTopRatedMovies.execute(),
      ).thenAnswer((_) async => Right(tMovieList));
      return movieListBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovies()),
    expect: () => [MovieListLoading(), MovieTopRatedLoaded(tMovieList)],
  );
}
