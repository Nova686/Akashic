import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:flutter/material.dart';

class ResolvedOnce<T> extends StatefulWidget {
  const ResolvedOnce({required this.resolve, required this.builder, super.key});

  final Future<T> Function() resolve;
  final Widget Function(BuildContext context, T value) builder;

  @override
  State<ResolvedOnce<T>> createState() => _ResolvedOnceState<T>();
}

class _ResolvedOnceState<T> extends State<ResolvedOnce<T>> {
  late final Future<T> _resolution = widget.resolve();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _resolution,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: LabelledSpinner()));
        }
        return widget.builder(context, snapshot.data as T);
      },
    );
  }
}
