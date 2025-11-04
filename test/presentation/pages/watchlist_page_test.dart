import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/blocs/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/blocs/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_object.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockWatchlistMovieBloc mockMovieBloc;
  late MockWatchlistTvBloc mockTvBloc;

  setUp(() {
    mockMovieBloc = MockWatchlistMovieBloc();
    mockTvBloc = MockWatchlistTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<WatchlistMovieBloc>.value(value: mockMovieBloc),
          BlocProvider<WatchlistTvBloc>.value(value: mockTvBloc),
        ],
        child: body,
      ),
    );
  }

  group('WatchlistPage', () {
    testWidgets('should display CircularProgressIndicator when loading', (
      tester,
    ) async {
      when(mockMovieBloc.stream).thenAnswer(
        (_) => Stream.value(
          WatchlistMovieState(
            watchlistState: RequestState.Loading,
            watchlistMovies: [],
            message: '',
          ),
        ),
      );
      when(mockMovieBloc.state).thenReturn(
        WatchlistMovieState(
          watchlistState: RequestState.Loading,
          watchlistMovies: [],
          message: '',
        ),
      );

      when(mockTvBloc.stream).thenAnswer(
        (_) => Stream.value(
          WatchlistTvState(
            watchlistState: RequestState.Loading,
            watchlistTv: [],
            message: '',
          ),
        ),
      );
      when(mockTvBloc.state).thenReturn(
        WatchlistTvState(
          watchlistState: RequestState.Loading,
          watchlistTv: [],
          message: '',
        ),
      );

      await tester.pumpWidget(_makeTestableWidget(const WatchlistPage()));
      await tester.pump();

      // Ada 2 CircularProgressIndicator: Movies + TV
      final loadingIndicators = find.byType(CircularProgressIndicator);
      expect(loadingIndicators, findsNWidgets(2));
    });

    testWidgets(
      'should display ListView with MovieCard and TvCard when loaded',
      (tester) async {
        when(mockMovieBloc.stream).thenAnswer(
          (_) => Stream.value(
            WatchlistMovieState(
              watchlistState: RequestState.Loaded,
              watchlistMovies: testMovieList,
              message: '',
            ),
          ),
        );
        when(mockMovieBloc.state).thenReturn(
          WatchlistMovieState(
            watchlistState: RequestState.Loaded,
            watchlistMovies: testMovieList,
            message: '',
          ),
        );

        when(mockTvBloc.stream).thenAnswer(
          (_) => Stream.value(
            WatchlistTvState(
              watchlistState: RequestState.Loaded,
              watchlistTv: testTvList,
              message: '',
            ),
          ),
        );
        when(mockTvBloc.state).thenReturn(
          WatchlistTvState(
            watchlistState: RequestState.Loaded,
            watchlistTv: testTvList,
            message: '',
          ),
        );

        await tester.pumpWidget(_makeTestableWidget(const WatchlistPage()));
        await tester.pump();

        expect(find.byType(MovieCard), findsNWidgets(testMovieList.length));
        expect(find.byType(TvCard), findsNWidgets(testTvList.length));
      },
    );

    testWidgets('should display empty text when watchlist is empty', (
      tester,
    ) async {
      when(mockMovieBloc.stream).thenAnswer(
        (_) => Stream.value(
          WatchlistMovieState(
            watchlistState: RequestState.Loaded,
            watchlistMovies: [],
            message: '',
          ),
        ),
      );
      when(mockMovieBloc.state).thenReturn(
        WatchlistMovieState(
          watchlistState: RequestState.Loaded,
          watchlistMovies: [],
          message: '',
        ),
      );

      when(mockTvBloc.stream).thenAnswer(
        (_) => Stream.value(
          WatchlistTvState(
            watchlistState: RequestState.Loaded,
            watchlistTv: [],
            message: '',
          ),
        ),
      );
      when(mockTvBloc.state).thenReturn(
        WatchlistTvState(
          watchlistState: RequestState.Loaded,
          watchlistTv: [],
          message: '',
        ),
      );

      await tester.pumpWidget(_makeTestableWidget(const WatchlistPage()));
      await tester.pump();

      expect(find.text('No movies in your watchlist'), findsOneWidget);
      expect(find.text('No TV series in your watchlist'), findsOneWidget);
    });

    testWidgets('should display error message when state is error', (
      tester,
    ) async {
      const movieError = 'Failed to fetch movies';
      const tvError = 'Failed to fetch TV series';

      when(mockMovieBloc.stream).thenAnswer(
        (_) => Stream.value(
          WatchlistMovieState(
            watchlistState: RequestState.Error,
            watchlistMovies: [],
            message: movieError,
          ),
        ),
      );
      when(mockMovieBloc.state).thenReturn(
        WatchlistMovieState(
          watchlistState: RequestState.Error,
          watchlistMovies: [],
          message: movieError,
        ),
      );

      when(mockTvBloc.stream).thenAnswer(
        (_) => Stream.value(
          WatchlistTvState(
            watchlistState: RequestState.Error,
            watchlistTv: [],
            message: tvError,
          ),
        ),
      );
      when(mockTvBloc.state).thenReturn(
        WatchlistTvState(
          watchlistState: RequestState.Error,
          watchlistTv: [],
          message: tvError,
        ),
      );

      await tester.pumpWidget(_makeTestableWidget(const WatchlistPage()));
      await tester.pump();

      expect(find.text(movieError), findsOneWidget);
      expect(find.text(tvError), findsOneWidget);
    });

    testWidgets('should display default SizedBox when state is unknown', (
      tester,
    ) async {
      when(mockMovieBloc.stream).thenAnswer(
        (_) => Stream.value(
          WatchlistMovieState(
            watchlistState: RequestState.Empty,
            watchlistMovies: [],
            message: '',
          ),
        ),
      );
      when(mockMovieBloc.state).thenReturn(
        WatchlistMovieState(
          watchlistState: RequestState.Empty,
          watchlistMovies: [],
          message: '',
        ),
      );

      when(mockTvBloc.stream).thenAnswer(
        (_) => Stream.value(
          WatchlistTvState(
            watchlistState: RequestState.Empty,
            watchlistTv: [],
            message: '',
          ),
        ),
      );
      when(mockTvBloc.state).thenReturn(
        WatchlistTvState(
          watchlistState: RequestState.Empty,
          watchlistTv: [],
          message: '',
        ),
      );

      await tester.pumpWidget(_makeTestableWidget(const WatchlistPage()));
      await tester.pump();

      // Cari SizedBox di Column (bisa lebih dari satu)
      final sizedBoxes = find.byType(SizedBox);
      expect(sizedBoxes, findsWidgets);
    });
  });
}
