import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/genre.dart';

// Generate mocks
@GenerateMocks([TvRepository])
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
  });

  final testTv = Tv.watchlist(
    id: 1,
    name: 'TV Show 1',
    overview: 'Overview TV 1',
    posterPath: '/path1.jpg',
  );

  final testTvDetail = TvDetail(
    id: 1,
    name: 'TV Show Detail',
    overview: 'Overview Detail',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2023-01-01',
    lastAirDate: '2023-12-31',
    voteAverage: 8.5,
    numberOfSeasons: 2,
    numberOfEpisodes: 20,
    genres: [Genre(id: 1, name: 'Action')],
  );

  group('TvRepository', () {
    test('should get list of now playing tv', () async {
      when(
        mockTvRepository.getNowPlayingTv(),
      ).thenAnswer((_) async => Right([testTv]));

      final result = await mockTvRepository.getNowPlayingTv();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should not fail'),
        (tvList) => expect(tvList, [testTv]),
      );
      verify(mockTvRepository.getNowPlayingTv()).called(1);
    });

    test('should get list of popular tv', () async {
      when(
        mockTvRepository.getPopularTv(),
      ).thenAnswer((_) async => Right([testTv]));

      final result = await mockTvRepository.getPopularTv();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should not fail'),
        (tvList) => expect(tvList, [testTv]),
      );
      verify(mockTvRepository.getPopularTv()).called(1);
    });

    test('should get list of top rated tv', () async {
      when(
        mockTvRepository.getTopRatedTv(),
      ).thenAnswer((_) async => Right([testTv]));

      final result = await mockTvRepository.getTopRatedTv();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should not fail'),
        (tvList) => expect(tvList, [testTv]),
      );
      verify(mockTvRepository.getTopRatedTv()).called(1);
    });

    test('should get tv detail by id', () async {
      when(
        mockTvRepository.getTvDetail(1),
      ).thenAnswer((_) async => Right(testTvDetail));

      final result = await mockTvRepository.getTvDetail(1);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should not fail'),
        (detail) => expect(detail, testTvDetail),
      );
      verify(mockTvRepository.getTvDetail(1)).called(1);
    });

    test('should get tv recommendations', () async {
      when(
        mockTvRepository.getTvRecommendations(1),
      ).thenAnswer((_) async => Right([testTv]));

      final result = await mockTvRepository.getTvRecommendations(1);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should not fail'),
        (tvList) => expect(tvList, [testTv]),
      );
      verify(mockTvRepository.getTvRecommendations(1)).called(1);
    });

    test('should search tv by query', () async {
      when(
        mockTvRepository.searchTv('test'),
      ).thenAnswer((_) async => Right([testTv]));

      final result = await mockTvRepository.searchTv('test');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should not fail'),
        (tvList) => expect(tvList, [testTv]),
      );
      verify(mockTvRepository.searchTv('test')).called(1);
    });

    test('should save tv to watchlist', () async {
      when(
        mockTvRepository.saveWatchlist(testTvDetail),
      ).thenAnswer((_) async => const Right('Added to Watchlist'));

      final result = await mockTvRepository.saveWatchlist(testTvDetail);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should not fail'),
        (msg) => expect(msg, 'Added to Watchlist'),
      );
      verify(mockTvRepository.saveWatchlist(testTvDetail)).called(1);
    });

    test('should remove tv from watchlist', () async {
      when(
        mockTvRepository.removeWatchlist(testTvDetail),
      ).thenAnswer((_) async => const Right('Removed from Watchlist'));

      final result = await mockTvRepository.removeWatchlist(testTvDetail);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should not fail'),
        (msg) => expect(msg, 'Removed from Watchlist'),
      );
      verify(mockTvRepository.removeWatchlist(testTvDetail)).called(1);
    });

    test('should check if tv is added to watchlist', () async {
      when(
        mockTvRepository.isAddedToWatchlist(1),
      ).thenAnswer((_) async => true);

      final result = await mockTvRepository.isAddedToWatchlist(1);

      expect(result, true);
      verify(mockTvRepository.isAddedToWatchlist(1)).called(1);
    });

    test('should get watchlist tv', () async {
      when(
        mockTvRepository.getWatchlistTv(),
      ).thenAnswer((_) async => Right([testTv]));

      final result = await mockTvRepository.getWatchlistTv();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should not fail'),
        (tvList) => expect(tvList, [testTv]),
      );
      verify(mockTvRepository.getWatchlistTv()).called(1);
    });
  });
}
