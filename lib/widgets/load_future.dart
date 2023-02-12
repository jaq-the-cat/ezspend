import 'package:flutter/material.dart';

Widget loadFuture<T>({
  required Future<T> future,
  required Widget Function (BuildContext context, T? data) builder,
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
      return builder(context, snapshot.data);
    }
  );
}
