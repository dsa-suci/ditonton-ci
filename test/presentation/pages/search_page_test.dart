import 'package:ditonton/presentation/blocs/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_object.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockMovieSearchBloc mockMovieSearchBloc;

  setUp(() {
    mockMovieSearchBloc = MockMovieSearchBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<MovieSearchBloc>.value(
        value: mockMovieSearchBloc,
        child: body,
      ),
    );
  }

  group('SearchPage', () {
    testWidgets(
      'should display CircularProgressIndicator when state is loading',
      (WidgetTester tester) async {
        when(
          mockMovieSearchBloc.stream,
        ).thenAnswer((_) => Stream.value(MovieSearchLoading()));
        when(mockMovieSearchBloc.state).thenReturn(MovieSearchLoading());

        await tester.pumpWidget(_makeTestableWidget(const SearchPage()));
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('should display ListView when state has data', (
      WidgetTester tester,
    ) async {
      when(
        mockMovieSearchBloc.stream,
      ).thenAnswer((_) => Stream.value(MovieSearchHasData(testMovieList)));
      when(
        mockMovieSearchBloc.state,
      ).thenReturn(MovieSearchHasData(testMovieList));

      await tester.pumpWidget(_makeTestableWidget(const SearchPage()));
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(MovieCard), findsNWidgets(testMovieList.length));
    });

    testWidgets(
      'should display text "No movies found" when state has empty data',
      (WidgetTester tester) async {
        when(
          mockMovieSearchBloc.stream,
        ).thenAnswer((_) => Stream.value(MovieSearchHasData([])));
        when(mockMovieSearchBloc.state).thenReturn(MovieSearchHasData([]));

        await tester.pumpWidget(_makeTestableWidget(const SearchPage()));
        await tester.pump();

        expect(find.text('No movies found'), findsOneWidget);
      },
    );

    testWidgets('should display error message when state is error', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Failed to fetch data';
      when(
        mockMovieSearchBloc.stream,
      ).thenAnswer((_) => Stream.value(MovieSearchError(errorMessage)));
      when(
        mockMovieSearchBloc.state,
      ).thenReturn(MovieSearchError(errorMessage));

      await tester.pumpWidget(_makeTestableWidget(const SearchPage()));
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should display prompt text when state is empty', (
      WidgetTester tester,
    ) async {
      when(
        mockMovieSearchBloc.stream,
      ).thenAnswer((_) => Stream.value(MovieSearchEmpty()));
      when(mockMovieSearchBloc.state).thenReturn(MovieSearchEmpty());

      await tester.pumpWidget(_makeTestableWidget(const SearchPage()));
      await tester.pump();

      expect(find.text('Search for a movie...'), findsOneWidget);
    });
  });
}
