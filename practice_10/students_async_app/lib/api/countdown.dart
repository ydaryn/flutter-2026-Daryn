import 'package:flutter/foundation.dart';

// Level 4: a stream that produces one number per second.
Stream<int> countdown(int from) async* {
  for (var i = from; i >= 0; i--) {
    await Future.delayed(const Duration(seconds: 1));
    yield i;
    // After the yield: if this line stops printing, the generator stopped.
    debugPrint('tick $i');
  }
}
