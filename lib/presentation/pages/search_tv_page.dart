// ignore_for_file: constant_identifier_names

import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/blocs/tv_search/tv_search_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTvPage extends StatelessWidget {
  static const ROUTE_NAME = '/search-tv';

  const SearchTvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Tv Series')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔍 Search Field
            TextField(
              onSubmitted: (query) {
                // Trigger event ke BLoC
                context.read<TvSearchBloc>().add(OnQueryChanged(query));
              },
              decoration: const InputDecoration(
                hintText: 'Search tv title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text('Search Result', style: kHeading6),
            const SizedBox(height: 8),

            /// 🔄 BLoC Builder untuk menampilkan hasil
            Expanded(
              child: BlocBuilder<TvSearchBloc, TvSearchState>(
                builder: (context, state) {
                  switch (state.state) {
                    case RequestState.Loading:
                      return const Center(child: CircularProgressIndicator());

                    case RequestState.Loaded:
                      final result = state.searchResult;
                      if (result.isEmpty) {
                        return const Center(child: Text('No results found'));
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final tv = result[index];
                          return TvCard(tv);
                        },
                        itemCount: result.length,
                      );

                    case RequestState.Error:
                      return Center(child: Text(state.message));

                    default:
                      return const Center(
                        child: Text('Type a TV series title to search'),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
