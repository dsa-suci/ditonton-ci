import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/models/movie_model.dart';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

@GenerateMocks([MovieRemoteDataSource, MovieLocalDataSource])
void main() {
  late MovieRepositoryImpl repository;
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MockMovieLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    mockLocalDataSource = MockMovieLocalDataSource();
    repository = MovieRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  // --- Sample data ---
  final tMovieModel = MovieModel(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 10.0,
    posterPath: 'posterPath',
    releaseDate: '2025-01-01',
    title: 'Title',
    video: false,
    voteAverage: 8.0,
    voteCount: 100,
  );

  final tMovie = tMovieModel.toEntity();

  final tMovieDetailModel = MovieDetailResponse(
    adult: false,
    backdropPath: 'backdropPath',
    budget: 1000,
    genres: [GenreModel(id: 1, name: 'Action')],
    homepage: 'https://example.com',
    id: 1,
    imdbId: 'tt1234567',
    originalLanguage: 'en',
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 10.0,
    posterPath: 'posterPath',
    releaseDate: '2025-01-01',
    revenue: 5000,
    runtime: 120,
    status: 'Released',
    tagline: 'Tagline',
    title: 'Title',
    video: false,
    voteAverage: 8.0,
    voteCount: 100,
  );

  final tMovieDetail = tMovieDetailModel.toEntity();
  final tMovieTable = MovieTable.fromEntity(tMovieDetail);

  // --- Tests ---

  group('getNowPlayingMovies', () {
    test('should return list of movies on success', () async {
      when(
        mockRemoteDataSource.getNowPlayingMovies(),
      ).thenAnswer((_) async => [tMovieModel]);

      final result = await repository.getNowPlayingMovies();

      verify(mockRemoteDataSource.getNowPlayingMovies());
      expect(result, isA<Right<Failure, List<Movie>>>());
      expect(result.getOrElse(() => []), [tMovie]);
    });

    test('should return server failure', () async {
      when(
        mockRemoteDataSource.getNowPlayingMovies(),
      ).thenThrow(ServerException());

      final result = await repository.getNowPlayingMovies();

      expect(result, Left(ServerFailure('')));
    });

    test('should return connection failure', () async {
      when(
        mockRemoteDataSource.getNowPlayingMovies(),
      ).thenThrow(SocketException('Failed to connect'));

      final result = await repository.getNowPlayingMovies();

      expect(
        result,
        Left(ConnectionFailure('Failed to connect to the network')),
      );
    });
  });

  group('getPopularMovies', () {
    test('should return list of movies on success', () async {
      when(
        mockRemoteDataSource.getPopularMovies(),
      ).thenAnswer((_) async => [tMovieModel]);

      final result = await repository.getPopularMovies();

      verify(mockRemoteDataSource.getPopularMovies());
      expect(result, isA<Right<Failure, List<Movie>>>());
      expect(result.getOrElse(() => []), [tMovie]);
    });

    test('should return server failure', () async {
      when(
        mockRemoteDataSource.getPopularMovies(),
      ).thenThrow(ServerException());

      final result = await repository.getPopularMovies();

      expect(result, Left(ServerFailure('')));
    });

    test('should return connection failure', () async {
      when(
        mockRemoteDataSource.getPopularMovies(),
      ).thenThrow(SocketException('Failed to connect'));

      final result = await repository.getPopularMovies();

      expect(
        result,
        Left(ConnectionFailure('Failed to connect to the network')),
      );
    });
  });

  group('getTopRatedMovies', () {
    test('should return list of movies on success', () async {
      when(
        mockRemoteDataSource.getTopRatedMovies(),
      ).thenAnswer((_) async => [tMovieModel]);

      final result = await repository.getTopRatedMovies();

      verify(mockRemoteDataSource.getTopRatedMovies());
      expect(result, isA<Right<Failure, List<Movie>>>());
      expect(result.getOrElse(() => []), [tMovie]);
    });

    test('should return server failure', () async {
      when(
        mockRemoteDataSource.getTopRatedMovies(),
      ).thenThrow(ServerException());

      final result = await repository.getTopRatedMovies();

      expect(result, Left(ServerFailure('')));
    });

    test('should return connection failure', () async {
      when(
        mockRemoteDataSource.getTopRatedMovies(),
      ).thenThrow(SocketException('Failed to connect'));

      final result = await repository.getTopRatedMovies();

      expect(
        result,
        Left(ConnectionFailure('Failed to connect to the network')),
      );
    });
  });

  group('getMovieRecommendations', () {
    test('should return list of recommended movies', () async {
      when(
        mockRemoteDataSource.getMovieRecommendations(1),
      ).thenAnswer((_) async => [tMovieModel]);

      final result = await repository.getMovieRecommendations(1);

      verify(mockRemoteDataSource.getMovieRecommendations(1));
      expect(result, isA<Right<Failure, List<Movie>>>());
      expect(result.getOrElse(() => []), [tMovie]);
    });

    test('should return server failure', () async {
      when(
        mockRemoteDataSource.getMovieRecommendations(1),
      ).thenThrow(ServerException());

      final result = await repository.getMovieRecommendations(1);

      expect(result, Left(ServerFailure('')));
    });

    test('should return connection failure', () async {
      when(
        mockRemoteDataSource.getMovieRecommendations(1),
      ).thenThrow(SocketException('Failed to connect'));

      final result = await repository.getMovieRecommendations(1);

      expect(
        result,
        Left(ConnectionFailure('Failed to connect to the network')),
      );
    });
  });

  group('searchMovies', () {
    test('should return list of movies on success', () async {
      when(
        mockRemoteDataSource.searchMovies('query'),
      ).thenAnswer((_) async => [tMovieModel]);

      final result = await repository.searchMovies('query');

      verify(mockRemoteDataSource.searchMovies('query'));
      expect(result, isA<Right<Failure, List<Movie>>>());
      expect(result.getOrElse(() => []), [tMovie]);
    });

    test('should return server failure', () async {
      when(
        mockRemoteDataSource.searchMovies('query'),
      ).thenThrow(ServerException());

      final result = await repository.searchMovies('query');

      expect(result, Left(ServerFailure('')));
    });

    test('should return connection failure', () async {
      when(
        mockRemoteDataSource.searchMovies('query'),
      ).thenThrow(SocketException('Failed to connect'));

      final result = await repository.searchMovies('query');

      expect(
        result,
        Left(ConnectionFailure('Failed to connect to the network')),
      );
    });
  });

  group('getMovieDetail', () {
    test('should return movie detail on success', () async {
      when(
        mockRemoteDataSource.getMovieDetail(1),
      ).thenAnswer((_) async => tMovieDetailModel);

      final result = await repository.getMovieDetail(1);

      verify(mockRemoteDataSource.getMovieDetail(1));
      expect(result, Right(tMovieDetail));
    });

    test('should return server failure', () async {
      when(mockRemoteDataSource.getMovieDetail(1)).thenThrow(ServerException());

      final result = await repository.getMovieDetail(1);

      expect(result, Left(ServerFailure('')));
    });

    test('should return connection failure', () async {
      when(
        mockRemoteDataSource.getMovieDetail(1),
      ).thenThrow(SocketException('Failed to connect'));

      final result = await repository.getMovieDetail(1);

      expect(
        result,
        Left(ConnectionFailure('Failed to connect to the network')),
      );
    });
  });

  group('saveWatchlist', () {
    test('should return success message', () async {
      when(
        mockLocalDataSource.insertWatchlist(tMovieTable),
      ).thenAnswer((_) async => 'Added to Watchlist');

      final result = await repository.saveWatchlist(tMovieDetail);

      verify(mockLocalDataSource.insertWatchlist(tMovieTable));
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure', () async {
      when(
        mockLocalDataSource.insertWatchlist(tMovieTable),
      ).thenThrow(DatabaseException('Failed to insert'));

      final result = await repository.saveWatchlist(tMovieDetail);

      expect(result, Left(DatabaseFailure('Failed to insert')));
    });
  });

  group('removeWatchlist', () {
    test('should return success message', () async {
      when(
        mockLocalDataSource.removeWatchlist(tMovieTable),
      ).thenAnswer((_) async => 'Removed from Watchlist');

      final result = await repository.removeWatchlist(tMovieDetail);

      verify(mockLocalDataSource.removeWatchlist(tMovieTable));
      expect(result, Right('Removed from Watchlist'));
    });

    test('should return DatabaseFailure', () async {
      when(
        mockLocalDataSource.removeWatchlist(tMovieTable),
      ).thenThrow(DatabaseException('Failed to remove'));

      final result = await repository.removeWatchlist(tMovieDetail);

      expect(result, Left(DatabaseFailure('Failed to remove')));
    });
  });

  group('isAddedToWatchlist', () {
    test('should return true when movie exists', () async {
      when(
        mockLocalDataSource.getMovieById(1),
      ).thenAnswer((_) async => tMovieTable);

      final result = await repository.isAddedToWatchlist(1);

      expect(result, true);
    });

    test('should return false when movie does not exist', () async {
      when(mockLocalDataSource.getMovieById(1)).thenAnswer((_) async => null);

      final result = await repository.isAddedToWatchlist(1);

      expect(result, false);
    });
  });
}
