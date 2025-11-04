import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testTv = Tv(
    id: 1,
    name: 'Test TV',
    overview: 'This is a test TV overview',
    posterPath: '/test.jpg',
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2020-01-01',
    voteAverage: 8.0,
  );

  Widget makeTestableWidget(Widget body, {RouteFactory? onGenerateRoute}) {
    return MaterialApp(
      onGenerateRoute: onGenerateRoute,
      home: Scaffold(body: body),
    );
  }

  group('TvCard Widget', () {
    testWidgets('Should display name, overview and poster image', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(makeTestableWidget(TvCard(testTv)));

      // Nama TV muncul
      expect(find.text('Test TV'), findsOneWidget);
      // Overview muncul
      expect(find.text('This is a test TV overview'), findsOneWidget);
      // Image muncul (CachedNetworkImage)
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('Should navigate to TvDetailPage when tapped', (
      WidgetTester tester,
    ) async {
      int? tappedTvId;

      await tester.pumpWidget(
        makeTestableWidget(
          TvCard(testTv),
          onGenerateRoute: (settings) {
            if (settings.name == TvDetailPage.ROUTE_NAME) {
              tappedTvId = settings.arguments as int?;
              return MaterialPageRoute(builder: (_) => Container());
            }
            return null;
          },
        ),
      );

      // Tap TvCard
      await tester.tap(find.byType(TvCard));
      await tester.pumpAndSettle();

      // Pastikan navigator menerima argument yang benar
      expect(tappedTvId, testTv.id);
    });
  });
}
