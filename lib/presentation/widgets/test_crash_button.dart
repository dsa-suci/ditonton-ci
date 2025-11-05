import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// Widget tombol untuk memicu crash manual agar bisa diuji di Firebase Crashlytics
class TestCrashButton extends StatelessWidget {
  final String buttonText;

  const TestCrashButton({
    super.key,
    this.buttonText = "Test Crash (Crashlytics)",
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Tambahkan custom key opsional untuk menandai crash
        FirebaseCrashlytics.instance.setCustomKey('test_crash', true);

        // Memicu crash manual
        FirebaseCrashlytics.instance.crash();
      },
      child: Text(buttonText),
    );
  }
}
