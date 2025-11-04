import 'dart:convert';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../json_reader.dart';
import 'tv_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late TvRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = TvRemoteDataSourceImpl(client: mockHttpClient);
  });

  const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';

  group('get Now Playing TV', () {
    final tTvList = TvResponse.fromJson(
      json.decode(readJson('dummy_data/now_playing_tv.json')),
    ).tvList;

    test('should return list of TV Model when response code is 200', () async {
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/now_playing_tv.json'), 200),
      );

      final result = await dataSource.getNowPlayingTv();

      expect(result, equals(tTvList));
    });

    test(
      'should throw Exception when response code is other than 200',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final call = dataSource.getNowPlayingTv();

        expect(() => call, throwsA(isA<Exception>())); // ✅ diperbaiki
      },
    );
  });

  group('get Popular TV', () {
    final tTvList = TvResponse.fromJson(
      json.decode(readJson('dummy_data/popular_tv.json')),
    ).tvList;

    test('should return list of TV when response code is 200', () async {
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')),
      ).thenAnswer(
        (_) async => http.Response(readJson('dummy_data/popular_tv.json'), 200),
      );

      final result = await dataSource.getPopularTv();
      expect(result, equals(tTvList));
    });

    test(
      'should throw Exception when response code is other than 200',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')),
        ).thenAnswer((_) async => http.Response('Error', 404));

        final call = dataSource.getPopularTv();

        expect(() => call, throwsA(isA<Exception>())); // ✅ diperbaiki
      },
    );
  });

  group('get Top Rated TV', () {
    final tTvList = TvResponse.fromJson(
      json.decode(readJson('dummy_data/top_rated_tv.json')),
    ).tvList;

    test(
      'should return list of Top Rated TV when response code is 200',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/top_rated_tv.json'), 200),
        );

        final result = await dataSource.getTopRatedTv();
        expect(result, equals(tTvList));
      },
    );

    test('should throw Exception when response code is 404', () async {
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTopRatedTv();

      expect(() => call, throwsA(isA<Exception>())); // ✅ diperbaiki
    });
  });

  group('get TV Detail', () {
    const tId = 1;
    final tTvDetail = TvDetailModel.fromJson(
      json.decode(readJson('dummy_data/tv_detail.json')),
    );

    test('should return TV detail when response code is 200', () async {
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')),
      ).thenAnswer(
        (_) async => http.Response(readJson('dummy_data/tv_detail.json'), 200),
      );

      final result = await dataSource.getTvDetail(tId);
      expect(result, equals(tTvDetail));
    });

    test('should throw Exception when response code is 404', () async {
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTvDetail(tId);

      expect(() => call, throwsA(isA<Exception>())); // ✅ diperbaiki
    });
  });

  group('get TV Recommendations', () {
    const tId = 1;
    final tTvList = TvResponse.fromJson(
      json.decode(readJson('dummy_data/tv_recommendations.json')),
    ).tvList;

    test('should return list of TV when response code is 200', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey'),
        ),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/tv_recommendations.json'), 200),
      );

      final result = await dataSource.getTvRecommendations(tId);
      expect(result, equals(tTvList));
    });

    test('should throw Exception when response code is 404', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey'),
        ),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTvRecommendations(tId);

      expect(() => call, throwsA(isA<Exception>())); // ✅ diperbaiki
    });
  });

  group('search TV', () {
    const tQuery = 'Breaking Bad';
    final tSearchResult = TvResponse.fromJson(
      json.decode(readJson('dummy_data/search_tv.json')),
    ).tvList;

    test('should return search result when response code is 200', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$baseUrl/search/tv?$apiKey&query=Breaking%20Bad'),
        ),
      ).thenAnswer(
        (_) async => http.Response(readJson('dummy_data/search_tv.json'), 200),
      );

      final result = await dataSource.searchTv(tQuery);
      expect(result, tSearchResult);
    });

    test('should throw Exception when response code is 404', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$baseUrl/search/tv?$apiKey&query=Breaking%20Bad'),
        ),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.searchTv(tQuery);

      expect(() => call, throwsA(isA<Exception>())); // ✅ diperbaiki
    });
  });
}
