import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';

// Generate mocks
@GenerateMocks([MovieRepository])
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
  });

  final testMovie = Movie.watchlist(
    id: 1,
    title: 'Movie 1',
    overview: 'Overview Movie 1',
    posterPath: '/path1.jpg',
  );

  final testMovieDetail = MovieDetail(
    adult: false,
    backdropPath: '/backdrop.jpg',
    genres: [],
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

  group('MovieRepository', () {
    test('should get list of now playing movies', () async {
      when(
        mockMovieRepository.getNowPlayingMovies(),
      ).thenAnswer((_) async => Right([testMovie]));

      final result = await mockMovieRepository.getNowPlayingMovies();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should not fail'),
        (movies) => expect(movies, [testMovie]),
      );
      verify(mockMovieRepository.getNowPlayingMovies()).called(1);
    });

    test('should get list of popular movies', () async {
      when(
        mockMovieRepository.getPopularMovies(),
      ).thenAnswer((_) async => Right([testMovie]));

      final result = await mockMovieRepository.getPopularMovies();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should not fail'),
        (movies) => expect(movies, [testMovie]),
      );
      verify(mockMovieRepository.getPopularMovies()).called(1);
    });

    test('should get list of top rated movies', () async {
      when(
        mockMovieRepository.getTopRatedMovies(),
      ).thenAnswer((_) async => Right([testMovie]));

      final result = await mockMovieRepository.getTopRatedMovies();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should not fail'),
        (movies) => expect(movies, [testMovie]),
      );
      verify(mockMovieRepository.getTopRatedMovies()).called(1);
    });

    test('should get movie detail by id', () async {
      when(
        mockMovieRepository.getMovieDetail(1),
      ).thenAnswer((_) async => Right(testMovieDetail));

      final result = await mockMovieRepository.getMovieDetail(1);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should not fail'),
        (detail) => expect(detail, testMovieDetail),
      );
      verify(mockMovieRepository.getMovieDetail(1)).called(1);
    });

    test('should get movie recommendations', () async {
      when(
        mockMovieRepository.getMovieRecommendations(1),
      ).thenAnswer((_) async => Right([testMovie]));

      final result = await mockMovieRepository.getMovieRecommendations(1);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should not fail'),
        (movies) => expect(movies, [testMovie]),
      );
      verify(mockMovieRepository.getMovieRecommendations(1)).called(1);
    });

    test('should search movies by query', () async {
      when(
        mockMovieRepository.searchMovies('test'),
      ).thenAnswer((_) async => Right([testMovie]));

      final result = await mockMovieRepository.searchMovies('test');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should not fail'),
        (movies) => expect(movies, [testMovie]),
      );
      verify(mockMovieRepository.searchMovies('test')).called(1);
    });

    test('should save movie to watchlist', () async {
      when(
        mockMovieRepository.saveWatchlist(testMovieDetail),
      ).thenAnswer((_) async => const Right('Added to Watchlist'));

      final result = await mockMovieRepository.saveWatchlist(testMovieDetail);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should not fail'),
        (msg) => expect(msg, 'Added to Watchlist'),
      );
      verify(mockMovieRepository.saveWatchlist(testMovieDetail)).called(1);
    });

    test('should remove movie from watchlist', () async {
      when(
        mockMovieRepository.removeWatchlist(testMovieDetail),
      ).thenAnswer((_) async => const Right('Removed from Watchlist'));

      final result = await mockMovieRepository.removeWatchlist(testMovieDetail);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should not fail'),
        (msg) => expect(msg, 'Removed from Watchlist'),
      );
      verify(mockMovieRepository.removeWatchlist(testMovieDetail)).called(1);
    });

    test('should check if movie is added to watchlist', () async {
      when(
        mockMovieRepository.isAddedToWatchlist(1),
      ).thenAnswer((_) async => true);

      final result = await mockMovieRepository.isAddedToWatchlist(1);

      expect(result, true);
      verify(mockMovieRepository.isAddedToWatchlist(1)).called(1);
    });

    test('should get watchlist movies', () async {
      when(
        mockMovieRepository.getWatchlistMovies(),
      ).thenAnswer((_) async => Right([testMovie]));

      final result = await mockMovieRepository.getWatchlistMovies();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should not fail'),
        (movies) => expect(movies, [testMovie]),
      );
      verify(mockMovieRepository.getWatchlistMovies()).called(1);
    });
  });
}
