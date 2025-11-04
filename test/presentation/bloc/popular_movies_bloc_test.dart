import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/blocs/popular_movies/popular_movies_bloc.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late PopularMoviesBloc popularMoviesBloc;
  late MockGetPopularMovies mockGetPopularMovies;

  final tMovie = Movie(
    id: 1,
    title: 'Test Movie',
    overview: 'Test Overview',
    posterPath: 'poster.jpg',
    backdropPath: 'backdrop.jpg',
    voteAverage: 8.0,
    voteCount: 100,
    releaseDate: '2025-01-01',
    genreIds: [1],
    adult: false,
    originalTitle: 'Test Movie Original',
    popularity: 100.0,
    video: false,
  );

  final tMovieList = [tMovie];

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMoviesBloc = PopularMoviesBloc(mockGetPopularMovies);
  });

  test('initial state should be PopularMoviesEmpty', () {
    expect(popularMoviesBloc.state, PopularMoviesEmpty());
  });

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'emits [Loading, HasData] when data is gotten successfully',
    build: () {
      when(
        mockGetPopularMovies.execute(),
      ).thenAnswer((_) async => Right(tMovieList));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchPopularMovies()),
    expect: () => [PopularMoviesLoading(), PopularMoviesHasData(tMovieList)],
    verify: (_) {
      verify(mockGetPopularMovies.execute()).called(1);
    },
  );

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'emits [Loading, Error] when getting data fails',
    build: () {
      when(
        mockGetPopularMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchPopularMovies()),
    expect: () => [
      PopularMoviesLoading(),
      const PopularMoviesError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetPopularMovies.execute()).called(1);
    },
  );
}
