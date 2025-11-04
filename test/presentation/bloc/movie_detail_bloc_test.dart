import 'package:ditonton/presentation/blocs/movie_detail/movie_detail_event.dart';
import 'package:ditonton/presentation/blocs/movie_detail/movie_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/blocs/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/common/state_enum.dart';

// import hasil generate mock dari test_helper.dart
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdrop.jpg',
    genres: [],
    id: 1,
    originalTitle: 'Original Test Movie',
    overview: 'Overview Test',
    posterPath: 'poster.jpg',
    releaseDate: '2025-01-01',
    runtime: 120,
    title: 'Test Movie',
    voteAverage: 8.0,
    voteCount: 100,
  );

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
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();

    movieDetailBloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  test('initial state should be MovieDetailState', () {
    expect(movieDetailBloc.state, const MovieDetailState());
  });

  // Fetch Movie Detail
  blocTest<MovieDetailBloc, MovieDetailState>(
    'emits loading and loaded states when FetchMovieDetail is successful',
    build: () {
      when(
        mockGetMovieDetail.execute(1),
      ).thenAnswer((_) async => Right(tMovieDetail));
      when(
        mockGetMovieRecommendations.execute(1),
      ).thenAnswer((_) async => Right(tMovieList));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchMovieDetail(1)),
    expect: () => [
      const MovieDetailState(movieState: RequestState.Loading),
      MovieDetailState(
        movie: tMovieDetail,
        movieState: RequestState.Loaded,
        recommendationState: RequestState.Loading,
      ),
      MovieDetailState(
        movie: tMovieDetail,
        movieState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        movieRecommendations: tMovieList,
      ),
    ],
  );

  // Add To Watchlist
  blocTest<MovieDetailBloc, MovieDetailState>(
    'emits watchlist status updates when AddToWatchlist is successful',
    build: () {
      when(mockSaveWatchlist.execute(tMovieDetail)).thenAnswer(
        (_) async => const Right(MovieDetailBloc.watchlistAddSuccessMessage),
      );
      when(
        mockGetWatchListStatus.execute(tMovieDetail.id),
      ).thenAnswer((_) async => true);
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(AddToWatchlist(tMovieDetail)),
    expect: () => [
      // emit pertama: hanya watchlistMessage
      MovieDetailState(
        watchlistMessage: MovieDetailBloc.watchlistAddSuccessMessage,
        isAddedToWatchlist: false,
      ),
      // emit kedua: watchlistMessage + status update
      MovieDetailState(
        watchlistMessage: MovieDetailBloc.watchlistAddSuccessMessage,
        isAddedToWatchlist: true,
      ),
    ],
  );

  // Remove From Watchlist
  blocTest<MovieDetailBloc, MovieDetailState>(
    'emits watchlist status updates when RemoveFromWatchlist is successful',
    build: () {
      when(mockRemoveWatchlist.execute(tMovieDetail)).thenAnswer(
        (_) async => const Right(MovieDetailBloc.watchlistRemoveSuccessMessage),
      );
      when(
        mockGetWatchListStatus.execute(tMovieDetail.id),
      ).thenAnswer((_) async => false);
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(RemoveFromWatchlist(tMovieDetail)),
    expect: () => [
      const MovieDetailState(
        isAddedToWatchlist: false,
        watchlistMessage: MovieDetailBloc.watchlistRemoveSuccessMessage,
      ),
    ],
  );
}
