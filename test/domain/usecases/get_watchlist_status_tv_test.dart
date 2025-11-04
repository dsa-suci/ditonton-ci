import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv.dart';

// Generate mocks using mockito codegen
@GenerateMocks([TvRepository])
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistStatusTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetWatchlistStatusTv(mockTvRepository);
  });

  const tId = 1;

  test('should get watchlist status from repository', () async {
    // Arrange: repository returns true
    when(
      mockTvRepository.isAddedToWatchlist(tId),
    ).thenAnswer((_) async => true);

    // Act
    final result = await usecase.execute(tId);

    // Assert
    expect(result, true);
    verify(mockTvRepository.isAddedToWatchlist(tId));
    verifyNoMoreInteractions(mockTvRepository);
  });

  test('should return false when tv is not in watchlist', () async {
    // Arrange: repository returns false
    when(
      mockTvRepository.isAddedToWatchlist(tId),
    ).thenAnswer((_) async => false);

    // Act
    final result = await usecase.execute(tId);

    // Assert
    expect(result, false);
    verify(mockTvRepository.isAddedToWatchlist(tId));
    verifyNoMoreInteractions(mockTvRepository);
  });
}
