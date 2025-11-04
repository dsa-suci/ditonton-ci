import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tGenreModel = GenreModel(id: 1, name: 'Action');

  group('GenreModel', () {
    test('fromJson should return a valid model', () {
      // arrange
      final Map<String, dynamic> jsonMap = {"id": 1, "name": "Action"};

      // act
      final result = GenreModel.fromJson(jsonMap);

      // assert
      expect(result, equals(tGenreModel));
      expect(result.id, 1);
      expect(result.name, 'Action');
    });

    test('toJson should return a valid JSON map', () {
      // act
      final result = tGenreModel.toJson();

      // assert
      final expectedJson = {"id": 1, "name": "Action"};
      expect(result, equals(expectedJson));
    });

    test('toEntity should return a valid Genre entity', () {
      // act
      final result = tGenreModel.toEntity();

      // assert
      final expectedEntity = Genre(id: 1, name: 'Action');
      expect(result, equals(expectedEntity));
    });

    test('props should contain [id, name]', () {
      // act
      final props = tGenreModel.props;

      // assert
      expect(props, [1, 'Action']);
    });
  });
}
