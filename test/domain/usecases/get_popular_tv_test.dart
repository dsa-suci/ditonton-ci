import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/common/failure.dart';

// Generate mocks using mockito codegen
@GenerateMocks([TvRepository])
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetPopularTv(mockTvRepository);
  });

  final tTv = Tv(
    id: 1,
    name: 'Test TV',
    overview: 'Overview Test TV',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2025-01-01',
    voteAverage: 8.0,
  );

  final tTvList = <Tv>[tTv];

  test('should get list of popular tv from repository', () async {
    // Arrange
    when(
      mockTvRepository.getPopularTv(),
    ).thenAnswer((_) async => Right<Failure, List<Tv>>(tTvList));

    // Act
    final result = await usecase.execute();

    // Assert
    expect(result.isRight(), true);
    result.fold(
      (_) => fail('Expected Right, got Left'),
      (data) => expect(data, equals(tTvList)),
    );

    verify(mockTvRepository.getPopularTv());
    verifyNoMoreInteractions(mockTvRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    // Arrange
    when(mockTvRepository.getPopularTv()).thenAnswer(
      (_) async => Left<Failure, List<Tv>>(ServerFailure('Server Failure')),
    );

    // Act
    final result = await usecase.execute();

    // Assert
    expect(result.isLeft(), true);
    result.fold((failure) {
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'Server Failure');
    }, (_) => fail('Expected Left, got Right'));

    verify(mockTvRepository.getPopularTv());
    verifyNoMoreInteractions(mockTvRepository);
  });
}
