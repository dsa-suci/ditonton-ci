import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/blocs/watchlist_movie/watchlist_movie_bloc.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late WatchlistMovieBloc watchlistMovieBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMovieBloc = WatchlistMovieBloc(
      getWatchlistMovies: mockGetWatchlistMovies,
    );
  });

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

  final tMovieList = <Movie>[tMovie];

  test('initial state should be WatchlistMovieState.initial()', () {
    expect(watchlistMovieBloc.state, WatchlistMovieState.initial());
  });

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'emits [Loading, Loaded] when fetching watchlist movies is successful',
    build: () {
      when(
        mockGetWatchlistMovies.execute(),
      ).thenAnswer((_) async => Right(tMovieList));
      return watchlistMovieBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect: () => [
      WatchlistMovieState.initial().copyWith(
        watchlistState: RequestState.Loading,
      ),
      WatchlistMovieState.initial().copyWith(
        watchlistState: RequestState.Loaded,
        watchlistMovies: tMovieList,
      ),
    ],
    verify: (_) {
      verify(mockGetWatchlistMovies.execute()).called(1);
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'emits [Loading, Error] when fetching watchlist movies fails',
    build: () {
      when(
        mockGetWatchlistMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistMovieBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect: () => [
      WatchlistMovieState.initial().copyWith(
        watchlistState: RequestState.Loading,
      ),
      WatchlistMovieState.initial().copyWith(
        watchlistState: RequestState.Error,
        message: 'Server Failure',
      ),
    ],
    verify: (_) {
      verify(mockGetWatchlistMovies.execute()).called(1);
    },
  );
}
