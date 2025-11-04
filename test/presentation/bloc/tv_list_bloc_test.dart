import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/blocs/tv_list/tv_list_bloc.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvListBloc tvListBloc;
  late MockGetNowPlayingTv mockGetNowPlayingTv;
  late MockGetPopularTv mockGetPopularTv;
  late MockGetTopRatedTv mockGetTopRatedTv;

  final tTvList = <Tv>[
    Tv(
      id: 1,
      name: 'Test TV',
      overview: 'Overview Test',
      posterPath: 'poster.jpg',
      backdropPath: 'backdrop.jpg',
      voteAverage: 8.0,
      firstAirDate: '2025-01-01',
    ),
  ];

  setUp(() {
    mockGetNowPlayingTv = MockGetNowPlayingTv();
    mockGetPopularTv = MockGetPopularTv();
    mockGetTopRatedTv = MockGetTopRatedTv();

    tvListBloc = TvListBloc(
      getNowPlayingTv: mockGetNowPlayingTv,
      getPopularTv: mockGetPopularTv,
      getTopRatedTv: mockGetTopRatedTv,
    );
  });

  test('initial state should be TvListState.initial()', () {
    expect(tvListBloc.state, TvListState.initial());
  });

  blocTest<TvListBloc, TvListState>(
    'emits loaded states when all fetch usecases are successful',
    build: () {
      when(
        mockGetNowPlayingTv.execute(),
      ).thenAnswer((_) async => Right(tTvList));
      when(mockGetPopularTv.execute()).thenAnswer((_) async => Right(tTvList));
      when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Right(tTvList));
      return tvListBloc;
    },
    act: (bloc) => bloc.add(FetchAllTvLists()),
    expect: () => [
      TvListState.initial().copyWith(nowPlayingState: RequestState.Loading),
      TvListState.initial().copyWith(
        nowPlayingState: RequestState.Loaded,
        nowPlayingTvs: tTvList,
      ),
      TvListState.initial().copyWith(
        nowPlayingState: RequestState.Loaded,
        nowPlayingTvs: tTvList,
        popularState: RequestState.Loaded,
        popularTvs: tTvList,
      ),
      TvListState.initial().copyWith(
        nowPlayingState: RequestState.Loaded,
        nowPlayingTvs: tTvList,
        popularState: RequestState.Loaded,
        popularTvs: tTvList,
        topRatedState: RequestState.Loaded,
        topRatedTvs: tTvList,
      ),
    ],
    verify: (_) {
      verify(mockGetNowPlayingTv.execute()).called(1);
      verify(mockGetPopularTv.execute()).called(1);
      verify(mockGetTopRatedTv.execute()).called(1);
    },
  );

  blocTest<TvListBloc, TvListState>(
    'emits error state when now playing fetch fails',
    build: () {
      when(
        mockGetNowPlayingTv.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetPopularTv.execute()).thenAnswer((_) async => Right(tTvList));
      when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Right(tTvList));
      return tvListBloc;
    },
    act: (bloc) => bloc.add(FetchAllTvLists()),
    expect: () => [
      TvListState.initial().copyWith(nowPlayingState: RequestState.Loading),
      TvListState.initial().copyWith(
        nowPlayingState: RequestState.Error,
        message: 'Server Failure',
      ),
      TvListState.initial().copyWith(
        nowPlayingState: RequestState.Error,
        message: 'Server Failure',
        popularState: RequestState.Loaded,
        popularTvs: tTvList,
      ),
      TvListState.initial().copyWith(
        nowPlayingState: RequestState.Error,
        message: 'Server Failure',
        popularState: RequestState.Loaded,
        popularTvs: tTvList,
        topRatedState: RequestState.Loaded,
        topRatedTvs: tTvList,
      ),
    ],
  );
}
