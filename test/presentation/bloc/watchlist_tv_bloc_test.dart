import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/blocs/watchlist_tv/watchlist_tv_bloc.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late WatchlistTvBloc watchlistTvBloc;
  late MockGetWatchlistTv mockGetWatchlistTv;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
    watchlistTvBloc = WatchlistTvBloc(getWatchlistTv: mockGetWatchlistTv);
  });

  final tTv = Tv(
    id: 1,
    name: 'Test TV Show',
    overview: 'Overview Test',
    posterPath: 'poster.jpg',
    backdropPath: 'backdrop.jpg',
    voteAverage: 8.0,
    firstAirDate: '2025-01-01',
  );

  final tTvList = <Tv>[tTv];

  test('initial state should be WatchlistTvState.initial()', () {
    expect(watchlistTvBloc.state, WatchlistTvState.initial());
  });

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'emits [Loading, Loaded] when fetching watchlist tv is successful',
    build: () {
      when(
        mockGetWatchlistTv.execute(),
      ).thenAnswer((_) async => Right(tTvList));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTv()),
    expect: () => [
      WatchlistTvState.initial().copyWith(watchlistState: RequestState.Loading),
      WatchlistTvState.initial().copyWith(
        watchlistState: RequestState.Loaded,
        watchlistTv: tTvList,
      ),
    ],
    verify: (_) {
      verify(mockGetWatchlistTv.execute()).called(1);
    },
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'emits [Loading, Error] when fetching watchlist tv fails',
    build: () {
      when(
        mockGetWatchlistTv.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTv()),
    expect: () => [
      WatchlistTvState.initial().copyWith(watchlistState: RequestState.Loading),
      WatchlistTvState.initial().copyWith(
        watchlistState: RequestState.Error,
        message: 'Server Failure',
      ),
    ],
    verify: (_) {
      verify(mockGetWatchlistTv.execute()).called(1);
    },
  );
}
