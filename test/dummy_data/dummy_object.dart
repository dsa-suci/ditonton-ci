import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';

final testMovie = Movie(
  id: 1,
  adult: false,
  backdropPath: '/backdrop1.jpg',
  genreIds: [1, 2],
  originalTitle: 'Recommendation Movie Original',
  overview: 'Overview 1',
  popularity: 100.0,
  posterPath: '/poster1.jpg',
  releaseDate: '2025-01-01',
  title: 'Movie 1',
  video: false,
  voteAverage: 7.0,
  voteCount: 100,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  id: 1,
  adult: false,
  title: 'Movie 1',
  overview: 'Overview 1',
  genres: [
    Genre(id: 1, name: 'Action'),
    Genre(id: 2, name: 'Adventure'),
  ],
  runtime: 120,
  voteAverage: 7.0,
  posterPath: '/poster1.jpg',
  backdropPath: '/backdrop1.jpg',
  releaseDate: '2025-01-01',
  originalTitle: 'Original Test Movie',
  voteCount: 100,
);

final testTv = Tv(
  id: 1,
  name: 'Test TV',
  overview: 'Test Overview',
  posterPath: '/poster.jpg',
  backdropPath: '/backdrop.jpg',
  firstAirDate: '2025-01-01',
  voteAverage: 8.0,
);

final testTvList = [testTv];

final testTvDetail = TvDetail(
  id: 1,
  name: 'Test TV',
  overview: 'Test Overview',
  posterPath: '/poster.jpg',
  backdropPath: '/backdrop.jpg',
  firstAirDate: '2025-01-01',
  lastAirDate: '2025-01-10',
  voteAverage: 8.0,
  numberOfSeasons: 2,
  numberOfEpisodes: 24,
  genres: [Genre(id: 1, name: 'Action')],
);

final testTvListEmpty = <Tv>[];
