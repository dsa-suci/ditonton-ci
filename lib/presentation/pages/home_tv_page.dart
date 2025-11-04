// ignore_for_file: constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/blocs/tv_list/tv_list_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_page.dart';
import 'package:ditonton/presentation/pages/search_tv_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-series';

  const HomeTvPage({super.key});

  @override
  State<HomeTvPage> createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    // Langsung trigger ambil semua data TV saat halaman pertama dibuka
    Future.microtask(() {
      context.read<TvListBloc>().add(FetchAllTvLists());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTvPage.ROUTE_NAME);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: BlocBuilder<TvListBloc, TvListState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<TvListBloc>().add(FetchAllTvLists());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Text('TV Series', style: kHeading5)),
                  const SizedBox(height: 16),

                  /// 🔹 NOW PLAYING
                  Text('Now Playing', style: kHeading6),
                  _buildTvSection(
                    state.nowPlayingState,
                    state.nowPlayingTvs,
                    state.message,
                  ),
                  const SizedBox(height: 24),

                  /// 🔹 POPULAR
                  _buildSubHeading(
                    title: 'Popular',
                    onTap: () =>
                        Navigator.pushNamed(context, PopularTvPage.ROUTE_NAME),
                  ),
                  _buildTvSection(
                    state.popularState,
                    state.popularTvs,
                    state.message,
                  ),
                  const SizedBox(height: 24),

                  /// 🔹 TOP RATED
                  _buildSubHeading(
                    title: 'Top Rated',
                    onTap: () =>
                        Navigator.pushNamed(context, TopRatedTvPage.ROUTE_NAME),
                  ),
                  _buildTvSection(
                    state.topRatedState,
                    state.topRatedTvs,
                    state.message,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 🔸 Drawer (sidebar)
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: const AssetImage('assets/circle-g.png'),
              backgroundColor: Colors.grey.shade900,
            ),
            accountName: const Text('Ditonton'),
            accountEmail: const Text('ditonton@dicoding.com'),
            decoration: BoxDecoration(color: Colors.grey.shade900),
          ),
          ListTile(
            leading: const Icon(Icons.movie),
            title: const Text('Movies'),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.tv),
            title: const Text('TV Series'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.save_alt),
            title: const Text('Watchlist'),
            onTap: () {
              Navigator.pushNamed(context, WatchlistPage.ROUTE_NAME);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
            },
          ),
        ],
      ),
    );
  }

  /// 🔸 Widget untuk tiap section (Now Playing, Popular, Top Rated)
  Widget _buildTvSection(RequestState state, List<Tv> tvs, String message) {
    switch (state) {
      case RequestState.Loading:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Center(child: CircularProgressIndicator()),
        );
      case RequestState.Loaded:
        return TvList(tvs);
      case RequestState.Error:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  /// 🔸 Judul section dengan tombol “See More”
  Row _buildSubHeading({required String title, required VoidCallback onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kHeading6),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: const [
                Text('See More'),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 🔹 List horizontal TV
class TvList extends StatelessWidget {
  final List<Tv> tvs;
  const TvList(this.tvs, {super.key});

  @override
  Widget build(BuildContext context) {
    if (tvs.isEmpty) {
      return const Center(child: Text('No TV Series Available'));
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tvs.length,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${tv.posterPath}',
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, color: Colors.red),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
