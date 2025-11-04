import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';

import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/blocs/movie_search/movie_search_bloc.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieSearchBloc movieSearchBloc;
  late MockSearchMovies mockSearchMovies;

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
  const tQuery = 'Test';

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    movieSearchBloc = MovieSearchBloc(searchMovies: mockSearchMovies);
  });

  test('initial state should be MovieSearchEmpty', () {
    expect(movieSearchBloc.state, MovieSearchEmpty());
  });

  blocTest<MovieSearchBloc, MovieSearchState>(
    'emits [Loading, HasData] when search is successful',
    build: () {
      when(
        mockSearchMovies.execute(tQuery),
      ).thenAnswer((_) async => Right(tMovieList));
      return movieSearchBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    expect: () => [MovieSearchLoading(), MovieSearchHasData(tMovieList)],
    verify: (_) {
      verify(mockSearchMovies.execute(tQuery)).called(1);
    },
  );

  blocTest<MovieSearchBloc, MovieSearchState>(
    'emits [Loading, Error] when search fails',
    build: () {
      when(
        mockSearchMovies.execute(tQuery),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieSearchBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    expect: () => [
      MovieSearchLoading(),
      const MovieSearchError('Server Failure'),
    ],
    verify: (_) {
      verify(mockSearchMovies.execute(tQuery)).called(1);
    },
  );

  blocTest<MovieSearchBloc, MovieSearchState>(
    'emits [Empty] when the query is empty',
    build: () => movieSearchBloc,
    act: (bloc) => bloc.add(const OnQueryChanged('')),
    expect: () => [MovieSearchEmpty()],
    verify: (_) {
      verifyZeroInteractions(mockSearchMovies);
    },
  );
}
