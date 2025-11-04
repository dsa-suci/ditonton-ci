import 'package:ditonton/data/models/movie_model.dart';
import 'package:ditonton/data/models/movie_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMovieModel = MovieModel(
    adult: false,
    backdropPath: '/backdrop.jpg',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 10.0,
    posterPath: '/poster.jpg',
    releaseDate: '2024-01-01',
    title: 'Test Movie',
    video: false,
    voteAverage: 8.0,
    voteCount: 100,
  );

  final tMovieResponse = MovieResponse(movieList: [tMovieModel]);

  group('MovieResponse', () {
    test('fromJson should return a valid model', () {
      final Map<String, dynamic> jsonMap = {
        "results": [
          {
            "adult": false,
            "backdrop_path": "/backdrop.jpg",
            "genre_ids": [1, 2, 3],
            "id": 1,
            "original_title": "Original Title",
            "overview": "Overview",
            "popularity": 10.0,
            "poster_path": "/poster.jpg",
            "release_date": "2024-01-01",
            "title": "Test Movie",
            "video": false,
            "vote_average": 8.0,
            "vote_count": 100,
          },
          {
            // ini akan diabaikan karena poster_path == null
            "adult": false,
            "backdrop_path": "/backdrop2.jpg",
            "genre_ids": [4, 5],
            "id": 2,
            "original_title": "No Poster",
            "overview": "No Poster Overview",
            "popularity": 5.0,
            "poster_path": null,
            "release_date": "2024-02-01",
            "title": "Movie Without Poster",
            "video": false,
            "vote_average": 6.5,
            "vote_count": 50,
          },
        ],
      };

      final result = MovieResponse.fromJson(jsonMap);

      expect(result.movieList.length, 1);
      expect(result, equals(tMovieResponse));
      expect(result.movieList.first.title, 'Test Movie');
    });

    test('toJson should return a valid JSON map', () {
      final result = tMovieResponse.toJson();

      final expectedJson = {
        "results": [
          {
            "adult": false,
            "backdrop_path": "/backdrop.jpg",
            "genre_ids": [1, 2, 3],
            "id": 1,
            "original_title": "Original Title",
            "overview": "Overview",
            "popularity": 10.0,
            "poster_path": "/poster.jpg",
            "release_date": "2024-01-01",
            "title": "Test Movie",
            "video": false,
            "vote_average": 8.0,
            "vote_count": 100,
          },
        ],
      };

      expect(result, equals(expectedJson));
    });

    test('props should contain movieList', () {
      expect(tMovieResponse.props, [tMovieResponse.movieList]);
    });
  });
}
