import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;
  late MockTvLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvRemoteDataSource();
    mockLocalDataSource = MockTvLocalDataSource();
    repository = TvRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTvModel = TvModel(
    id: 1,
    name: 'Test TV',
    overview: 'Overview',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2022-01-01',
    voteAverage: 8.0,
  );

  final tTv = Tv(
    id: 1,
    name: 'Test TV',
    overview: 'Overview',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2022-01-01',
    voteAverage: 8.0,
  );

  final tTvModelList = <TvModel>[tTvModel];
  final tTvList = <Tv>[tTv];

  final tTvDetailModel = TvDetailModel(
    id: 1,
    name: 'Test TV',
    overview: 'Overview',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2022-01-01',
    lastAirDate: '2022-12-01',
    voteAverage: 8.0,
    numberOfSeasons: 1,
    numberOfEpisodes: 10,
    genres: [],
  );

  final tTvDetail = tTvDetailModel.toEntity();

  // ================================================================
  // 🧩 NOW PLAYING
  // ================================================================
  group('getNowPlayingTv', () {
    test('should return list of TV when successful', () async {
      when(
        mockRemoteDataSource.getNowPlayingTv(),
      ).thenAnswer((_) async => tTvModelList);

      final result = await repository.getNowPlayingTv();

      verify(mockRemoteDataSource.getNowPlayingTv());
      expect(result.getOrElse(() => []), tTvList);
    });

    test('should return ServerFailure when call fails', () async {
      when(mockRemoteDataSource.getNowPlayingTv()).thenThrow(ServerException());

      final result = await repository.getNowPlayingTv();

      verify(mockRemoteDataSource.getNowPlayingTv());
      expect(result, isA<Left<Failure, List<Tv>>>());
    });
  });

  // ================================================================
  // 🧩 TV DETAIL
  // ================================================================
  group('getTvDetail', () {
    test('should return TvDetail when successful', () async {
      when(
        mockRemoteDataSource.getTvDetail(1),
      ).thenAnswer((_) async => tTvDetailModel);

      final result = await repository.getTvDetail(1);

      verify(mockRemoteDataSource.getTvDetail(1));
      expect(result.getOrElse(() => tTvDetail), tTvDetail);
    });

    test('should return ServerFailure when call fails', () async {
      when(mockRemoteDataSource.getTvDetail(1)).thenThrow(ServerException());

      final result = await repository.getTvDetail(1);

      verify(mockRemoteDataSource.getTvDetail(1));
      expect(result, isA<Left<Failure, TvDetail>>());
    });
  });

  // ================================================================
  // 🧩 POPULAR TV
  // ================================================================
  group('getPopularTv', () {
    test('should return list of TV when successful', () async {
      when(
        mockRemoteDataSource.getPopularTv(),
      ).thenAnswer((_) async => tTvModelList);

      final result = await repository.getPopularTv();

      verify(mockRemoteDataSource.getPopularTv());
      expect(result.getOrElse(() => []), tTvList);
    });

    test('should return ServerFailure when fails', () async {
      when(mockRemoteDataSource.getPopularTv()).thenThrow(ServerException());

      final result = await repository.getPopularTv();

      verify(mockRemoteDataSource.getPopularTv());
      expect(result, isA<Left<Failure, List<Tv>>>());
    });

    test('should return ConnectionFailure when no internet', () async {
      when(
        mockRemoteDataSource.getPopularTv(),
      ).thenThrow(const SocketException('Failed to connect'));

      final result = await repository.getPopularTv();

      verify(mockRemoteDataSource.getPopularTv());
      result.fold(
        (failure) => expect(failure, isA<ConnectionFailure>()),
        (_) => fail('Expected Left, got Right'),
      );
    });

    test('should throw Exception when unknown error occurs', () async {
      when(mockRemoteDataSource.getPopularTv()).thenThrow(Exception('Unknown'));

      expect(
        () async => await repository.getPopularTv(),
        throwsA(isA<Exception>()),
      );
    });
  });

  // ================================================================
  // 🧩 TOP RATED TV
  // ================================================================
  group('getTopRatedTv', () {
    test('should return list of TV when successful', () async {
      when(
        mockRemoteDataSource.getTopRatedTv(),
      ).thenAnswer((_) async => tTvModelList);

      final result = await repository.getTopRatedTv();

      verify(mockRemoteDataSource.getTopRatedTv());
      expect(result.getOrElse(() => []), tTvList);
    });
  });

  // ================================================================
  // 🧩 SEARCH TV
  // ================================================================
  group('searchTv', () {
    test('should return list of TV when search is successful', () async {
      when(
        mockRemoteDataSource.searchTv('test'),
      ).thenAnswer((_) async => tTvModelList);

      final result = await repository.searchTv('test');

      verify(mockRemoteDataSource.searchTv('test'));
      expect(result.getOrElse(() => []), tTvList);
    });
  });

  // ================================================================
  // 🧩 RECOMMENDATIONS
  // ================================================================
  group('getTvRecommendations', () {
    test('should return TV recommendations list when successful', () async {
      when(
        mockRemoteDataSource.getTvRecommendations(1),
      ).thenAnswer((_) async => tTvModelList);

      final result = await repository.getTvRecommendations(1);

      verify(mockRemoteDataSource.getTvRecommendations(1));
      expect(result.getOrElse(() => []), tTvList);
    });

    test('should return ServerFailure when fails', () async {
      when(
        mockRemoteDataSource.getTvRecommendations(1),
      ).thenThrow(ServerException());

      final result = await repository.getTvRecommendations(1);

      verify(mockRemoteDataSource.getTvRecommendations(1));
      expect(result, isA<Left<Failure, List<Tv>>>());
    });

    test('should return ConnectionFailure when no internet', () async {
      when(
        mockRemoteDataSource.getTvRecommendations(1),
      ).thenThrow(const SocketException('Failed to connect'));

      final result = await repository.getTvRecommendations(1);

      verify(mockRemoteDataSource.getTvRecommendations(1));
      result.fold(
        (failure) => expect(failure, isA<ConnectionFailure>()),
        (_) => fail('Expected Left, got Right'),
      );
    });
  });

  // ================================================================
  // 🧩 WATCHLIST
  // ================================================================
  group('Watchlist TV', () {
    final tTvTable = TvTable(
      id: 1,
      name: 'Test TV',
      overview: 'Overview',
      posterPath: '/poster.jpg',
    );

    final tTvTableList = [tTvTable];

    test('should save TV to watchlist', () async {
      when(
        mockLocalDataSource.insertWatchlist(tTvTable),
      ).thenAnswer((_) async => 'Added to Watchlist');

      final result = await repository.saveWatchlist(tTvDetail);

      expect(result, const Right('Added to Watchlist'));
    });

    test('should remove TV from watchlist', () async {
      when(
        mockLocalDataSource.removeWatchlist(tTvTable),
      ).thenAnswer((_) async => 'Removed from Watchlist');

      final result = await repository.removeWatchlist(tTvDetail);

      expect(result, const Right('Removed from Watchlist'));
    });

    test('should return list of watchlist TVs', () async {
      when(
        mockLocalDataSource.getWatchlistTv(),
      ).thenAnswer((_) async => tTvTableList);

      final result = await repository.getWatchlistTv();

      expect(result.isRight(), true);
    });

    test('should return true when TV is in watchlist', () async {
      when(mockLocalDataSource.getTvById(1)).thenAnswer((_) async => tTvTable);

      final result = await repository.isAddedToWatchlist(1);
      expect(result, true);
    });

    test('should return false when TV is not in watchlist', () async {
      when(mockLocalDataSource.getTvById(1)).thenAnswer((_) async => null);

      final result = await repository.isAddedToWatchlist(1);
      expect(result, false);
    });
  });

  // ================================================================
  // 🧩 Tambahan Coverage
  // ================================================================
  group('Extra Coverage for TvRepositoryImpl', () {
    test('should throw DatabaseException when insertWatchlist fails', () async {
      when(
        mockLocalDataSource.insertWatchlist(any),
      ).thenThrow(DatabaseException('Failed to add watchlist'));

      expectLater(
        () async => await repository.saveWatchlist(tTvDetail),
        throwsA(isA<DatabaseException>()),
      );
    });

    test('should throw DatabaseException when removeWatchlist fails', () async {
      when(
        mockLocalDataSource.removeWatchlist(any),
      ).thenThrow(DatabaseException('Failed to remove watchlist'));

      expectLater(
        () async => await repository.removeWatchlist(tTvDetail),
        throwsA(isA<DatabaseException>()),
      );
    });

    test(
      'should throw Exception when getWatchlistTv fails unexpectedly',
      () async {
        when(
          mockLocalDataSource.getWatchlistTv(),
        ).thenThrow(Exception('Unexpected error'));

        expectLater(
          () async => await repository.getWatchlistTv(),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}
