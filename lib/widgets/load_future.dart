import 'package:flutter/material.dart';

Widget loadFuture<T>({
  required Future<T> future,
  Widget Function(BuildContext context, T? data)? builder,
  void Function(T? data)? onComplete,
  Widget? loading,
  Widget? noData,
}) {
  return FutureBuilder<T>(
    future: future,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return loading ?? Container();
      }
      if (noData != null && !snapshot.hasData) {
        return noData;
      }
      if (builder != null) {
        return builder(context, snapshot.data);
      }
      if (onComplete != null) {
        onComplete(snapshot.data);
      }
      return const Text("we shouldnt be here");
    }
  );
}
