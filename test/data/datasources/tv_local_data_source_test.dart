import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/data/datasources/tv_local_data_source.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/tv_table.dart';

// Generate mock class for DatabaseHelper
@GenerateMocks([DatabaseHelper])
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  final testTvTable = TvTable(
    id: 1,
    name: 'Test TV',
    overview: 'Overview',
    posterPath: '/poster.jpg',
  );

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TvLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('insertWatchlist', () {
    test('should return success message when insert is successful', () async {
      when(
        mockDatabaseHelper.insertTvWatchlist(testTvTable),
      ).thenAnswer((_) async => 1);

      final result = await dataSource.insertWatchlist(testTvTable);

      expect(result, 'Added to Watchlist');
    });

    test('should throw Exception when insert fails', () async {
      when(
        mockDatabaseHelper.insertTvWatchlist(testTvTable),
      ).thenThrow(Exception('Failed'));

      expect(
        () => dataSource.insertWatchlist(testTvTable),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('removeWatchlist', () {
    test('should return success message when remove is successful', () async {
      when(
        mockDatabaseHelper.removeTvWatchlist(testTvTable),
      ).thenAnswer((_) async => 1);

      final result = await dataSource.removeWatchlist(testTvTable);

      expect(result, 'Removed from Watchlist');
    });

    test('should throw Exception when remove fails', () async {
      when(
        mockDatabaseHelper.removeTvWatchlist(testTvTable),
      ).thenThrow(Exception('Failed'));

      expect(
        () => dataSource.removeWatchlist(testTvTable),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getTvById', () {
    test('should return TvTable when data is found', () async {
      when(
        mockDatabaseHelper.getTvById(1),
      ).thenAnswer((_) async => testTvTable.toJson());

      final result = await dataSource.getTvById(1);

      expect(result, isA<TvTable>());
      expect(result!.id, testTvTable.id);
    });

    test('should return null when data is not found', () async {
      when(mockDatabaseHelper.getTvById(1)).thenAnswer((_) async => null);

      final result = await dataSource.getTvById(1);

      expect(result, null);
    });
  });

  group('getWatchlistTv', () {
    test('should return list of TvTable from database', () async {
      when(
        mockDatabaseHelper.getTvWatchlist(),
      ).thenAnswer((_) async => [testTvTable.toJson()]);

      final result = await dataSource.getWatchlistTv();

      expect(result, isA<List<TvTable>>());
      expect(result.length, 1);
      expect(result[0].id, testTvTable.id);
    });
  });
}
