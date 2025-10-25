import 'dart:ui';
import 'package:flutter/material.dart';

class BuildError extends StatelessWidget {
  const BuildError({super.key, required String? error, required this.isDark})
    : _error = error;

  final String? _error;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('error'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.red.shade900.withOpacity(0.3)
              : Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'Error: $_error',
          style: TextStyle(
            color: isDark ? Colors.red[200] : Colors.red[800],
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
