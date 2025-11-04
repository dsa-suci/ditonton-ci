import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/common/failure.dart';

@GenerateMocks([TvRepository])
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvDetail usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvDetail(mockTvRepository);
  });

  final tTvDetail = TvDetail(
    id: 1,
    name: 'Test TV',
    overview: 'Overview Test TV',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2025-01-01',
    lastAirDate: '2025-01-10',
    voteAverage: 8.0,
    numberOfSeasons: 2,
    numberOfEpisodes: 10,
    genres: [Genre(id: 1, name: 'Action')],
  );

  test('should get TvDetail from repository successfully', () async {
    // arrange
    when(
      mockTvRepository.getTvDetail(1),
    ).thenAnswer((_) async => Right(tTvDetail));
    // act
    final result = await usecase.execute(1);
    // assert
    expect(result.isRight(), true);
    result.fold(
      (_) => fail('Expected Right, got Left'),
      (data) => expect(data, equals(tTvDetail)),
    );
    verify(mockTvRepository.getTvDetail(1));
    verifyNoMoreInteractions(mockTvRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    // arrange
    when(
      mockTvRepository.getTvDetail(1),
    ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    final result = await usecase.execute(1);
    // assert
    expect(result.isLeft(), true);
    result.fold((failure) {
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'Server Failure');
    }, (_) => fail('Expected Left, got Right'));
    verify(mockTvRepository.getTvDetail(1));
    verifyNoMoreInteractions(mockTvRepository);
  });
}
