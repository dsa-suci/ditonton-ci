import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/blocs/tv_search/tv_search_bloc.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSearchBloc tvSearchBloc;
  late MockSearchTv mockSearchTv;

  setUp(() {
    mockSearchTv = MockSearchTv();
    tvSearchBloc = TvSearchBloc(searchTv: mockSearchTv);
  });

  final tTv = Tv(
    id: 1,
    name: 'Test TV',
    overview: 'Overview Test',
    posterPath: 'poster.jpg',
    backdropPath: 'backdrop.jpg',
    voteAverage: 8.0,
    firstAirDate: '2025-01-01',
  );

  final tTvList = <Tv>[tTv];
  const tQuery = 'Test TV';

  test('initial state should be TvSearchState.initial()', () {
    expect(tvSearchBloc.state, TvSearchState.initial());
  });

  blocTest<TvSearchBloc, TvSearchState>(
    'emits [Loading, Loaded] when data is fetched successfully',
    build: () {
      when(
        mockSearchTv.execute(tQuery),
      ).thenAnswer((_) async => Right(tTvList));
      return tvSearchBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    expect: () => [
      TvSearchState.initial().copyWith(state: RequestState.Loading),
      TvSearchState.initial().copyWith(
        state: RequestState.Loaded,
        searchResult: tTvList,
      ),
    ],
    verify: (_) {
      verify(mockSearchTv.execute(tQuery)).called(1);
    },
  );

  blocTest<TvSearchBloc, TvSearchState>(
    'emits [Loading, Error] when search fails',
    build: () {
      when(
        mockSearchTv.execute(tQuery),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvSearchBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    expect: () => [
      TvSearchState.initial().copyWith(state: RequestState.Loading),
      TvSearchState.initial().copyWith(
        state: RequestState.Error,
        message: 'Server Failure',
      ),
    ],
    verify: (_) {
      verify(mockSearchTv.execute(tQuery)).called(1);
    },
  );

  blocTest<TvSearchBloc, TvSearchState>(
    'emits [Empty] when query is empty',
    build: () => tvSearchBloc,
    act: (bloc) => bloc.add(const OnQueryChanged('')),
    expect: () => [
      TvSearchState.initial().copyWith(
        state: RequestState.Empty,
        searchResult: [],
        message: '',
      ),
    ],
    verify: (_) {
      verifyNever(mockSearchTv.execute(''));
    },
  );
}
