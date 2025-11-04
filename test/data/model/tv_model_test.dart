import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/domain/entities/tv.dart';

void main() {
  const tTvModel = TvModel(
    id: 1,
    name: 'Test TV',
    overview: 'Overview of Test TV',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2022-01-01',
    voteAverage: 8.5,
  );

  final tTvJson = {
    'id': 1,
    'name': 'Test TV',
    'overview': 'Overview of Test TV',
    'poster_path': '/poster.jpg',
    'backdrop_path': '/backdrop.jpg',
    'first_air_date': '2022-01-01',
    'vote_average': 8.5,
  };

  group('TvModel', () {
    test('should convert from JSON correctly', () {
      final result = TvModel.fromJson(tTvJson);

      expect(result, tTvModel);
      expect(result.id, 1);
      expect(result.name, 'Test TV');
    });

    test('should convert to JSON correctly', () {
      final result = tTvModel.toJson();

      expect(result, tTvJson);
    });

    test('should convert to entity correctly', () {
      final result = tTvModel.toEntity();

      expect(result, isA<Tv>());
      expect(result.id, tTvModel.id);
      expect(result.name, tTvModel.name);
      expect(result.overview, tTvModel.overview);
      expect(result.posterPath, tTvModel.posterPath);
    });

    test('props should contain correct values for Equatable', () {
      final result = tTvModel.props;

      expect(result, [
        1,
        'Test TV',
        'Overview of Test TV',
        '/poster.jpg',
        '/backdrop.jpg',
        '2022-01-01',
        8.5,
      ]);
    });

    test('should support equality comparison', () {
      final anotherModel = TvModel(
        id: 1,
        name: 'Test TV',
        overview: 'Overview of Test TV',
        posterPath: '/poster.jpg',
        backdropPath: '/backdrop.jpg',
        firstAirDate: '2022-01-01',
        voteAverage: 8.5,
      );

      expect(tTvModel, equals(anotherModel));
    });
  });
}
