import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/blocs/movie_list/movie_list_bloc.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_object.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockMovieListBloc mockMovieListBloc;

  setUp(() {
    mockMovieListBloc = MockMovieListBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<MovieListBloc>.value(
        value: mockMovieListBloc,
        child: body,
      ),
    );
  }

  group('HomeMoviePage', () {
    final List<Movie> tMovies = testMovieList;

    testWidgets('should display loading indicators when state is loading', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockMovieListBloc.state).thenReturn(MovieListLoading());
      when(
        mockMovieListBloc.stream,
      ).thenAnswer((_) => Stream.value(MovieListLoading()));

      // Act
      await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));
      await tester.pump();

      // Assert: ada 3 progress indicators untuk NowPlaying, Popular, TopRated
      expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
    });

    testWidgets('should display MovieList when now playing movies are loaded', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockMovieListBloc.state).thenReturn(MovieNowPlayingLoaded(tMovies));
      when(
        mockMovieListBloc.stream,
      ).thenAnswer((_) => Stream.value(MovieNowPlayingLoaded(tMovies)));

      // Act
      await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));
      await tester.pump();

      // Assert
      // cek MovieList muncul
      expect(find.byType(MovieList), findsOneWidget);
      // cek ada poster image di MovieList
      expect(find.byType(CachedNetworkImage), findsWidgets);
    });

    testWidgets('should display error message when state is error', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(
        mockMovieListBloc.state,
      ).thenReturn(MovieListError('Failed to fetch movies'));
      when(mockMovieListBloc.stream).thenAnswer(
        (_) => Stream.value(MovieListError('Failed to fetch movies')),
      );

      // Act
      await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));
      await tester.pump();

      // Assert
      expect(
        find.text('Failed to fetch movies'),
        findsNWidgets(3),
      ); // muncul 3 karena untuk 3 section
    });
  });
}
