import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/blocs/popular_tv/popular_tv_bloc.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late PopularTvBloc popularTvBloc;
  late MockGetPopularTv mockGetPopularTv;

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
    mockGetPopularTv = MockGetPopularTv();
    popularTvBloc = PopularTvBloc(mockGetPopularTv);
  });

  test('initial state should be PopularTvEmpty', () {
    expect(popularTvBloc.state, PopularTvEmpty());
  });

  blocTest<PopularTvBloc, PopularTvState>(
    'emits [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetPopularTv.execute()).thenAnswer((_) async => Right(tTvList));
      return popularTvBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTv()),
    expect: () => [PopularTvLoading(), PopularTvHasData(tTvList)],
    verify: (_) {
      verify(mockGetPopularTv.execute()).called(1);
    },
  );

  blocTest<PopularTvBloc, PopularTvState>(
    'emits [Loading, Error] when getting data fails',
    build: () {
      when(
        mockGetPopularTv.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularTvBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTv()),
    expect: () => [PopularTvLoading(), const PopularTvError('Server Failure')],
    verify: (_) {
      verify(mockGetPopularTv.execute()).called(1);
    },
  );
}
