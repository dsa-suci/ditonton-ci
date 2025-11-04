import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/genre.dart';

void main() {
  group('TvDetail Entity', () {
    final tGenres = [Genre(id: 1, name: 'Action'), Genre(id: 2, name: 'Drama')];

    final tTvDetail = TvDetail(
      id: 1,
      name: 'Test TV',
      overview: 'Overview of Test TV',
      posterPath: '/poster.jpg',
      backdropPath: '/backdrop.jpg',
      firstAirDate: '2025-01-01',
      lastAirDate: '2025-01-10',
      voteAverage: 8.5,
      numberOfSeasons: 2,
      numberOfEpisodes: 20,
      genres: tGenres,
    );

    test('should have correct properties', () {
      expect(tTvDetail.id, 1);
      expect(tTvDetail.name, 'Test TV');
      expect(tTvDetail.overview, 'Overview of Test TV');
      expect(tTvDetail.posterPath, '/poster.jpg');
      expect(tTvDetail.backdropPath, '/backdrop.jpg');
      expect(tTvDetail.firstAirDate, '2025-01-01');
      expect(tTvDetail.lastAirDate, '2025-01-10');
      expect(tTvDetail.voteAverage, 8.5);
      expect(tTvDetail.numberOfSeasons, 2);
      expect(tTvDetail.numberOfEpisodes, 20);
      expect(tTvDetail.genres, tGenres);
    });

    test('should support value comparison using Equatable', () {
      final tTvDetailCopy = TvDetail(
        id: 1,
        name: 'Test TV',
        overview: 'Overview of Test TV',
        posterPath: '/poster.jpg',
        backdropPath: '/backdrop.jpg',
        firstAirDate: '2025-01-01',
        lastAirDate: '2025-01-10',
        voteAverage: 8.5,
        numberOfSeasons: 2,
        numberOfEpisodes: 20,
        genres: tGenres,
      );

      expect(tTvDetail, tTvDetailCopy); // Equatable comparison
    });
  });
}
