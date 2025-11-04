import 'package:ditonton/presentation/blocs/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_object.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockPopularMoviesBloc mockPopularMoviesBloc;

  setUp(() {
    mockPopularMoviesBloc = MockPopularMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<PopularMoviesBloc>.value(
        value: mockPopularMoviesBloc,
        child: body,
      ),
    );
  }

  group('PopularMoviesPage', () {
    testWidgets(
      'should display CircularProgressIndicator when state is loading',
      (WidgetTester tester) async {
        when(
          mockPopularMoviesBloc.stream,
        ).thenAnswer((_) => Stream.value(PopularMoviesLoading()));
        when(mockPopularMoviesBloc.state).thenReturn(PopularMoviesLoading());

        await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('should display ListView when state has data', (
      WidgetTester tester,
    ) async {
      when(
        mockPopularMoviesBloc.stream,
      ).thenAnswer((_) => Stream.value(PopularMoviesHasData(testMovieList)));
      when(
        mockPopularMoviesBloc.state,
      ).thenReturn(PopularMoviesHasData(testMovieList));

      await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));
      await tester.pump();

      // Pastikan MovieCard muncul sesuai jumlah data
      expect(find.byType(MovieCard), findsNWidgets(testMovieList.length));
    });

    testWidgets('should display error message when state is error', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Failed to fetch data';
      when(
        mockPopularMoviesBloc.stream,
      ).thenAnswer((_) => Stream.value(PopularMoviesError(errorMessage)));
      when(
        mockPopularMoviesBloc.state,
      ).thenReturn(PopularMoviesError(errorMessage));

      await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));
      await tester.pump();

      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });
  });
}
