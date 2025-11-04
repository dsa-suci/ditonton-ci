import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/common/failure.dart';

// Generate mock class untuk TvRepository
@GenerateMocks([TvRepository])
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SaveWatchlistTv(mockTvRepository);
  });

  final tTvDetail = TvDetail(
    id: 1,
    name: 'Test TV',
    overview: 'Overview Test TV',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2025-01-01',
    lastAirDate: '2025-02-01',
    voteAverage: 8.0,
    numberOfSeasons: 2,
    numberOfEpisodes: 10,
    genres: [Genre(id: 1, name: 'Drama')],
  );

  test('should save tv to the watchlist when successful', () async {
    // Arrange
    when(
      mockTvRepository.saveWatchlist(tTvDetail),
    ).thenAnswer((_) async => Right('Added to Watchlist'));

    // Act
    final result = await usecase.execute(tTvDetail);

    // Assert
    expect(result, Right('Added to Watchlist'));
    verify(mockTvRepository.saveWatchlist(tTvDetail));
    verifyNoMoreInteractions(mockTvRepository);
  });

  test('should return DatabaseFailure when saving watchlist fails', () async {
    // Arrange
    when(
      mockTvRepository.saveWatchlist(tTvDetail),
    ).thenAnswer((_) async => Left(DatabaseFailure('Failed to save')));

    // Act
    final result = await usecase.execute(tTvDetail);

    // Assert
    expect(result, Left(DatabaseFailure('Failed to save')));
    verify(mockTvRepository.saveWatchlist(tTvDetail));
    verifyNoMoreInteractions(mockTvRepository);
  });
}
