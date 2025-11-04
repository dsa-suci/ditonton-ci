import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMovieTable = MovieTable(
    id: 1,
    title: 'Inception',
    posterPath: '/poster.jpg',
    overview: 'A mind-bending thriller',
  );

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: '/backdrop.jpg',
    genres: const [],
    id: 1,
    originalTitle: 'Inception',
    overview: 'A mind-bending thriller',
    posterPath: '/poster.jpg',
    releaseDate: '2010-07-16',
    runtime: 148,
    title: 'Inception',
    voteAverage: 8.8,
    voteCount: 12000,
  );

  final tMovieEntity = Movie.watchlist(
    id: 1,
    overview: 'A mind-bending thriller',
    posterPath: '/poster.jpg',
    title: 'Inception',
  );

  group('MovieTable', () {
    test('✅ fromEntity should create a valid MovieTable from MovieDetail', () {
      final result = MovieTable.fromEntity(tMovieDetail);

      expect(result, equals(tMovieTable));
      expect(result.id, 1);
      expect(result.title, 'Inception');
    });

    test('✅ fromMap should return a valid model', () {
      final map = {
        'id': 1,
        'title': 'Inception',
        'posterPath': '/poster.jpg',
        'overview': 'A mind-bending thriller',
      };

      final result = MovieTable.fromMap(map);

      expect(result, equals(tMovieTable));
      expect(result.posterPath, '/poster.jpg');
    });

    test('✅ toJson should return a valid map', () {
      final result = tMovieTable.toJson();

      final expectedMap = {
        'id': 1,
        'title': 'Inception',
        'posterPath': '/poster.jpg',
        'overview': 'A mind-bending thriller',
      };

      expect(result, equals(expectedMap));
    });

    test('✅ toEntity should convert MovieTable to Movie entity correctly', () {
      final result = tMovieTable.toEntity();

      expect(result, equals(tMovieEntity));
      expect(result.title, 'Inception');
      expect(result.posterPath, '/poster.jpg');
    });

    test('✅ props should contain all fields', () {
      expect(tMovieTable.props, [
        1,
        'Inception',
        '/poster.jpg',
        'A mind-bending thriller',
      ]);
    });
  });
}
