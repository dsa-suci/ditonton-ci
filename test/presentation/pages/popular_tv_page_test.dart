import 'package:ditonton/presentation/blocs/popular_tv/popular_tv_bloc.dart';
import 'package:ditonton/presentation/pages/popular_tv_page.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_object.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockPopularTvBloc mockPopularTvBloc;

  setUp(() {
    mockPopularTvBloc = MockPopularTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<PopularTvBloc>.value(
        value: mockPopularTvBloc,
        child: body,
      ),
    );
  }

  group('PopularTvPage', () {
    testWidgets(
      'should display CircularProgressIndicator when state is loading',
      (WidgetTester tester) async {
        when(
          mockPopularTvBloc.stream,
        ).thenAnswer((_) => Stream.value(PopularTvLoading()));
        when(mockPopularTvBloc.state).thenReturn(PopularTvLoading());

        await tester.pumpWidget(_makeTestableWidget(const PopularTvPage()));
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('should display ListView when state has data', (
      WidgetTester tester,
    ) async {
      when(
        mockPopularTvBloc.stream,
      ).thenAnswer((_) => Stream.value(PopularTvHasData(testTvList)));
      when(mockPopularTvBloc.state).thenReturn(PopularTvHasData(testTvList));

      await tester.pumpWidget(_makeTestableWidget(const PopularTvPage()));
      await tester.pump();

      // Pastikan TvCard muncul sesuai jumlah data
      expect(find.byType(TvCard), findsNWidgets(testTvList.length));
    });

    testWidgets('should display error message when state is error', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Failed to fetch data';
      when(
        mockPopularTvBloc.stream,
      ).thenAnswer((_) => Stream.value(PopularTvError(errorMessage)));
      when(mockPopularTvBloc.state).thenReturn(PopularTvError(errorMessage));

      await tester.pumpWidget(_makeTestableWidget(const PopularTvPage()));
      await tester.pump();

      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });
  });
}
