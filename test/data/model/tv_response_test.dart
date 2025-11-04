import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';

void main() {
  final tTvModel = TvModel(
    id: 1,
    name: 'Test TV',
    overview: 'Overview of Test TV',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2022-01-01',
    voteAverage: 8.5,
  );

  final tTvModelList = [tTvModel];

  final tTvResponse = TvResponse(tvList: tTvModelList);

  final tTvResponseJson = {
    "results": [
      {
        "id": 1,
        "name": "Test TV",
        "overview": "Overview of Test TV",
        "poster_path": "/poster.jpg",
        "backdrop_path": "/backdrop.jpg",
        "first_air_date": "2022-01-01",
        "vote_average": 8.5,
      },
    ],
  };

  group('TvResponse', () {
    test('should convert from JSON correctly', () {
      final result = TvResponse.fromJson(tTvResponseJson);

      expect(result.tvList, tTvModelList);
      expect(result, tTvResponse);
    });

    test('should convert to JSON correctly', () {
      final result = tTvResponse.toJson();

      expect(result, tTvResponseJson);
    });

    test('should support equality comparison (Equatable)', () {
      final anotherResponse = TvResponse(tvList: tTvModelList);

      expect(tTvResponse, equals(anotherResponse));
      expect(tTvResponse.props, [tTvModelList]);
    });
  });
}
