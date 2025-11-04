import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/blocs/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_object.dart'; // ambil dummy data
import '../../helpers/test_helper.mocks.dart';

/// Dummy state untuk kondisi unknown/default
class FakeTvDetailState extends TvDetailState {
  FakeTvDetailState()
    : super(
        tvDetailState: RequestState.Empty,
        tvDetail: null,
        recommendations: const [],
        isAddedToWatchlist: false,
        message: '',
        watchlistMessage: '',
        recommendationState: RequestState.Empty,
      );
}

void main() {
  late MockTvDetailBloc mockBloc;
  const testId = 1;

  setUp(() {
    mockBloc = MockTvDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<TvDetailBloc>.value(value: mockBloc, child: body),
    );
  }

  group('TvDetailPage', () {
    testWidgets(
      'should display CircularProgressIndicator when state is loading',
      (WidgetTester tester) async {
        when(mockBloc.stream).thenAnswer(
          (_) => Stream<TvDetailState>.fromIterable([
            TvDetailState.initial().copyWith(
              tvDetailState: RequestState.Loading,
            ),
          ]),
        );
        when(mockBloc.state).thenReturn(
          TvDetailState.initial().copyWith(tvDetailState: RequestState.Loading),
        );

        await tester.pumpWidget(
          _makeTestableWidget(const TvDetailPage(id: testId)),
        );
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('should display detail content when state is loaded', (
      WidgetTester tester,
    ) async {
      // gunakan dummy_object untuk tvDetail, tapi kosongkan rekomendasi
      when(mockBloc.stream).thenAnswer(
        (_) => Stream<TvDetailState>.fromIterable([
          TvDetailState.initial().copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvDetail,
            recommendations: [], // kosongkan rekomendasi
            isAddedToWatchlist: false,
          ),
        ]),
      );
      when(mockBloc.state).thenReturn(
        TvDetailState.initial().copyWith(
          tvDetailState: RequestState.Loaded,
          tvDetail: testTvDetail,
          recommendations: [],
          isAddedToWatchlist: false,
        ),
      );

      await tester.pumpWidget(
        _makeTestableWidget(const TvDetailPage(id: testId)),
      );
      await tester.pump();

      // cek nama & overview dari dummy_object
      expect(find.text(testTvDetail.name), findsOneWidget);
      expect(find.text(testTvDetail.overview), findsOneWidget);

      // rekomendasi kosong → tidak ada TvCard → tidak error
      expect(find.byType(TvCard), findsNothing);
    });

    testWidgets('should display error message when state is error', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Failed to fetch TV detail';

      when(mockBloc.stream).thenAnswer(
        (_) => Stream<TvDetailState>.fromIterable([
          TvDetailState.initial().copyWith(
            tvDetailState: RequestState.Error,
            message: errorMessage,
          ),
        ]),
      );
      when(mockBloc.state).thenReturn(
        TvDetailState.initial().copyWith(
          tvDetailState: RequestState.Error,
          message: errorMessage,
        ),
      );

      await tester.pumpWidget(
        _makeTestableWidget(const TvDetailPage(id: testId)),
      );
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should display default SizedBox when state is unknown', (
      WidgetTester tester,
    ) async {
      final unknownState = FakeTvDetailState();

      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream<TvDetailState>.fromIterable([unknownState]));
      when(mockBloc.state).thenReturn(unknownState);

      await tester.pumpWidget(
        _makeTestableWidget(const TvDetailPage(id: testId)),
      );
      await tester.pump();

      expect(find.byType(SizedBox), findsOneWidget);
    });
  });
}
