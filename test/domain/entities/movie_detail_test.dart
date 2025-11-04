import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/genre.dart';

void main() {
  group('MovieDetail Entity', () {
    test('should create a MovieDetail instance with correct values', () {
      // Arrange
      final genres = [
        Genre(id: 1, name: 'Action'),
        Genre(id: 2, name: 'Drama'),
      ];
      final movieDetail = MovieDetail(
        adult: false,
        backdropPath: '/backdrop.jpg',
        genres: genres,
        id: 1,
        originalTitle: 'Original Title',
        overview: 'Overview',
        posterPath: '/poster.jpg',
        releaseDate: '2023-01-01',
        runtime: 120,
        title: 'Movie Title',
        voteAverage: 8.5,
        voteCount: 100,
      );

      // Assert
      expect(movieDetail.adult, false);
      expect(movieDetail.backdropPath, '/backdrop.jpg');
      expect(movieDetail.genres, genres);
      expect(movieDetail.id, 1);
      expect(movieDetail.originalTitle, 'Original Title');
      expect(movieDetail.overview, 'Overview');
      expect(movieDetail.posterPath, '/poster.jpg');
      expect(movieDetail.releaseDate, '2023-01-01');
      expect(movieDetail.runtime, 120);
      expect(movieDetail.title, 'Movie Title');
      expect(movieDetail.voteAverage, 8.5);
      expect(movieDetail.voteCount, 100);
    });

    test(
      'should consider two MovieDetail instances with same properties as equal',
      () {
        // Arrange
        final genres = [Genre(id: 1, name: 'Action')];
        final movie1 = MovieDetail(
          adult: false,
          backdropPath: '/backdrop.jpg',
          genres: genres,
          id: 1,
          originalTitle: 'Original Title',
          overview: 'Overview',
          posterPath: '/poster.jpg',
          releaseDate: '2023-01-01',
          runtime: 120,
          title: 'Movie Title',
          voteAverage: 8.5,
          voteCount: 100,
        );

        final movie2 = MovieDetail(
          adult: false,
          backdropPath: '/backdrop.jpg',
          genres: genres,
          id: 1,
          originalTitle: 'Original Title',
          overview: 'Overview',
          posterPath: '/poster.jpg',
          releaseDate: '2023-01-01',
          runtime: 120,
          title: 'Movie Title',
          voteAverage: 8.5,
          voteCount: 100,
        );

        // Assert
        expect(movie1, movie2);
      },
    );

    test(
      'should consider two MovieDetail instances with different properties as not equal',
      () {
        final movie1 = MovieDetail(
          adult: false,
          backdropPath: '/backdrop.jpg',
          genres: [Genre(id: 1, name: 'Action')],
          id: 1,
          originalTitle: 'Original Title',
          overview: 'Overview',
          posterPath: '/poster.jpg',
          releaseDate: '2023-01-01',
          runtime: 120,
          title: 'Movie Title',
          voteAverage: 8.5,
          voteCount: 100,
        );

        final movie2 = MovieDetail(
          adult: true,
          backdropPath: '/backdrop2.jpg',
          genres: [Genre(id: 2, name: 'Drama')],
          id: 2,
          originalTitle: 'Another Title',
          overview: 'Another Overview',
          posterPath: '/poster2.jpg',
          releaseDate: '2023-02-01',
          runtime: 90,
          title: 'Another Movie',
          voteAverage: 7.0,
          voteCount: 50,
        );

        expect(movie1 == movie2, false);
      },
    );
  });
}
