import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/blocs/tv_list/tv_list_bloc.dart';
import 'package:ditonton/presentation/pages/home_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_object.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvListBloc mockTvListBloc;

  setUp(() {
    mockTvListBloc = MockTvListBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<TvListBloc>.value(value: mockTvListBloc, child: body),
    );
  }

  final tTvList = testTvList; // List<Tv> dari dummy data

  group('HomeTvPage', () {
    testWidgets('should display loading indicator when state is loading', (
      tester,
    ) async {
      when(mockTvListBloc.state).thenReturn(
        TvListState.initial().copyWith(
          nowPlayingState: RequestState.Loading,
          popularState: RequestState.Loading,
          topRatedState: RequestState.Loading,
        ),
      );
      when(mockTvListBloc.stream).thenAnswer(
        (_) => Stream.value(
          TvListState.initial().copyWith(
            nowPlayingState: RequestState.Loading,
            popularState: RequestState.Loading,
            topRatedState: RequestState.Loading,
          ),
        ),
      );

      await tester.pumpWidget(_makeTestableWidget(const HomeTvPage()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
    });

    testWidgets('should display TvList when state is loaded', (tester) async {
      when(mockTvListBloc.state).thenReturn(
        TvListState.initial().copyWith(
          nowPlayingState: RequestState.Loaded,
          nowPlayingTvs: tTvList,
          popularState: RequestState.Loaded,
          popularTvs: tTvList,
          topRatedState: RequestState.Loaded,
          topRatedTvs: tTvList,
        ),
      );
      when(mockTvListBloc.stream).thenAnswer(
        (_) => Stream.value(
          TvListState.initial().copyWith(
            nowPlayingState: RequestState.Loaded,
            nowPlayingTvs: tTvList,
            popularState: RequestState.Loaded,
            popularTvs: tTvList,
            topRatedState: RequestState.Loaded,
            topRatedTvs: tTvList,
          ),
        ),
      );

      await tester.pumpWidget(_makeTestableWidget(const HomeTvPage()));
      await tester.pump();

      // semua section harus memiliki TvList
      expect(find.byType(TvList), findsNWidgets(3));
      // cek ada poster image di TvList
      expect(find.byType(CachedNetworkImage), findsWidgets);
    });

    testWidgets('should display error message when state is error', (
      tester,
    ) async {
      const errorMessage = 'Failed to fetch TV series';
      when(mockTvListBloc.state).thenReturn(
        TvListState.initial().copyWith(
          nowPlayingState: RequestState.Error,
          popularState: RequestState.Error,
          topRatedState: RequestState.Error,
          message: errorMessage,
        ),
      );
      when(mockTvListBloc.stream).thenAnswer(
        (_) => Stream.value(
          TvListState.initial().copyWith(
            nowPlayingState: RequestState.Error,
            popularState: RequestState.Error,
            topRatedState: RequestState.Error,
            message: errorMessage,
          ),
        ),
      );

      await tester.pumpWidget(_makeTestableWidget(const HomeTvPage()));
      await tester.pump();

      expect(find.text(errorMessage), findsNWidgets(3));
    });
  });
}
