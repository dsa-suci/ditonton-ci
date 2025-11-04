import 'package:equatable/equatable.dart';
import 'genre.dart';

class TvDetail extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String firstAirDate;
  final String lastAirDate;
  final double voteAverage;
  final int numberOfSeasons;
  final int numberOfEpisodes;
  final List<Genre> genres;

  const TvDetail({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.firstAirDate,
    required this.lastAirDate,
    required this.voteAverage,
    required this.numberOfSeasons,
    required this.numberOfEpisodes,
    required this.genres,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    overview,
    posterPath,
    backdropPath,
    firstAirDate,
    lastAirDate,
    voteAverage,
    numberOfSeasons,
    numberOfEpisodes,
    genres,
  ];
}
