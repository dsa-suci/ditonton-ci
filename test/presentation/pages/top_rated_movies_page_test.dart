import 'package:ditonton/presentation/blocs/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_object.dart';
import '../../helpers/test_helper.mocks.dart';

/// Dummy state class untuk kondisi unknown/default
class FakeTopRatedMoviesState extends TopRatedMoviesState {}

void main() {
  late MockTopRatedMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<TopRatedMoviesBloc>.value(
        value: mockBloc,
        child: body,
      ),
    );
  }

  group('TopRatedMoviesPage', () {
    testWidgets(
      'should display CircularProgressIndicator when state is loading',
      (WidgetTester tester) async {
        // Stub stream & state
        when(mockBloc.stream).thenAnswer(
          (_) => Stream<TopRatedMoviesState>.fromIterable([
            TopRatedMoviesLoading(),
          ]),
        );
        when(mockBloc.state).thenReturn(TopRatedMoviesLoading());

        await tester.pumpWidget(
          _makeTestableWidget(const TopRatedMoviesPage()),
        );
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('should display ListView when state has data', (
      WidgetTester tester,
    ) async {
      when(mockBloc.stream).thenAnswer(
        (_) => Stream<TopRatedMoviesState>.fromIterable([
          TopRatedMoviesHasData(testMovieList),
        ]),
      );
      when(mockBloc.state).thenReturn(TopRatedMoviesHasData(testMovieList));

      await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(MovieCard), findsNWidgets(testMovieList.length));
    });

    testWidgets('should display error message when state is error', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Failed to fetch data';

      when(mockBloc.stream).thenAnswer(
        (_) => Stream<TopRatedMoviesState>.fromIterable([
          TopRatedMoviesError(errorMessage),
        ]),
      );
      when(mockBloc.state).thenReturn(TopRatedMoviesError(errorMessage));

      await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));
      await tester.pump();

      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should display empty SizedBox when state is unknown', (
      WidgetTester tester,
    ) async {
      final unknownState = FakeTopRatedMoviesState();

      when(mockBloc.stream).thenAnswer(
        (_) => Stream<TopRatedMoviesState>.fromIterable([unknownState]),
      );
      when(mockBloc.state).thenReturn(unknownState);

      await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));
      await tester.pump();

      expect(find.byType(SizedBox), findsOneWidget);
    });
  });
}
