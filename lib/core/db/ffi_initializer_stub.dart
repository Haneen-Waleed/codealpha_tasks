/// Web build of the database-factory initializer.
///
/// `sqflite_common_ffi` depends on `dart:ffi`, which — like `dart:io` —
/// cannot be compiled for web at all. This file is a no-op stub so the web
/// build never even sees that import. Web is not a supported platform for
/// this app regardless (see `main.dart`'s unsupported-platform screen),
/// since `sqflite` itself has no web storage engine.
void initializeDesktopDatabaseFactoryIfNeeded() {}
