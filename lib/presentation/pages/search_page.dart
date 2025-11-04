import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/blocs/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Input search
            TextField(
              onSubmitted: (query) {
                context.read<MovieSearchBloc>().add(OnQueryChanged(query));
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text('Search Result', style: kHeading6),
            const SizedBox(height: 8),

            // 🔁 BlocBuilder untuk menampilkan hasil pencarian
            Expanded(
              child: BlocBuilder<MovieSearchBloc, MovieSearchState>(
                builder: (context, state) {
                  if (state is MovieSearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MovieSearchHasData) {
                    final List<Movie> results = state.result;
                    if (results.isEmpty) {
                      return const Center(child: Text('No movies found'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final movie = results[index];
                        return MovieCard(movie);
                      },
                    );
                  } else if (state is MovieSearchError) {
                    return Center(child: Text(state.message));
                  } else if (state is MovieSearchEmpty) {
                    return const Center(child: Text('Search for a movie...'));
                  } else {
                    return const SizedBox();
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
