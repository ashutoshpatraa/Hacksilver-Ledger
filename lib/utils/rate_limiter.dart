import 'package:flutter/foundation.dart';

/// Rate limiting service for security-sensitive operations
class RateLimiter {
  final Map<String, DateTime> _windowExpiry = {};
  final Map<String, int> _counts = {};

  /// Check if operation is rate-limited
  bool isRateLimited(String key, {int maxRequests = 60, Duration window = const Duration(minutes: 1)}) {
    final now = DateTime.now();
    final expiry = _windowExpiry[key];

    // Reset if window expired or doesn't exist
    if (expiry == null || now.isAfter(expiry)) {
      _windowExpiry[key] = now.add(window);
      _counts[key] = 0;
      return false;
    }

    return (_counts[key] ?? 0) >= maxRequests;
  }

  /// Increment request count
  void incrementRequest(String key) {
    _counts[key] = (_counts[key] ?? 0) + 1;
    debugPrint('[$key] Request count: ${_counts[key]}');
  }

  /// Get current count
  int getRequestCount(String key) {
    return _counts[key] ?? 0;
  }

  /// Clear rate limiter for a key
  void clear(String key) {
    _windowExpiry.remove(key);
    _counts.remove(key);
  }

  /// Clear all rate limiters
  void clearAll() {
    _windowExpiry.clear();
    _counts.clear();
  }
}

/// Global rate limiter instance
final rateLimiter = RateLimiter();

/// Annotated rate limiter for different operations
class OperationRateLimiter {
  static const _maxRequests = {
    'sync': 60,
    'backup': 5,
    'restore': 3,
    'export': 10,
  };

  static const _windows = {
    'sync': Duration(minutes: 1),
    'backup': Duration(hours: 1),
    'restore': Duration(hours: 1),
    'export': Duration(hours: 1),
  };

  /// Check if operation is allowed
  static bool isAllowed(String operation) {
    final max = _maxRequests[operation];
    final window = _windows[operation];
    if (max == null || window == null) return true; // No limit

    return !rateLimiter.isRateLimited(
      'op:$operation',
      maxRequests: max,
      window: window,
    );
  }

  /// Record operation
  static void record(String operation) {
    rateLimiter.incrementRequest('op:$operation');
  }

  /// Get remaining attempts
  static int getRemaining(String operation) {
    final max = _maxRequests[operation];
    if (max == null) return -1;

    final count = rateLimiter.getRequestCount('op:$operation');
    return max - count;
  }
}