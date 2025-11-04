// ignore_for_file: constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:ditonton/presentation/blocs/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/blocs/watchlist_tv/watchlist_tv_bloc.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist';

  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    // Ambil data watchlist saat halaman pertama kali dibuka
    Future.microtask(() {
      context.read<WatchlistMovieBloc>().add(FetchWatchlistMovies());
      context.read<WatchlistTvBloc>().add(FetchWatchlistTv());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    // Refresh data saat kembali dari halaman detail
    context.read<WatchlistMovieBloc>().add(FetchWatchlistMovies());
    context.read<WatchlistTvBloc>().add(FetchWatchlistTv());
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Watchlist')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------- MOVIES ----------------
            Text('Movies', style: kHeading6.copyWith(fontSize: 20)),
            const SizedBox(height: 8),

            BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
              builder: (context, state) {
                if (state.watchlistState == RequestState.Loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.watchlistState == RequestState.Loaded) {
                  if (state.watchlistMovies.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: Text('No movies in your watchlist')),
                    );
                  }
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.watchlistMovies.length,
                    itemBuilder: (context, index) {
                      final movie = state.watchlistMovies[index];
                      return MovieCard(movie);
                    },
                  );
                } else if (state.watchlistState == RequestState.Error) {
                  return Center(child: Text(state.message));
                } else {
                  return const SizedBox();
                }
              },
            ),

            const SizedBox(height: 24),

            /// ---------------- TV SERIES ----------------
            Text('TV Series', style: kHeading6.copyWith(fontSize: 20)),
            const SizedBox(height: 8),

            BlocBuilder<WatchlistTvBloc, WatchlistTvState>(
              builder: (context, state) {
                if (state.watchlistState == RequestState.Loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.watchlistState == RequestState.Loaded) {
                  if (state.watchlistTv.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text('No TV series in your watchlist'),
                      ),
                    );
                  }
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.watchlistTv.length,
                    itemBuilder: (context, index) {
                      final tv = state.watchlistTv[index];
                      return TvCard(tv);
                    },
                  );
                } else if (state.watchlistState == RequestState.Error) {
                  return Center(child: Text(state.message));
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
