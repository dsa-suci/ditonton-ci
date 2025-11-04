import 'package:equatable/equatable.dart';
import '../../domain/entities/tv_detail.dart';
import 'genre_model.dart';

class TvDetailModel extends Equatable {
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
  final List<GenreModel> genres;

  const TvDetailModel({
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

  factory TvDetailModel.fromJson(Map<String, dynamic> json) => TvDetailModel(
    id: json['id'],
    name: json['name'],
    overview: json['overview'],
    posterPath: json['poster_path'] ?? '',
    backdropPath: json['backdrop_path'] ?? '',
    firstAirDate: json['first_air_date'] ?? '',
    lastAirDate: json['last_air_date'] ?? '',
    voteAverage: (json['vote_average'] as num).toDouble(),
    numberOfSeasons: json['number_of_seasons'] ?? 0,
    numberOfEpisodes: json['number_of_episodes'] ?? 0,
    genres: List<GenreModel>.from(
      (json['genres'] as List).map((x) => GenreModel.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'overview': overview,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
    'first_air_date': firstAirDate,
    'last_air_date': lastAirDate,
    'vote_average': voteAverage,
    'number_of_seasons': numberOfSeasons,
    'number_of_episodes': numberOfEpisodes,
    'genres': genres.map((x) => x.toJson()).toList(),
  };

  /// 🔹 Convert ke Entity
  TvDetail toEntity() => TvDetail(
    id: id,
    name: name,
    overview: overview,
    posterPath: posterPath,
    backdropPath: backdropPath,
    firstAirDate: firstAirDate,
    lastAirDate: lastAirDate,
    voteAverage: voteAverage,
    numberOfSeasons: numberOfSeasons,
    numberOfEpisodes: numberOfEpisodes,
    genres: genres.map((g) => g.toEntity()).toList(),
  );

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
