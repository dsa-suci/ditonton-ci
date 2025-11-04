import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements http.Client {
  @override
  Future<http.Response> get(Uri? url, {Map<String, String>? headers}) =>
      super.noSuchMethod(
        Invocation.method(#get, [url], {#headers: headers}),
        returnValue: Future.value(http.Response('', 200)),
        returnValueForMissingStub: Future.value(http.Response('', 200)),
      );
}

void main() {
  late MovieRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = MovieRemoteDataSourceImpl(client: mockHttpClient);
  });

  const baseUrl = 'https://api.themoviedb.org/3';
  const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';

  group('getNowPlayingMovies', () {
    test(
      'should return list of MovieModel when response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/movie/now_playing?$apiKey')),
        ).thenAnswer(
          (_) async => http.Response('''
          {
            "results": [
              {
                "adult": false,
                "backdrop_path": "/backdrop.jpg",
                "genre_ids": [1, 2],
                "id": 1,
                "original_title": "Original Title",
                "overview": "Overview",
                "popularity": 10.0,
                "poster_path": "/poster.jpg",
                "release_date": "2022-01-01",
                "title": "Test Movie",
                "video": false,
                "vote_average": 8.0,
                "vote_count": 100
              }
            ]
          }
          ''', 200),
        );

        // act
        final result = await dataSource.getNowPlayingMovies();

        // assert
        expect(result.length, 1);
        expect(result.first.title, 'Test Movie');
      },
    );

    test(
      'should throw ServerException when response code is not 200',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/movie/now_playing?$apiKey')),
        ).thenAnswer((_) async => http.Response('Error', 404));

        final call = dataSource.getNowPlayingMovies();
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('getMovieDetail', () {
    const tId = 1;

    test(
      'should return MovieDetailResponse when response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/movie/$tId?$apiKey')),
        ).thenAnswer(
          (_) async => http.Response('''
          {
            "adult": false,
            "backdrop_path": "/backdrop.jpg",
            "budget": 1000000,
            "genres": [{"id": 1, "name": "Action"}],
            "homepage": "https://example.com",
            "id": 1,
            "imdb_id": "tt1234567",
            "original_language": "en",
            "original_title": "Original Title",
            "overview": "Overview",
            "popularity": 10.0,
            "poster_path": "/poster.jpg",
            "release_date": "2022-01-01",
            "revenue": 2000000,
            "runtime": 120,
            "status": "Released",
            "tagline": "Awesome!",
            "title": "Test Movie",
            "video": false,
            "vote_average": 8.0,
            "vote_count": 100
          }
          ''', 200),
        );

        // act
        final result = await dataSource.getMovieDetail(tId);

        // assert
        expect(result, isA<MovieDetailResponse>());
        expect(result.title, equals('Test Movie'));
        expect(result.genres.first.name, equals('Action'));
      },
    );

    test(
      'should throw ServerException when response code is not 200',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/movie/$tId?$apiKey')),
        ).thenAnswer((_) async => http.Response('Error', 404));

        final call = dataSource.getMovieDetail(tId);
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}
