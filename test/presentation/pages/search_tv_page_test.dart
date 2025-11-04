import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/blocs/tv_search/tv_search_bloc.dart';
import 'package:ditonton/presentation/pages/search_tv_page.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_object.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvSearchBloc mockTvSearchBloc;

  setUp(() {
    mockTvSearchBloc = MockTvSearchBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<TvSearchBloc>.value(
        value: mockTvSearchBloc,
        child: body,
      ),
    );
  }

  group('SearchTvPage', () {
    testWidgets(
      'should display CircularProgressIndicator when state is loading',
      (WidgetTester tester) async {
        when(mockTvSearchBloc.stream).thenAnswer(
          (_) => Stream.value(
            const TvSearchState(
              state: RequestState.Loading,
              searchResult: [],
              message: '',
            ),
          ),
        );
        when(mockTvSearchBloc.state).thenReturn(
          const TvSearchState(
            state: RequestState.Loading,
            searchResult: [],
            message: '',
          ),
        );

        await tester.pumpWidget(_makeTestableWidget(const SearchTvPage()));
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('should display ListView when state has data', (
      WidgetTester tester,
    ) async {
      when(mockTvSearchBloc.stream).thenAnswer(
        (_) => Stream.value(
          TvSearchState(
            state: RequestState.Loaded,
            searchResult: testTvList,
            message: '',
          ),
        ),
      );
      when(mockTvSearchBloc.state).thenReturn(
        TvSearchState(
          state: RequestState.Loaded,
          searchResult: testTvList,
          message: '',
        ),
      );

      await tester.pumpWidget(_makeTestableWidget(const SearchTvPage()));
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(TvCard), findsNWidgets(testTvList.length));
    });

    testWidgets('should display text "No results found" when data is empty', (
      WidgetTester tester,
    ) async {
      when(mockTvSearchBloc.stream).thenAnswer(
        (_) => Stream.value(
          const TvSearchState(
            state: RequestState.Loaded,
            searchResult: [],
            message: '',
          ),
        ),
      );
      when(mockTvSearchBloc.state).thenReturn(
        const TvSearchState(
          state: RequestState.Loaded,
          searchResult: [],
          message: '',
        ),
      );

      await tester.pumpWidget(_makeTestableWidget(const SearchTvPage()));
      await tester.pump();

      expect(find.text('No results found'), findsOneWidget);
    });

    testWidgets('should display error message when state is error', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Failed to fetch data';
      when(mockTvSearchBloc.stream).thenAnswer(
        (_) => Stream.value(
          const TvSearchState(
            state: RequestState.Error,
            searchResult: [],
            message: errorMessage,
          ),
        ),
      );
      when(mockTvSearchBloc.state).thenReturn(
        const TvSearchState(
          state: RequestState.Error,
          searchResult: [],
          message: errorMessage,
        ),
      );

      await tester.pumpWidget(_makeTestableWidget(const SearchTvPage()));
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should display initial prompt text when state is empty', (
      WidgetTester tester,
    ) async {
      when(mockTvSearchBloc.stream).thenAnswer(
        (_) => Stream.value(
          const TvSearchState(
            state: RequestState.Empty,
            searchResult: [],
            message: '',
          ),
        ),
      );
      when(mockTvSearchBloc.state).thenReturn(
        const TvSearchState(
          state: RequestState.Empty,
          searchResult: [],
          message: '',
        ),
      );

      await tester.pumpWidget(_makeTestableWidget(const SearchTvPage()));
      await tester.pump();

      expect(find.text('Type a TV series title to search'), findsOneWidget);
    });
  });
}
