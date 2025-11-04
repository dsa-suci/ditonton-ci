import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tGenreModel = GenreModel(id: 1, name: 'Action');

  final tMovieDetailResponse = MovieDetailResponse(
    adult: false,
    backdropPath: '/backdrop.jpg',
    budget: 100000000,
    genres: [tGenreModel],
    homepage: 'https://example.com',
    id: 1,
    imdbId: 'tt1234567',
    originalLanguage: 'en',
    originalTitle: 'Original Title',
    overview: 'This is the movie overview.',
    popularity: 120.5,
    posterPath: '/poster.jpg',
    releaseDate: '2024-05-01',
    revenue: 500000000,
    runtime: 120,
    status: 'Released',
    tagline: 'This is the tagline.',
    title: 'Test Movie',
    video: false,
    voteAverage: 8.5,
    voteCount: 1000,
  );

  group('MovieDetailResponse', () {
    test('fromJson should return a valid model', () {
      final Map<String, dynamic> jsonMap = {
        "adult": false,
        "backdrop_path": "/backdrop.jpg",
        "budget": 100000000,
        "genres": [
          {"id": 1, "name": "Action"},
        ],
        "homepage": "https://example.com",
        "id": 1,
        "imdb_id": "tt1234567",
        "original_language": "en",
        "original_title": "Original Title",
        "overview": "This is the movie overview.",
        "popularity": 120.5,
        "poster_path": "/poster.jpg",
        "release_date": "2024-05-01",
        "revenue": 500000000,
        "runtime": 120,
        "status": "Released",
        "tagline": "This is the tagline.",
        "title": "Test Movie",
        "video": false,
        "vote_average": 8.5,
        "vote_count": 1000,
      };

      final result = MovieDetailResponse.fromJson(jsonMap);
      expect(result, equals(tMovieDetailResponse));
      expect(result.genres.first.name, 'Action');
      expect(result.title, 'Test Movie');
    });

    test('toJson should return a valid JSON map', () {
      final result = tMovieDetailResponse.toJson();

      final expectedJson = {
        "adult": false,
        "backdrop_path": "/backdrop.jpg",
        "budget": 100000000,
        "genres": [
          {"id": 1, "name": "Action"},
        ],
        "homepage": "https://example.com",
        "id": 1,
        "imdb_id": "tt1234567",
        "original_language": "en",
        "original_title": "Original Title",
        "overview": "This is the movie overview.",
        "popularity": 120.5,
        "poster_path": "/poster.jpg",
        "release_date": "2024-05-01",
        "revenue": 500000000,
        "runtime": 120,
        "status": "Released",
        "tagline": "This is the tagline.",
        "title": "Test Movie",
        "video": false,
        "vote_average": 8.5,
        "vote_count": 1000,
      };

      expect(result, equals(expectedJson));
    });

    test('toEntity should convert correctly to MovieDetail', () {
      final result = tMovieDetailResponse.toEntity();

      final expectedEntity = MovieDetail(
        adult: false,
        backdropPath: '/backdrop.jpg',
        genres: [Genre(id: 1, name: 'Action')],
        id: 1,
        originalTitle: 'Original Title',
        overview: 'This is the movie overview.',
        posterPath: '/poster.jpg',
        releaseDate: '2024-05-01',
        runtime: 120,
        title: 'Test Movie',
        voteAverage: 8.5,
        voteCount: 1000,
      );

      expect(result, equals(expectedEntity));
    });

    test('props should contain all fields', () {
      expect(tMovieDetailResponse.props, [
        false,
        '/backdrop.jpg',
        100000000,
        [tGenreModel],
        'https://example.com',
        1,
        'tt1234567',
        'en',
        'Original Title',
        'This is the movie overview.',
        120.5,
        '/poster.jpg',
        '2024-05-01',
        500000000,
        120,
        'Released',
        'This is the tagline.',
        'Test Movie',
        false,
        8.5,
        1000,
      ]);
    });
  });
}
