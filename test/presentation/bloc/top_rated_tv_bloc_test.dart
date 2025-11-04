import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/blocs/top_rated_tv/top_rated_tv_bloc.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late TopRatedTvBloc topRatedTvBloc;
  late MockGetTopRatedTv mockGetTopRatedTv;

  final tTv = Tv(
    id: 1,
    name: 'Test TV',
    overview: 'Overview Test',
    posterPath: 'poster.jpg',
    backdropPath: 'backdrop.jpg',
    voteAverage: 8.0,
    firstAirDate: '2025-01-01',
  );

  final tTvList = [tTv];

  setUp(() {
    mockGetTopRatedTv = MockGetTopRatedTv();
    topRatedTvBloc = TopRatedTvBloc(mockGetTopRatedTv);
  });

  test('initial state should be TopRatedTvEmpty', () {
    expect(topRatedTvBloc.state, TopRatedTvEmpty());
  });

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'emits [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Right(tTvList));
      return topRatedTvBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTv()),
    expect: () => [TopRatedTvLoading(), TopRatedTvHasData(tTvList)],
    verify: (_) {
      verify(mockGetTopRatedTv.execute()).called(1);
    },
  );

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'emits [Loading, Error] when getting data fails',
    build: () {
      when(
        mockGetTopRatedTv.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedTvBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTv()),
    expect: () => [
      TopRatedTvLoading(),
      const TopRatedTvError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetTopRatedTv.execute()).called(1);
    },
  );
}
