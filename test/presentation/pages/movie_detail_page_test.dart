import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/blocs/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/blocs/movie_detail/movie_detail_state.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<MovieDetailBloc>.value(
        value: mockMovieDetailBloc,
        child: body,
      ),
    );
  }

  group('MovieDetailPage', () {
    final tId = 1;

    testWidgets(
      'should display CircularProgressIndicator when movie state is loading',
      (WidgetTester tester) async {
        when(mockMovieDetailBloc.stream).thenAnswer(
          (_) => Stream.value(
            const MovieDetailState(movieState: RequestState.Loading),
          ),
        );
        when(
          mockMovieDetailBloc.state,
        ).thenReturn(const MovieDetailState(movieState: RequestState.Loading));

        await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: tId)));
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('should display error message when state is error', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Failed to fetch data';
      final errorState = MovieDetailState(
        movieState: RequestState.Error,
        message: errorMessage,
      );

      when(
        mockMovieDetailBloc.stream,
      ).thenAnswer((_) => Stream.value(errorState));
      when(mockMovieDetailBloc.state).thenReturn(errorState);

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: tId)));
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
    });
  });
}
