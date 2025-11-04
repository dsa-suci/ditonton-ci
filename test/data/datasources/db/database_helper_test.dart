import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_table.dart';

void main() {
  late DatabaseHelper databaseHelper;

  setUpAll(() {
    // Inisialisasi SQFlite untuk lingkungan test
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    // Gunakan instance baru agar tidak reuse DB lama
    databaseHelper = DatabaseHelper();
    final db = await databaseHelper.database;

    // Bersihkan isi tabel tanpa menutup database
    await db!.execute('DELETE FROM watchlist');
    await db.execute('DELETE FROM watchlist_tv');
  });

  // Jangan close database di tearDown
  // Karena DatabaseHelper pakai singleton dan akan dipakai ulang

  final tMovie = MovieTable(
    id: 1,
    title: 'Test Movie',
    overview: 'Overview of test movie',
    posterPath: '/poster.jpg',
  );

  final tTv = TvTable(
    id: 101,
    name: 'Test TV',
    overview: 'Overview of test tv',
    posterPath: '/poster_tv.jpg',
  );

  group('Movie Watchlist', () {
    test('should insert and get movie by id', () async {
      await databaseHelper.insertWatchlist(tMovie);
      final result = await databaseHelper.getMovieById(tMovie.id);
      expect(result?['title'], 'Test Movie');
    });

    test('should return null when movie not found', () async {
      final result = await databaseHelper.getMovieById(999);
      expect(result, isNull);
    });

    test('should remove movie from watchlist', () async {
      await databaseHelper.insertWatchlist(tMovie);
      await databaseHelper.removeWatchlist(tMovie);
      final result = await databaseHelper.getMovieById(tMovie.id);
      expect(result, isNull);
    });

    test('should return all movies in watchlist', () async {
      await databaseHelper.insertWatchlist(tMovie);
      final result = await databaseHelper.getWatchlistMovies();
      expect(result.length, 1);
    });
  });

  group('TV Watchlist', () {
    test('should insert and get TV by id', () async {
      await databaseHelper.insertTvWatchlist(tTv);
      final result = await databaseHelper.getTvById(tTv.id);
      expect(result?['name'], 'Test TV');
    });

    test('should return null when TV not found', () async {
      final result = await databaseHelper.getTvById(9999);
      expect(result, isNull);
    });

    test('should remove TV from watchlist', () async {
      await databaseHelper.insertTvWatchlist(tTv);
      await databaseHelper.removeTvWatchlist(tTv);
      final result = await databaseHelper.getTvById(tTv.id);
      expect(result, isNull);
    });

    test('should return all TV shows in watchlist', () async {
      await databaseHelper.insertTvWatchlist(tTv);
      final result = await databaseHelper.getTvWatchlist();
      expect(result.length, 1);
    });
  });
}
