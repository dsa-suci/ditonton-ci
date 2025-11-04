import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/blocs/tv_detail/tv_detail_bloc.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvDetailBloc tvDetailBloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchlistStatusTv mockGetWatchlistStatusTv;
  late MockSaveWatchlistTv mockSaveWatchlist;
  late MockRemoveWatchlistTv mockRemoveWatchlist;

  final tTvDetail = TvDetail(
    id: 1,
    name: 'Test TV',
    overview: 'Overview Test',
    genres: [Genre(id: 1, name: 'Action')],
    firstAirDate: '2025-01-01',
    posterPath: 'poster.jpg',
    backdropPath: 'backdrop.jpg',
    voteAverage: 8.0,
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    lastAirDate: '2021-01-01',
  );

  final tTvList = <Tv>[
    Tv(
      id: 2,
      name: 'Recommendation TV',
      overview: 'Overview',
      posterPath: 'poster.jpg',
      backdropPath: 'backdrop.jpg',
      voteAverage: 7.0,
      firstAirDate: '2025-01-01',
    ),
  ];

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchlistStatusTv = MockGetWatchlistStatusTv();
    mockSaveWatchlist = MockSaveWatchlistTv();
    mockRemoveWatchlist = MockRemoveWatchlistTv();

    tvDetailBloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchlistStatusTv: mockGetWatchlistStatusTv,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  test('initial state should be TvDetailState.initial()', () {
    expect(tvDetailBloc.state, TvDetailState.initial());
  });

  blocTest<TvDetailBloc, TvDetailState>(
    'emits loading and loaded states when FetchTvDetail is successful',
    build: () {
      when(
        mockGetTvDetail.execute(1),
      ).thenAnswer((_) async => Right(tTvDetail));
      when(
        mockGetTvRecommendations.execute(1),
      ).thenAnswer((_) async => Right(tTvList));
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchTvDetail(1)),
    expect: () => [
      TvDetailState.initial().copyWith(tvDetailState: RequestState.Loading),
      TvDetailState.initial().copyWith(
        tvDetail: tTvDetail,
        tvDetailState: RequestState.Loaded,
        recommendationState: RequestState.Loading,
      ),
      TvDetailState.initial().copyWith(
        tvDetail: tTvDetail,
        tvDetailState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        recommendations: tTvList,
      ),
    ],
    verify: (_) {
      verify(mockGetTvDetail.execute(1)).called(1);
      verify(mockGetTvRecommendations.execute(1)).called(1);
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'emits watchlist message and status when AddToWatchlist is successful',
    build: () {
      when(mockSaveWatchlist.execute(tTvDetail)).thenAnswer(
        (_) async => const Right(TvDetailBloc.watchlistAddSuccessMessage),
      );
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(AddToWatchlist(tTvDetail)),
    expect: () => [
      TvDetailState.initial().copyWith(
        isAddedToWatchlist: true,
        watchlistMessage: TvDetailBloc.watchlistAddSuccessMessage,
      ),
    ],
    verify: (_) {
      verify(mockSaveWatchlist.execute(tTvDetail)).called(1);
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'emits watchlist message and status when RemoveFromWatchlist is successful',
    build: () {
      when(mockRemoveWatchlist.execute(tTvDetail)).thenAnswer(
        (_) async => const Right(TvDetailBloc.watchlistRemoveSuccessMessage),
      );
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(RemoveFromWatchlist(tTvDetail)),
    expect: () => [
      TvDetailState.initial().copyWith(
        isAddedToWatchlist: false,
        watchlistMessage: TvDetailBloc.watchlistRemoveSuccessMessage,
      ),
    ],
    verify: (_) {
      verify(mockRemoveWatchlist.execute(tTvDetail)).called(1);
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'emits watchlist status when LoadWatchlistStatus is called',
    build: () {
      when(mockGetWatchlistStatusTv.execute(1)).thenAnswer((_) async => true);
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(const LoadWatchlistStatus(1)),
    expect: () => [TvDetailState.initial().copyWith(isAddedToWatchlist: true)],
    verify: (_) {
      verify(mockGetWatchlistStatusTv.execute(1)).called(1);
    },
  );
}
