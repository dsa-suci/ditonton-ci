import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/blocs/top_rated_movies/top_rated_movies_bloc.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late TopRatedMoviesBloc topRatedMoviesBloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  final tMovie = Movie(
    id: 1,
    title: 'Test Movie',
    overview: 'Overview Test',
    posterPath: 'poster.jpg',
    backdropPath: 'backdrop.jpg',
    voteAverage: 8.0,
    voteCount: 100,
    releaseDate: '2025-01-01',
    genreIds: [1],
    adult: false,
    originalTitle: 'Original Test Movie',
    popularity: 100.0,
    video: false,
  );

  final tMovieList = [tMovie];

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMoviesBloc = TopRatedMoviesBloc(mockGetTopRatedMovies);
  });

  test('initial state should be TopRatedMoviesEmpty', () {
    expect(topRatedMoviesBloc.state, TopRatedMoviesEmpty());
  });

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'emits [Loading, HasData] when data is gotten successfully',
    build: () {
      when(
        mockGetTopRatedMovies.execute(),
      ).thenAnswer((_) async => Right(tMovieList));
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovies()),
    expect: () => [TopRatedMoviesLoading(), TopRatedMoviesHasData(tMovieList)],
    verify: (_) {
      verify(mockGetTopRatedMovies.execute()).called(1);
    },
  );

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'emits [Loading, Error] when getting data fails',
    build: () {
      when(
        mockGetTopRatedMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedMovies()),
    expect: () => [
      TopRatedMoviesLoading(),
      const TopRatedMoviesError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetTopRatedMovies.execute()).called(1);
    },
  );
}
