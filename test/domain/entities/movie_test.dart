import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/domain/entities/movie.dart';

void main() {
  group('Movie Entity', () {
    test('should create a Movie instance with main constructor', () {
      // Arrange
      final movie = Movie(
        adult: false,
        backdropPath: '/backdrop.jpg',
        genreIds: [1, 2, 3],
        id: 1,
        originalTitle: 'Original Title',
        overview: 'Overview',
        popularity: 10.0,
        posterPath: '/poster.jpg',
        releaseDate: '2023-01-01',
        title: 'Movie Title',
        video: false,
        voteAverage: 8.5,
        voteCount: 100,
      );

      // Assert
      expect(movie.adult, false);
      expect(movie.backdropPath, '/backdrop.jpg');
      expect(movie.genreIds, [1, 2, 3]);
      expect(movie.id, 1);
      expect(movie.originalTitle, 'Original Title');
      expect(movie.overview, 'Overview');
      expect(movie.popularity, 10.0);
      expect(movie.posterPath, '/poster.jpg');
      expect(movie.releaseDate, '2023-01-01');
      expect(movie.title, 'Movie Title');
      expect(movie.video, false);
      expect(movie.voteAverage, 8.5);
      expect(movie.voteCount, 100);
    });

    test('should create a Movie instance with watchlist constructor', () {
      // Arrange
      final movie = Movie.watchlist(
        id: 1,
        overview: 'Overview',
        posterPath: '/poster.jpg',
        title: 'Movie Title',
      );

      // Assert
      expect(movie.id, 1);
      expect(movie.overview, 'Overview');
      expect(movie.posterPath, '/poster.jpg');
      expect(movie.title, 'Movie Title');

      // Other fields should be null
      expect(movie.adult, null);
      expect(movie.backdropPath, null);
      expect(movie.genreIds, null);
      expect(movie.originalTitle, null);
      expect(movie.popularity, null);
      expect(movie.releaseDate, null);
      expect(movie.video, null);
      expect(movie.voteAverage, null);
      expect(movie.voteCount, null);
    });

    test(
      'should consider two Movie instances with same properties as equal',
      () {
        final movie1 = Movie.watchlist(
          id: 1,
          overview: 'Overview',
          posterPath: '/poster.jpg',
          title: 'Movie Title',
        );

        final movie2 = Movie.watchlist(
          id: 1,
          overview: 'Overview',
          posterPath: '/poster.jpg',
          title: 'Movie Title',
        );

        expect(movie1, movie2);
      },
    );

    test(
      'should consider two Movie instances with different properties as not equal',
      () {
        final movie1 = Movie.watchlist(
          id: 1,
          overview: 'Overview',
          posterPath: '/poster.jpg',
          title: 'Movie Title',
        );

        final movie2 = Movie.watchlist(
          id: 2,
          overview: 'Another Overview',
          posterPath: '/poster2.jpg',
          title: 'Another Title',
        );

        expect(movie1 == movie2, false);
      },
    );
  });
}
