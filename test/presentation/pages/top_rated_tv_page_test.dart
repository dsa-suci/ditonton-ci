import 'package:ditonton/presentation/blocs/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_object.dart';
import '../../helpers/test_helper.mocks.dart';

/// Dummy state class untuk kondisi unknown/default
class FakeTopRatedTvState extends TopRatedTvState {}

void main() {
  late MockTopRatedTvBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<TopRatedTvBloc>.value(value: mockBloc, child: body),
    );
  }

  group('TopRatedTvPage', () {
    testWidgets(
      'should display CircularProgressIndicator when state is loading',
      (WidgetTester tester) async {
        // Stub stream & state
        when(mockBloc.stream).thenAnswer(
          (_) => Stream<TopRatedTvState>.fromIterable([TopRatedTvLoading()]),
        );
        when(mockBloc.state).thenReturn(TopRatedTvLoading());

        await tester.pumpWidget(_makeTestableWidget(const TopRatedTvPage()));
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('should display ListView when state has data', (
      WidgetTester tester,
    ) async {
      when(mockBloc.stream).thenAnswer(
        (_) => Stream<TopRatedTvState>.fromIterable([
          TopRatedTvHasData(testTvList),
        ]),
      );
      when(mockBloc.state).thenReturn(TopRatedTvHasData(testTvList));

      await tester.pumpWidget(_makeTestableWidget(const TopRatedTvPage()));
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(TvCard), findsNWidgets(testTvList.length));
    });

    testWidgets('should display error message when state is error', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Failed to fetch data';

      when(mockBloc.stream).thenAnswer(
        (_) => Stream<TopRatedTvState>.fromIterable([
          TopRatedTvError(errorMessage),
        ]),
      );
      when(mockBloc.state).thenReturn(TopRatedTvError(errorMessage));

      await tester.pumpWidget(_makeTestableWidget(const TopRatedTvPage()));
      await tester.pump();

      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should display default text when state is unknown', (
      WidgetTester tester,
    ) async {
      final unknownState = FakeTopRatedTvState();

      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream<TopRatedTvState>.fromIterable([unknownState]));
      when(mockBloc.state).thenReturn(unknownState);

      await tester.pumpWidget(_makeTestableWidget(const TopRatedTvPage()));
      await tester.pump();

      expect(find.text('No Data Available'), findsOneWidget);
    });
  });
}
