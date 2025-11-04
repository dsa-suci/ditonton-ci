import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/genre.dart';

void main() {
  final tGenreModel = GenreModel(id: 1, name: 'Drama');
  final tGenreList = [tGenreModel];

  final tTvDetailModel = TvDetailModel(
    id: 1,
    name: 'Test TV',
    overview: 'Overview of Test TV',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2022-01-01',
    lastAirDate: '2022-12-31',
    voteAverage: 8.5,
    numberOfSeasons: 2,
    numberOfEpisodes: 16,
    genres: [tGenreModel],
  );

  final tTvDetailJson = {
    'id': 1,
    'name': 'Test TV',
    'overview': 'Overview of Test TV',
    'poster_path': '/poster.jpg',
    'backdrop_path': '/backdrop.jpg',
    'first_air_date': '2022-01-01',
    'last_air_date': '2022-12-31',
    'vote_average': 8.5,
    'number_of_seasons': 2,
    'number_of_episodes': 16,
    'genres': [
      {'id': 1, 'name': 'Drama'},
    ],
  };

  group('TvDetailModel', () {
    test('should convert from JSON correctly', () {
      final result = TvDetailModel.fromJson(tTvDetailJson);

      expect(result, tTvDetailModel);
      expect(result.genres.first, tGenreModel);
      expect(result.numberOfSeasons, 2);
    });

    test('should convert to JSON correctly', () {
      final result = tTvDetailModel.toJson();

      expect(result, tTvDetailJson);
    });

    test('should convert to entity correctly', () {
      final result = tTvDetailModel.toEntity();

      expect(result, isA<TvDetail>());
      expect(result.id, tTvDetailModel.id);
      expect(result.genres.first, isA<Genre>());
      expect(result.genres.first.name, 'Drama');
    });

    test('props should contain correct values for Equatable', () {
      final result = tTvDetailModel.props;

      expect(result, [
        1,
        'Test TV',
        'Overview of Test TV',
        '/poster.jpg',
        '/backdrop.jpg',
        '2022-01-01',
        '2022-12-31',
        8.5,
        2,
        16,
        tGenreList,
      ]);
    });

    test('should support equality comparison', () {
      final anotherModel = TvDetailModel(
        id: 1,
        name: 'Test TV',
        overview: 'Overview of Test TV',
        posterPath: '/poster.jpg',
        backdropPath: '/backdrop.jpg',
        firstAirDate: '2022-01-01',
        lastAirDate: '2022-12-31',
        voteAverage: 8.5,
        numberOfSeasons: 2,
        numberOfEpisodes: 16,
        genres: [tGenreModel],
      );

      expect(tTvDetailModel, equals(anotherModel));
    });
  });
}
