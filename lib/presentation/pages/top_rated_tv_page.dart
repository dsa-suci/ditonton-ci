// ignore_for_file: constant_identifier_names, library_private_types_in_public_api

import 'package:ditonton/presentation/blocs/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv';

  const TopRatedTvPage({super.key});

  @override
  _TopRatedTvPageState createState() => _TopRatedTvPageState();
}

class _TopRatedTvPageState extends State<TopRatedTvPage> {
  @override
  void initState() {
    super.initState();
    // Jalankan event fetch begitu halaman diinisialisasi
    Future.microtask(() {
      context.read<TopRatedTvBloc>().add(FetchTopRatedTv());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Rated TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
          builder: (context, state) {
            if (state is TopRatedTvLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TopRatedTvHasData) {
              final tvList = state.result;
              return ListView.builder(
                itemCount: tvList.length,
                itemBuilder: (context, index) {
                  final tv = tvList[index];
                  return TvCard(tv);
                },
              );
            } else if (state is TopRatedTvError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const Center(child: Text('No Data Available'));
            }
          },
        ),
      ),
    );
  }
}
