import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';

void main() {
  final tTvTable = TvTable(
    id: 1,
    name: 'Test TV',
    overview: 'Overview Test',
    posterPath: '/poster.jpg',
  );

  const tTvDetail = TvDetail(
    id: 1,
    name: 'Test TV',
    overview: 'Overview Test',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2024-01-01',
    lastAirDate: '2024-05-01',
    voteAverage: 8.5,
    numberOfSeasons: 3,
    numberOfEpisodes: 30,
    genres: [],
  );

  test('should convert from TvDetail entity correctly', () {
    final result = TvTable.fromEntity(tTvDetail);

    expect(result.id, 1);
    expect(result.name, 'Test TV');
    expect(result.overview, 'Overview Test');
    expect(result.posterPath, '/poster.jpg');
  });

  test('should convert from Map correctly', () {
    final map = {
      'id': 1,
      'name': 'Test TV',
      'overview': 'Overview Test',
      'posterPath': '/poster.jpg',
    };

    final result = TvTable.fromMap(map);

    expect(result, tTvTable);
  });

  test('should convert to JSON correctly', () {
    final result = tTvTable.toJson();

    final expected = {
      'id': 1,
      'name': 'Test TV',
      'overview': 'Overview Test',
      'posterPath': '/poster.jpg',
    };

    expect(result, expected);
  });

  test('should convert to Tv entity correctly', () {
    final result = tTvTable.toEntity();

    expect(result.id, 1);
    expect(result.name, 'Test TV');
    expect(result.overview, 'Overview Test');
    expect(result.posterPath, '/poster.jpg');
  });

  test('should have correct props for Equatable', () {
    final other = TvTable(
      id: 1,
      name: 'Test TV',
      overview: 'Overview Test',
      posterPath: '/poster.jpg',
    );

    expect(tTvTable == other, true);
    expect(tTvTable.props, [1, 'Test TV', 'Overview Test', '/poster.jpg']);
  });
}
