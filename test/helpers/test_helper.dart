import 'package:mockito/annotations.dart';
//datasource
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';

//repository
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

//usecases
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';

//bloc
import 'package:ditonton/presentation/blocs/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/blocs/movie_list/movie_list_bloc.dart';
import 'package:ditonton/presentation/blocs/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/blocs/popular_movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/blocs/popular_tv/popular_tv_bloc.dart';
import 'package:ditonton/presentation/blocs/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/blocs/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/blocs/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/blocs/tv_list/tv_list_bloc.dart';
import 'package:ditonton/presentation/blocs/tv_search/tv_search_bloc.dart';
import 'package:ditonton/presentation/blocs/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/blocs/watchlist_tv/watchlist_tv_bloc.dart';

@GenerateMocks([
  DatabaseHelper,
  TvRemoteDataSource,
  TvLocalDataSource,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  TvRepository,
  MovieRepository,
  // Movie UseCases
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
  GetMovieDetail,
  GetMovieRecommendations,
  SaveWatchlist,
  RemoveWatchlist,
  GetWatchListStatus,
  GetWatchlistMovies,
  SearchMovies,
  // TV UseCases
  GetNowPlayingTv,
  GetPopularTv,
  GetTopRatedTv,
  GetTvDetail,
  GetTvRecommendations,
  SaveWatchlistTv,
  RemoveWatchlistTv,
  GetWatchlistStatusTv,
  SearchTv,
  GetWatchlistTv,
  // Bloc
  MovieDetailBloc,
  MovieListBloc,
  MovieSearchBloc,
  PopularMoviesBloc,
  PopularTvBloc,
  TopRatedMoviesBloc,
  TopRatedTvBloc,
  TvDetailBloc,
  TvListBloc,
  TvSearchBloc,
  WatchlistMovieBloc,
  WatchlistTvBloc,
])
void main() {}
