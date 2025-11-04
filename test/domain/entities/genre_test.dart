import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/domain/entities/genre.dart';

void main() {
  group('Genre Entity', () {
    test('should create a Genre instance with correct values', () {
      // Arrange
      const id = 1;
      const name = 'Action';

      // Act
      final genre = Genre(id: id, name: name);

      // Assert
      expect(genre.id, id);
      expect(genre.name, name);
    });

    test(
      'should consider two Genre instances with same properties as equal',
      () {
        // Arrange
        final genre1 = Genre(id: 1, name: 'Action');
        final genre2 = Genre(id: 1, name: 'Action');

        // Act & Assert
        expect(genre1, genre2);
      },
    );

    test(
      'should consider two Genre instances with different properties as not equal',
      () {
        // Arrange
        final genre1 = Genre(id: 1, name: 'Action');
        final genre2 = Genre(id: 2, name: 'Drama');

        // Act & Assert
        expect(genre1 == genre2, false);
      },
    );
  });
}
