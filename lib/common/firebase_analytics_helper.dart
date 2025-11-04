import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsHelper {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Log event saat user membuka halaman detail movie
  static Future<void> logViewMovieDetail(int movieId, String title) async {
    await _analytics.logEvent(
      name: 'view_movie_detail',
      parameters: {'movie_id': movieId, 'title': title},
    );
  }

  /// Log event saat user menambah movie ke watchlist
  static Future<void> logAddToWatchlist(int movieId, String title) async {
    await _analytics.logEvent(
      name: 'add_to_watchlist',
      parameters: {'movie_id': movieId, 'title': title},
    );
  }

  /// Log event saat user menghapus movie dari watchlist
  static Future<void> logRemoveFromWatchlist(int movieId, String title) async {
    await _analytics.logEvent(
      name: 'remove_from_watchlist',
      parameters: {'movie_id': movieId, 'title': title},
    );
  }

  /// Log event saat user menggunakan fitur pencarian
  static Future<void> logSearch(String query) async {
    await _analytics.logEvent(
      name: 'search_movie',
      parameters: {'query': query},
    );
  }
}
