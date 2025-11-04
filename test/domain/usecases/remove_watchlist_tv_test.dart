import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/common/failure.dart';

@GenerateMocks([TvRepository])
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = RemoveWatchlistTv(mockTvRepository);
  });

  final tTvDetail = TvDetail(
    id: 1,
    name: 'Test TV',
    overview: 'Overview Test TV',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2025-01-01',
    lastAirDate: '2025-12-31',
    voteAverage: 8.0,
    numberOfSeasons: 1,
    numberOfEpisodes: 10,
    genres: [],
  );

  test('should remove tv from watchlist in repository', () async {
    when(
      mockTvRepository.removeWatchlist(tTvDetail),
    ).thenAnswer((_) async => Right('Removed from Watchlist'));

    final result = await usecase.execute(tTvDetail);

    expect(result.isRight(), true);
    result.fold(
      (_) => fail('Expected Right, got Left'),
      (message) => expect(message, 'Removed from Watchlist'),
    );
    verify(mockTvRepository.removeWatchlist(tTvDetail));
    verifyNoMoreInteractions(mockTvRepository);
  });

  test('should return DatabaseFailure when repository fails', () async {
    when(
      mockTvRepository.removeWatchlist(tTvDetail),
    ).thenAnswer((_) async => Left(DatabaseFailure('Failed')));

    final result = await usecase.execute(tTvDetail);

    expect(result.isLeft(), true);
    result.fold((failure) {
      expect(failure, isA<DatabaseFailure>());
      expect(failure.message, 'Failed');
    }, (_) => fail('Expected Left, got Right'));
    verify(mockTvRepository.removeWatchlist(tTvDetail));
    verifyNoMoreInteractions(mockTvRepository);
  });
}
