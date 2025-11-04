import 'package:ditonton/data/models/movie_model.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMovieModel = MovieModel(
    adult: false,
    backdropPath: '/backdrop.jpg',
    genreIds: [1, 2, 3],
    id: 123,
    originalTitle: 'Original Title',
    overview: 'Overview text',
    popularity: 7.5,
    posterPath: '/poster.jpg',
    releaseDate: '2024-01-01',
    title: 'Test Movie',
    video: false,
    voteAverage: 8.0,
    voteCount: 150,
  );

  group('MovieModel', () {
    test('fromJson should return a valid model', () {
      final Map<String, dynamic> jsonMap = {
        "adult": false,
        "backdrop_path": "/backdrop.jpg",
        "genre_ids": [1, 2, 3],
        "id": 123,
        "original_title": "Original Title",
        "overview": "Overview text",
        "popularity": 7.5,
        "poster_path": "/poster.jpg",
        "release_date": "2024-01-01",
        "title": "Test Movie",
        "video": false,
        "vote_average": 8.0,
        "vote_count": 150,
      };

      final result = MovieModel.fromJson(jsonMap);

      expect(result, equals(tMovieModel));
      expect(result.id, 123);
      expect(result.title, 'Test Movie');
      expect(result.genreIds, [1, 2, 3]);
    });

    test('toJson should return a valid JSON map', () {
      final result = tMovieModel.toJson();

      final expectedJson = {
        "adult": false,
        "backdrop_path": "/backdrop.jpg",
        "genre_ids": [1, 2, 3],
        "id": 123,
        "original_title": "Original Title",
        "overview": "Overview text",
        "popularity": 7.5,
        "poster_path": "/poster.jpg",
        "release_date": "2024-01-01",
        "title": "Test Movie",
        "video": false,
        "vote_average": 8.0,
        "vote_count": 150,
      };

      expect(result, equals(expectedJson));
    });

    test('toEntity should return a valid Movie entity', () {
      final result = tMovieModel.toEntity();

      final expectedEntity = Movie(
        adult: false,
        backdropPath: '/backdrop.jpg',
        genreIds: [1, 2, 3],
        id: 123,
        originalTitle: 'Original Title',
        overview: 'Overview text',
        popularity: 7.5,
        posterPath: '/poster.jpg',
        releaseDate: '2024-01-01',
        title: 'Test Movie',
        video: false,
        voteAverage: 8.0,
        voteCount: 150,
      );

      expect(result, equals(expectedEntity));
    });

    test('props should contain all fields', () {
      final props = tMovieModel.props;

      expect(props, [
        false,
        '/backdrop.jpg',
        [1, 2, 3],
        123,
        'Original Title',
        'Overview text',
        7.5,
        '/poster.jpg',
        '2024-01-01',
        'Test Movie',
        false,
        8.0,
        150,
      ]);
    });
  });
}
