import 'package:flutter/material.dart';

/// Shared loading indicator.
/// TODO: implement.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
