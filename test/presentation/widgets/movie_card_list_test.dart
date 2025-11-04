import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  final testMovie = Movie(
    id: 1,
    title: 'Test Movie',
    overview: 'This is a test movie overview',
    posterPath: '/test.jpg',
    backdropPath: '/backdrop.jpg',
    voteAverage: 8.0,
    voteCount: 100,
    popularity: 100.0,
    releaseDate: '2025-01-01',
    originalTitle: 'Test Movie Original',
    adult: false,
    genreIds: [1, 2],
    video: false,
  );

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Material(child: body), // Material ancestor untuk InkWell
      routes: {
        MovieDetailPage.ROUTE_NAME: (context) =>
            const Scaffold(body: Text('Movie Detail Page')),
      },
    );
  }

  testWidgets('should display movie title, overview, and poster', (
    tester,
  ) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(_makeTestableWidget(MovieCard(testMovie)));
      await tester.pump();

      expect(find.text('Test Movie'), findsOneWidget);
      expect(find.text('This is a test movie overview'), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });
  });

  testWidgets('should navigate to MovieDetailPage when tapped', (tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(_makeTestableWidget(MovieCard(testMovie)));
      await tester.pump();

      // tap the card
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle(); // biar navigator push selesai

      // cek navigasi
      expect(find.text('Movie Detail Page'), findsOneWidget);
    });
  });

  testWidgets('should display placeholder while loading image', (tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(_makeTestableWidget(MovieCard(testMovie)));

      // placeholder CircularProgressIndicator harus muncul
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
