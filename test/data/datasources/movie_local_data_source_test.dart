import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = MovieLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  final tMovieTable = MovieTable(
    id: 1,
    title: 'Test Movie',
    overview: 'Overview',
    posterPath: '/poster.jpg',
  );

  final tMovieMap = {
    'id': 1,
    'title': 'Test Movie',
    'overview': 'Overview',
    'posterPath': '/poster.jpg',
  };

  // ================================================================
  // 🧩 INSERT WATCHLIST
  // ================================================================
  group('insertWatchlist', () {
    test('should return success message when insert successful', () async {
      // arrange
      when(
        mockDatabaseHelper.insertWatchlist(tMovieTable),
      ).thenAnswer((_) async => 1);
      // act
      final result = await dataSource.insertWatchlist(tMovieTable);
      // assert
      expect(result, 'Added to Watchlist');
      verify(mockDatabaseHelper.insertWatchlist(tMovieTable));
    });

    test('should throw DatabaseException when insert fails', () async {
      // arrange
      when(
        mockDatabaseHelper.insertWatchlist(tMovieTable),
      ).thenThrow(Exception('DB Error'));
      // act & assert
      expect(
        () async => await dataSource.insertWatchlist(tMovieTable),
        throwsA(isA<DatabaseException>()),
      );
    });
  });

  // ================================================================
  // 🧩 REMOVE WATCHLIST
  // ================================================================
  group('removeWatchlist', () {
    test('should return success message when remove successful', () async {
      when(
        mockDatabaseHelper.removeWatchlist(tMovieTable),
      ).thenAnswer((_) async => 1);

      final result = await dataSource.removeWatchlist(tMovieTable);

      expect(result, 'Removed from Watchlist');
      verify(mockDatabaseHelper.removeWatchlist(tMovieTable));
    });

    test('should throw DatabaseException when remove fails', () async {
      when(
        mockDatabaseHelper.removeWatchlist(tMovieTable),
      ).thenThrow(Exception('Remove Error'));

      expect(
        () async => await dataSource.removeWatchlist(tMovieTable),
        throwsA(isA<DatabaseException>()),
      );
    });
  });

  // ================================================================
  // 🧩 GET MOVIE BY ID
  // ================================================================
  group('getMovieById', () {
    test('should return MovieTable when data exists', () async {
      when(
        mockDatabaseHelper.getMovieById(1),
      ).thenAnswer((_) async => tMovieMap);

      final result = await dataSource.getMovieById(1);

      expect(result, isA<MovieTable>());
      expect(result!.id, 1);
      expect(result.title, 'Test Movie');
      expect(result.posterPath, '/poster.jpg');
    });

    test('should return null when data not found', () async {
      when(mockDatabaseHelper.getMovieById(1)).thenAnswer((_) async => null);

      final result = await dataSource.getMovieById(1);

      expect(result, null);
    });
  });

  // ================================================================
  // 🧩 GET WATCHLIST MOVIES
  // ================================================================
  group('getWatchlistMovies', () {
    test('should return list of MovieTable', () async {
      when(
        mockDatabaseHelper.getWatchlistMovies(),
      ).thenAnswer((_) async => [tMovieMap]);

      final result = await dataSource.getWatchlistMovies();

      expect(result, isA<List<MovieTable>>());
      expect(result.length, 1);
      expect(result.first.id, 1);
      expect(result.first.title, 'Test Movie');
    });

    test('should return empty list when no data', () async {
      when(mockDatabaseHelper.getWatchlistMovies()).thenAnswer((_) async => []);

      final result = await dataSource.getWatchlistMovies();

      expect(result, []);
    });
  });
}
