import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Tv extends Equatable {
  Tv({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.firstAirDate,
    required this.voteAverage,
  });

  Tv.watchlist({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
  });

  int id;
  String name;
  String overview;
  String posterPath;
  String? backdropPath;
  String? firstAirDate;
  double? voteAverage;

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
