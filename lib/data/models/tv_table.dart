import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TvTable extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String posterPath;

  const TvTable({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
  });

  factory TvTable.fromEntity(TvDetail tv) => TvTable(
    id: tv.id,
    name: tv.name,
    overview: tv.overview,
    posterPath: tv.posterPath,
  );

  factory TvTable.fromMap(Map<String, dynamic> map) => TvTable(
    id: map['id'],
    name: map['name'],
    overview: map['overview'],
    posterPath: map['posterPath'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'overview': overview,
    'posterPath': posterPath,
  };

  Tv toEntity() => Tv.watchlist(
    id: id,
    name: name,
    overview: overview,
    posterPath: posterPath,
  );

  @override
  List<Object?> get props => [id, name, overview, posterPath];
}
