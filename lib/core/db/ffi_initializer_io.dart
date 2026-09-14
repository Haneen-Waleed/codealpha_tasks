import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// On desktop (Windows/Linux/macOS) the `sqflite` plugin has no native
/// implementation, so nothing ever registers a `databaseFactory` and every
/// database call throws `Bad state: databaseFactory not initialized`. This
/// registers the FFI-backed factory to fix that.
///
/// On Android/iOS this is intentionally a no-op — the plugin already
/// registers its own native factory there, and overriding it is unnecessary.
void initializeDesktopDatabaseFactoryIfNeeded() {
  if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}
