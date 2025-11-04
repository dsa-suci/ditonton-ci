import 'package:equatable/equatable.dart';
import '../../domain/entities/tv.dart';

class TvModel extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String firstAirDate;
  final double voteAverage;

  const TvModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.firstAirDate,
    required this.voteAverage,
  });

  factory TvModel.fromJson(Map<String, dynamic> json) => TvModel(
    id: json['id'],
    name: json['name'] ?? '',
    overview: json['overview'] ?? '',
    posterPath: json['poster_path'] ?? '',
    backdropPath: json['backdrop_path'] ?? '',
    firstAirDate: json['first_air_date'] ?? '',
    voteAverage: (json['vote_average'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'overview': overview,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
    'first_air_date': firstAirDate,
    'vote_average': voteAverage,
  };

  /// 🔹 Konversi ke entity
  Tv toEntity() => Tv(
    id: id,
    name: name,
    overview: overview,
    posterPath: posterPath,
    backdropPath: backdropPath,
    firstAirDate: firstAirDate,
    voteAverage: voteAverage,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    overview,
    posterPath,
    backdropPath,
    firstAirDate,
    voteAverage,
  ];
}
