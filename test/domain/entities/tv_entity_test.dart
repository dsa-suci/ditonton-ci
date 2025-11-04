import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/domain/entities/tv.dart';

void main() {
  group('Tv Entity', () {
    final tTv = Tv(
      id: 1,
      name: 'Test TV',
      overview: 'Overview of Test TV',
      posterPath: '/poster.jpg',
      backdropPath: '/backdrop.jpg',
      firstAirDate: '2025-01-01',
      voteAverage: 8.5,
    );

    final tTvWatchlist = Tv.watchlist(
      id: 2,
      name: 'Watchlist TV',
      overview: 'Watchlist Overview',
      posterPath: '/watchlist_poster.jpg',
    );

    test('should have correct properties', () {
      expect(tTv.id, 1);
      expect(tTv.name, 'Test TV');
      expect(tTv.overview, 'Overview of Test TV');
      expect(tTv.posterPath, '/poster.jpg');
      expect(tTv.backdropPath, '/backdrop.jpg');
      expect(tTv.firstAirDate, '2025-01-01');
      expect(tTv.voteAverage, 8.5);
    });

    test('should have correct properties for watchlist constructor', () {
      expect(tTvWatchlist.id, 2);
      expect(tTvWatchlist.name, 'Watchlist TV');
      expect(tTvWatchlist.overview, 'Watchlist Overview');
      expect(tTvWatchlist.posterPath, '/watchlist_poster.jpg');
      expect(tTvWatchlist.backdropPath, null);
      expect(tTvWatchlist.firstAirDate, null);
      expect(tTvWatchlist.voteAverage, null);
    });

    test('should support value comparison using Equatable', () {
      final tTvCopy = Tv(
        id: 1,
        name: 'Test TV',
        overview: 'Overview of Test TV',
        posterPath: '/poster.jpg',
        backdropPath: '/backdrop.jpg',
        firstAirDate: '2025-01-01',
        voteAverage: 8.5,
      );

      expect(tTv, tTvCopy); // Equatable comparison
    });
  });
}
